const { test } = require('node:test');
const assert = require('node:assert/strict');
const { readFileSync } = require('node:fs');
const { join } = require('node:path');
const vm = require('node:vm');

function setup(storage) {
  const context = vm.createContext({ window: {} });
  for (const file of ['fixtures.js', 'mock-api.js', 'api.js']) {
    vm.runInContext(readFileSync(join(__dirname, '../../src/main/webapp/js/market', file), 'utf8'), context, { filename: file });
  }
  const { EchoMarketApi, EchoMarketMock } = context.window;
  return {
    connect: EchoMarketApi.connect,
    api: EchoMarketApi.connect({ createAdapter: EchoMarketMock.createMockApi, storage }),
  };
}

test('the adapter seam rejects missing methods up front', () => {
  const { connect, api } = setup();
  assert.equal(connect({ createAdapter: () => api }), api);
  assert.throws(() => connect({ createAdapter: () => ({ account: {} }) }), /account.currentId/);
  assert.throws(() => connect({ createAdapter: () => ({ ...api, catalog: {} }) }), /catalog.categories/);
});

test('read results are detached from mock state', () => {
  const { api } = setup();
  const item = api.catalog.find('101');
  item.title = '外部更改';
  assert.notEqual(api.catalog.find('101').title, item.title);
  const ids = api.favorites.ids();
  ids.push('999');
  assert.ok(!api.favorites.ids().includes('999'));
  assert.equal(api.catalog.find('missing'), null);
});

test('local account changes never save a password and storage failures remain usable', () => {
  const storage = { getItem: () => null, setItem(_key, json) { this.json = json; } };
  const { api } = setup(storage);
  const result = api.account.register({ username: 'sample', nickname: '样例', password: 'local-form-only', confirmPassword: 'local-form-only' });
  assert.equal(result.persisted, true);
  assert.equal(api.account.currentId(), 'sample');
  assert.equal(JSON.parse(storage.json).accounts.sample.nickname, '样例');
  assert.ok(!storage.json.includes('local-form-only'));
  const offline = setup({ getItem() { throw Error('blocked'); }, setItem() { throw Error('blocked'); } }).api;
  assert.equal(offline.favorites.toggle('102').persisted, false);
  assert.ok(offline.favorites.ids().includes('102'));
});

test('saved demo state still resolves images after migration into webapp', () => {
  const storage = { getItem() { return this.json ?? null; }, setItem(_key, json) { this.json = json; } };
  setup(storage).api.favorites.toggle('102');
  const saved = JSON.parse(storage.json);
  saved.products.find((item) => item.id === '101').image = './preview-assets/headphones.jpg';
  saved.products.find((item) => item.id === '108').image = './src/main/webapp/images/HUAWEI_MateBook_14.png';
  storage.json = JSON.stringify(saved);
  const { api } = setup(storage);
  assert.equal(api.catalog.find('101').image, './images/market/headphones.jpg');
  assert.equal(api.catalog.find('108').image, './images/HUAWEI_MateBook_14.png');
  assert.ok(api.favorites.ids().includes('102'));
});

test('mock enforces current viewer and order/report transitions independently of the DOM', () => {
  const { api } = setup();
  assert.throws(() => api.orders.transition('26002', 'confirm'), { code: 'conflict' });
  assert.equal(api.orders.transition('26002', 'ship').value.status, 2);
  api.account.login({ username: 'tang' });
  assert.equal(api.orders.transition('26002', 'confirm').value.status, 3);
  assert.throws(() => api.reports.handle('601', 1), { code: 'forbidden' });
  api.account.logout();
  assert.equal(api.orders.list().length, 0);
  assert.throws(() => api.favorites.toggle('101'), { code: 'unauthorized' });
});
