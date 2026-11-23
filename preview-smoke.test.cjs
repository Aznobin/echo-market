// Run with Node 22+: node --test --test-isolation=none preview-smoke.test.cjs
// Exercises the HTML/JS contract without a server, external packages, or browser control.
const { test } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const path = require('node:path');
const read = (file) => fs.readFileSync(path.join(__dirname, file), 'utf8');
const html = read('index.html');
const scripts = Array.from(html.matchAll(/<script src="([^"]+)"><\/script>/g), (m) => m[1]);
const script = scripts.map(read).join('\n');

function boot(hash = '', storage = new Map()) {
  const element = () => ({ dataset: {}, handler: {}, innerHTML: '', firstElementChild: {},
    querySelector() { return null; }, querySelectorAll() { return []; },
    addEventListener(name, cb) { this.handler[name] = cb; },
    setAttribute(key, value) { this[key] = value; }, contains() { return false; }, focus() {},
  });
  const nodes = Object.fromEntries(Array.from(html.matchAll(/\bid="([^"]+)"/g), (m) => ['#' + m[1], element()]));
  const document = Object.assign(element(), { documentElement: element(), querySelector: (q) => nodes[q] });
  const dialog = nodes['#confirm-dialog'];
  dialog.showModal = () => { dialog.open = true; };
  dialog.querySelector = (q) => nodes[q];
  const window = element();
  window.scrollTo = () => {};
  const location = { hash };
  const localStorage = { getItem: (key) => storage.get(key), setItem: (key, value) => storage.set(key, value) };
  const FormData = class { constructor(form) { this.values = form.values; } get(key) { return this.values[key]; } };
  vm.runInNewContext(script, { window, document, location, localStorage, FormData, setTimeout() {}, clearTimeout() {}, requestAnimationFrame: (fn) => fn() });
  document.handler.DOMContentLoaded();
  return {
    nodes, location, storage,
    view: () => nodes['#view'].innerHTML,
    navigate(next) { location.hash = next; window.handler.hashchange(); },
    action(action, value, compact) {
      const button = element();
      Object.assign(button.dataset, { action, value, compact });
      button.classList = { remove() {}, add() {} };
      document.handler.click({ target: { closest: (q) => q === '[data-action]' ? button : null } });
      return button;
    },
    submit(form, values) {
      const el = element();
      const error = element();
      el.dataset.form = form;
      el.values = values;
      el.matches = () => true;
      el.querySelector = (q) => q === '[data-error]' ? error : null;
      document.handler.submit({ target: el, preventDefault() {} });
      return error;
    },
    approve() { assert.equal(dialog.open, true); dialog.returnValue = 'confirm'; dialog.open = false; dialog.handler.close(); },
    theme: () => document.documentElement.dataset.theme,
  };
}

test('standalone entry reaches all original UI surfaces and local assets', () => {
  const app = boot();
  assert.equal(app.theme(), 'light');
  assert.match(app.view(), /校园好物/);
  for (const asset of [...html.matchAll(/(?:src|href)="([^"#]+\.(?:js|css))"/g), ...script.matchAll(/'(\.\/[^']+\.(?:jpg|png))'/g)]) {
    assert.ok(fs.existsSync(path.join(__dirname, asset[1])), asset[1]);
  }
  for (const [route, title] of Object.entries({
    'productdetail/101': '商品详情', productadd: '发布闲置商品', favorites: '我的收藏',
    messages: '消息中心', 'messagethread/yan/101': '还在。可以呀', myorders: '我买到的订单',
    soldorders: '我卖出的订单', 'orderbuyerinfo/101': '确认订单', 'orderdetail/26001': '这笔订单的评价',
    'ordersuccess/26001': '订单已提交', 'ratings/xiaoman': '收到的评价', reports: '我提交过的举报',
    'reportadd/2/101': '提交举报', adminreports: '举报处理', welcome: '欢迎，小满', login: '登录', register: '注册',
  })) {
    app.navigate('#' + route);
    assert.ok(app.view().includes(title), route);
    assert.doesNotMatch(app.view(), /<%|\.jsp/);
  }
});

test('theme and favorites are saved and restored across loads', () => {
  const app = boot();
  app.nodes['#theme-toggle'].handler.click();
  assert.equal(app.theme(), 'dark');
  assert.equal(app.action('favorite', '102', 'true')['aria-pressed'], 'true');
  const reopened = boot('#favorites', app.storage);
  assert.equal(reopened.theme(), 'dark');
  assert.match(reopened.view(), /索尼微单相机/);
});

test('checkout, seller handoff, receipt and rating preserve roles and states', () => {
  const app = boot('#orderbuyerinfo/101');
  app.submit('checkout', { productId: '101', receiverName: '小满', phone: '演示号', address: '图书馆', deliveryType: 'meetup', payMethod: 'cod' });
  app.approve();
  const id = app.location.hash.split('/')[1];
  assert.match(app.location.hash, /^#ordersuccess\/\d+$/);
  app.navigate('#orderdetail/' + id);
  assert.doesNotMatch(app.view(), /data-action="order-ship"/);
  app.navigate('#login');
  app.submit('login', { username: 'yan' });
  app.navigate('#orderdetail/' + id);
  assert.match(app.view(), /data-action="order-ship"/);
  app.action('order-ship', id);
  app.approve();
  app.navigate('#login');
  app.submit('login', { username: 'xiaoman' });
  app.navigate('#orderdetail/' + id);
  app.action('order-confirm', id);
  app.approve();
  assert.match(app.view(), /提交评价/);
  app.submit('rating', { orderId: id, score: '5', content: '<示例>' });
  assert.match(app.view(), /&lt;示例&gt;/);
  assert.match(app.view(), /你已评价过/);
});

test('messages reach counterpart and reports update the submitter view', () => {
  const app = boot('#messagethread/yan/101');
  app.submit('message', { productId: '101', otherId: 'yan', content: '校内见。' });
  app.navigate('#login');
  app.submit('login', { username: 'yan' });
  app.navigate('#messagethread/xiaoman/101');
  assert.match(app.view(), /校内见。/);
  app.navigate('#adminreports');
  assert.match(app.view(), /仅供管理员/);
  app.navigate('#reportadd/2/103');
  app.submit('report', { targetId: '103', targetType: '2', reason: '待补充细节照片。' });
  app.navigate('#login');
  app.submit('login', { username: 'xiaoman' });
  app.navigate('#adminreports');
  const latest = JSON.parse(app.storage.get('echo-market.preview.data.v1')).reports[0];
  app.action('report-2', latest.id);
  app.navigate('#login');
  app.submit('login', { username: 'yan' });
  app.navigate('#reports');
  assert.match(app.view(), /已驳回/);
});
