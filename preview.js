(() => {
  'use strict';

  // A classic script, so the same entry works on file:// and on a static host.
  const themeKey = 'echo-market.preview.theme';
  const storeKey = 'echo-market.preview.data.v1';
  function readLocal(key) { try { return localStorage.getItem(key); } catch { return null; } }
  function writeLocal(key, value) { try { localStorage.setItem(key, value); return true; } catch { return false; } }
  document.documentElement.dataset.theme = readLocal(themeKey) === 'dark' ? 'dark' : 'light';

  document.addEventListener('DOMContentLoaded', () => {
    const main = document.querySelector('#view');
    const profile = document.querySelector('#profile');
    const theme = document.querySelector('#theme-toggle');
    const toast = document.querySelector('#toast');
    const dialog = document.querySelector('#confirm-dialog');
    let toastTimer, pending, observer;
    const users = {
      xiaoman: { username: 'xiaoman', nickname: '小满', admin: true },
      yan: { username: 'yan', nickname: '晚自习的阿言' },
      he: { username: 'he', nickname: '小何同学' },
      lin: { username: 'lin', nickname: '林间' },
      tang: { username: 'tang', nickname: '糖炒栗子' },
    };
    const categories = ['教材书籍', '电子数码', '生活用品', '服饰鞋包', '运动器材', '美妆个护', '其他闲置'];
    const photos = {
      headphones: './preview-assets/headphones.jpg', camera: './preview-assets/camera.jpg',
      books: './preview-assets/books.jpg', sneakers: './preview-assets/sneakers.jpg',
      lamp: './preview-assets/lamp.jpg', bicycle: './preview-assets/bicycle.jpg',
      bag: './preview-assets/bag.jpg', laptop: './src/main/webapp/images/HUAWEI_MateBook_14.png',
      illustration: './src/main/webapp/images/115411842_p0.jpg',
    };
    const product = (id, title, price, categoryId, image, seller, description, sold = false) => ({ id, title, price, categoryId, image: photos[image], kind: image, seller, description, sold });
    const demo = {
      me: 'xiaoman', accounts: {},
      products: [
        product('101', '头戴式无线耳机', 159, 2, 'headphones', 'yan', '耳罩和头梁无破损，附充电线。可以在图书馆门口先试听再决定。'),
        product('102', '索尼微单相机', 680, 2, 'camera', 'he', '日常拍社团活动用的相机，快门和显示正常。想要看样片可以先私信我。'),
        product('103', '课外阅读闲置书 · 一组', 36, 1, 'books', 'lin', '换宿舍想给书架腾点地方。书页没有破损，有几本有少量铅笔批注。'),
        product('104', '轻便跑鞋 · 42 码', 120, 4, 'sneakers', 'tang', '只在操场穿过几次，鞋底磨损轻微。适合日常走路或短距离慢跑。'),
        product('105', '宿舍桌面台灯', 35, 3, 'lamp', 'lin', '可调整照明角度，开关正常。搬宿舍前出，竹园楼下自提。'),
        product('106', '校内通勤自行车', 260, 5, 'bicycle', 'he', '上课代步用，刹车和车铃正常。可以在操场外试骑。'),
        product('107', '日常通勤双肩包', 58, 4, 'bag', 'tang', '夹层能放 14 寸电脑，拉链完好。可在食堂门口交接。'),
        product('108', 'HUAWEI MateBook 14 鸿蒙版', 3200, 2, 'laptop', 'yan', '14 寸笔记本，含适配器。样图为原项目素材，成色请以面交验机为准。'),
        product('109', '初音主题明信片', 12, 7, 'illustration', 'xiaoman', '社团交换留存的主题卡，校内当面交接。', true),
        product('110', '室友转出的阅读灯', 23, 3, 'lamp', 'lin', '在宿舍用了一学期，已校内面交。', true),
        product('111', '红色运动鞋 · 41 码', 80, 4, 'sneakers', 'xiaoman', '样板中用于展示买家付款后、卖家待发货的订单。', true),
      ],
      favorites: { xiaoman: ['101', '104'] },
      threads: [
        { owner: 'xiaoman', productId: '101', other: 'yan', unread: true, items: [
          { from: 'xiaoman', text: '请问耳机还在吗？周三傍晚能面交吗？', time: '昨天 18:20' },
          { from: 'yan', text: '还在。可以呀，六点在图书馆门口见？你可以先试一下。', time: '昨天 18:26' },
        ] },
        { owner: 'xiaoman', productId: '105', other: 'lin', unread: false, items: [
          { from: 'lin', text: '台灯可以在竹园楼下交接，出门前给我发条消息就好。', time: '昨天 16:40' },
        ] },
      ],
      orders: [
        { id: '26001', productId: '110', buyer: 'xiaoman', seller: 'lin', amount: 23, status: 3, deliveryType: 'meetup', payMethod: 'cod', receiverName: '小满', phone: '演示号码', address: '竹园一号楼', remark: '', time: '11 月 20 日 18:26' },
        { id: '26002', productId: '111', buyer: 'tang', seller: 'xiaoman', amount: 80, status: 1, deliveryType: 'dorm', payMethod: 'online', receiverName: '糖炒栗子', phone: '演示号码', address: '竹园三号楼', remark: '请先在站内联系。', time: '11 月 21 日 15:52' },
        { id: '26003', productId: '109', buyer: 'he', seller: 'xiaoman', amount: 12, status: 3, deliveryType: 'meetup', payMethod: 'cod', receiverName: '小何同学', phone: '演示号码', address: '南食堂门口', remark: '', time: '11 月 21 日 12:30' },
      ],
      ratings: [
        { orderId: '26001', from: 'lin', to: 'xiaoman', score: 5, content: '按约定时间到的，沟通很顺畅。', time: '11 月 20 日' },
        { orderId: '26003', from: 'he', to: 'xiaoman', score: 5, content: '明信片保存得很好，谢谢！', time: '11 月 21 日' },
      ],
      reports: [
        { id: '601', from: 'he', targetType: 2, targetId: '103', reason: '希望补充书页细节图，方便判断批注情况。', status: 0, time: '11 月 20 日' },
        { id: '602', from: 'xiaoman', targetType: 2, targetId: '105', reason: '希望确认台灯的实际交接地点。', status: 1, time: '11 月 21 日' },
      ],
    };
    let state = demo;
    try { const saved = JSON.parse(readLocal(storeKey)); if (saved && Array.isArray(saved.products)) state = saved; } catch { /* start with examples */ }
    const save = () => writeLocal(storeKey, JSON.stringify(state));
    const esc = (value) => String(value ?? '').replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[c]);
    const user = (id) => (Object.hasOwn(users, id) && users[id]) || (Object.hasOwn(state.accounts, id) && state.accounts[id]) || { username: id };
    const name = (id) => user(id).nickname?.trim() || user(id).username || '访客';
    const avatar = (id, size = '') => `<span class="avatar ${size}" aria-hidden="true">User${user(id).avatarUrl ? `<img src="${esc(user(id).avatarUrl)}" alt="">` : ''}</span>`;
    const identity = (id, size = '') => `<span class="identity">${avatar(id, size)}<span class="name">${esc(name(id))}</span></span>`;
    const now = () => new Intl.DateTimeFormat('zh-CN', { month: 'numeric', day: 'numeric', hour: '2-digit', minute: '2-digit' }).format(new Date());
    const uid = () => String(Date.now());
    const listing = (id) => state.products.find((p) => p.id === id);
    const orderFor = (id) => state.orders.find((o) => o.id === id);
    const orderStatus = ['待付款', '待发货', '待收货', '已完成', '已取消'];
    const reportStatus = ['待处理', '已处理', '已驳回'];
    const deliveryLabel = { meetup: '校内当面交易', dorm: '送货到宿舍楼下' };
    const payLabel = { online: '在线担保支付（演示）', cod: '当面验货付款' };
    const money = (n) => `<span class="price"><small>¥</small>${Number(n).toLocaleString('zh-CN', { maximumFractionDigits: 2 })}</span>`;
    const route = (page, ...params) => '#' + [page, ...params].map(encodeURIComponent).join('/');
    const go = (page, ...params) => { const next = route(page, ...params); if (location.hash === next) render(); else location.hash = next; };
    const link = (text, href, classes = 'text-link') => `<a class="${classes}" href="${esc(href)}">${esc(text)}</a>`;
    const button = (text, action, value, primary = false) => `<button class="btn${primary ? ' primary' : ''}" type="button" data-action="${action}" data-value="${esc(value)}">${esc(text)}</button>`;
    const tag = (text, stateTag = false) => `<span class="tag${stateTag ? ' state' : ''}">${esc(text)}</span>`;
    const head = (title, sub = '', back = '') => `<header class="page-head">${back}<h1>${esc(title)}</h1>${sub ? `<p>${esc(sub)}</p>` : ''}</header>`;
    const empty = (title, detail, action = '') => `<section class="empty"><h2>${esc(title)}</h2><p>${esc(detail)}</p>${action ? `<div class="actions">${action}</div>` : ''}</section>`;
    const browse = () => link('浏览商品', route('products'), 'btn');
    const field = (label, html) => `<label class="field"><span>${label}</span>${html}</label>`;
    const errorLine = '<p class="field-error" data-error role="alert" hidden></p>';
    const notice = (text) => `<p class="notice">${esc(text)}</p>`;
    const back = (text, href) => link(`← ${text}`, href, 'crumb');
    const photo = (p, classes = '', lazy = false) => `${p.image ? `<img src="${esc(p.image)}" alt="${esc(p.title)}"${lazy ? ' loading="lazy"' : ''}>` : '<span class="photo-empty">暂无商品图片</span>'}`;
    const media = (p, classes = '') => `<div class="product-media ${p.kind || ''} ${classes}">${photo(p)}</div>`;
    const savedIds = () => state.me && Object.hasOwn(state.favorites, state.me) ? state.favorites[state.me] : [];
    const heart = (p, compact) => {
      const saved = savedIds().includes(p.id);
      return `<button type="button" class="${compact ? 'heart' : 'btn'}" data-action="favorite" data-value="${esc(p.id)}" data-compact="${compact}" aria-pressed="${saved}" aria-label="${esc((saved ? '取消收藏：' : '收藏：') + p.title)}">${compact ? (saved ? '♥' : '♡') : (saved ? '取消收藏' : '收藏商品')}</button>`;
    };
    const productGrid = (items) => `<div class="product-grid">${items.map((p, i) => `<article class="product-card" data-reveal style="--delay:${i % 4 * 45}ms"><a class="product-media ${p.kind || ''}" href="${route('productdetail', p.id)}">${photo(p, '', i >= 4)}</a><div class="card-copy"><div class="card-top">${tag(categories[p.categoryId - 1] || '其他闲置')}${money(p.price)}</div><h3>${link(p.title, route('productdetail', p.id), '')}</h3><div class="card-bottom">${identity(p.seller, 'mini')}${heart(p, true)}</div></div></article>`).join('')}</div>`;

    function market(favorites = false) {
      if (favorites) {
        const items = state.products.filter((p) => savedIds().includes(p.id));
        return head('我的收藏', '留待下次再看的校园闲置。') + (items.length ? productGrid(items) : empty('暂时没有收藏', '在商品图片下点一下爱心，就能在这里找到它。', browse()));
      }
      const items = state.products.filter((p) => !p.sold);
      return `<section class="hero"><div class="hero-copy enter"><p class="kicker">CAMPUS SECONDHAND</p><h1>校园好物，<em>接着用。</em></h1><p>把用不到的留给需要的人，在校园里见个面。</p></div><div class="hero-art" aria-hidden="true"><div class="stamp"><div><span>ECHO MARKET</span>校园交换站<span>CAMPUS MARKET</span></div></div></div></section><section aria-labelledby="market-title"><div class="section-heading"><h2 id="market-title">正在上架</h2><small>${items.length} 件在售闲置</small></div>${items.length ? productGrid(items) : empty('暂时没有在售闲置', '你可以发布一件闲置，让它回到校园里。', link('发布闲置', route('productadd'), 'btn primary'))}</section>`;
    }

    function productDetail(p) {
      if (!p) return notFound('找不到这件商品');
      const mine = p.seller === state.me;
      return head('商品详情', '', back('返回市集', route('products'))) + `<div class="columns detail-layout">${media(p, 'detail-photo')}<section class="panel detail-info"><div class="card-top">${tag(categories[p.categoryId - 1] || '其他闲置')}${tag(p.sold ? '已售出' : '在售', !p.sold)}</div><h2 style="margin-top:12px">${esc(p.title)}</h2>${money(p.price)}<h3>商品描述</h3><p class="description">${esc(p.description || '卖家还没有填写商品描述。')}</p><div class="seller">${identity(p.seller, 'large')}${link('收到的评价', route('ratings', p.seller))}</div><div class="actions">${!p.sold && !mine ? link('立即购买', route('orderbuyerinfo', p.id), 'btn primary') : ''}${!mine ? link('联系卖家', route('messagethread', p.seller, p.id), 'btn') : ''}${heart(p, false)}</div>${!mine ? `<div class="actions">${link('举报商品', route('reportadd', '2', p.id))}${link('举报用户', route('reportadd', '1', p.seller))}</div>` : '<p class="subtext" style="margin-top:12px">这是你发布的闲置。</p>'}</section></div>`;
    }

    function publishPage() {
      return head('发布闲置商品', '写清物品的状态，方便同学了解和面交。', back('返回市集', route('products'))) + `<form class="columns" data-form="publish" enctype="multipart/form-data"><section class="panel form"><h2>商品信息</h2>${field('商品标题', '<input type="text" name="title" maxlength="100" required>')}${field('价格（元）', '<input type="number" name="price" min="0.01" max="999999.99" step="0.01" required>')}${field('商品分类', `<select name="categoryId">${categories.map((c, i) => `<option value="${i + 1}">${c}</option>`).join('')}</select>`)}${errorLine}<div class="actions"><button type="submit" class="btn primary">确认发布</button>${browse()}</div></section><section class="panel form"><h2>照片与描述</h2><div class="upload-preview" id="upload-preview">选择一张商品照片后，在这里预览。</div>${field('商品图片', '<input type="file" name="imageFile" accept="image/png,image/jpeg,image/webp,image/gif,image/avif" required>')}${field('商品描述（选填）', '<textarea name="description" rows="4" maxlength="1000" placeholder="例如：使用半年，配件齐全。"></textarea>')}<p class="subtext">预览支持常见图片格式，单张不超过 2 MB。图片只留在本机。</p></section></form>`;
    }

    function account(page) {
      const register = page === 'register';
      const current = state.me || 'xiaoman';
      const auth = register ? '注册' : '登录';
      return `<div class="columns account-layout"><aside class="panel account-intro"><strong>回响市集</strong><p>让闲置在校园里继续派上用场。</p><div>${identity(current, 'large')}</div></aside><section class="panel account-panel">${head(auth, register ? '只建立本机演示昵称，不保存手机号或密码。' : '仅切换本机演示身份，不验证或保存密码。')}<form class="form" data-form="${page}">${field('用户名', `<input name="username" required maxlength="32" autocomplete="username"${register ? ' minlength="3"' : ''}>`)}${register ? field('昵称', '<input name="nickname" required maxlength="32" autocomplete="nickname">') + field('手机号', '<input type="tel" name="phone" required maxlength="11" pattern="1[3-9][0-9]{9}" title="请填写 11 位手机号" autocomplete="off">') : ''}${field('密码', `<input type="password" name="password" required maxlength="64" autocomplete="${register ? 'new-password' : 'current-password'}"${register ? ' minlength="6"' : ''}>`)}${register ? field('确认密码', '<input type="password" name="confirmPassword" required maxlength="64" autocomplete="new-password">') + '<label class="choice"><input type="checkbox" name="agree" value="1" required>我已阅读并同意《用户协议》</label>' : notice('体验预置身份：xiaoman（含管理员样板）、tang 或 he，密码可填任意示例字符。')} ${errorLine}<div class="actions"><button class="btn primary" type="submit">${auth}</button></div></form><p class="auth-switch">${register ? `已有账号？${link('去登录', route('login'))}` : `还没有账号？${link('去注册', route('register'))}`}</p></section></div>`;
    }

    function messages(other, productId) {
      const list = state.threads.filter((t) => t.owner === state.me);
      const p = listing(productId);
      const valid = p && other !== state.me && (p.seller === other || p.seller === state.me) && isKnown(other);
      const active = valid && list.find((t) => t.other === other && t.productId === productId);
      if (active?.unread) { active.unread = false; save(); }
      const sidebar = list.map((t) => `<a class="chat-link" href="${route('messagethread', t.other, t.productId)}"${t === active ? ' aria-current="page"' : ''}>${avatar(t.other)}<div><strong>${esc(name(t.other))}</strong><p>${esc(listing(t.productId)?.title || '商品')} · ${esc(t.items.at(-1)?.text)}</p></div>${t.unread ? '<span class="unread" role="img" aria-label="未读"></span>' : ''}</a>`).join('');
      const conversation = valid ? `<div class="chat-head">${identity(other)}${link(p.title, route('productdetail', p.id))}</div><div class="chat-log enter">${active?.items.length ? active.items.map((m) => `<div class="message${m.from === state.me ? ' mine' : ''}">${avatar(m.from, 'mini')}<div><p class="subtext chat-meta">${esc(name(m.from))} · ${esc(m.time)}</p><p class="bubble">${esc(m.text)}</p></div></div>`).join('') : '<p class="muted">还没有消息。可以先问问商品状态或方便交接的时间。</p>'}</div><form class="compose" data-form="message"><input type="hidden" name="otherId" value="${esc(other)}"><input type="hidden" name="productId" value="${esc(p.id)}">${field('消息内容', '<textarea name="content" rows="2" maxlength="500" placeholder="写给对方的话…" required></textarea>')}<button type="submit" class="btn primary">发送</button></form>${errorLine}` : empty(other ? '找不到这段会话' : '还没选中会话', '从左侧选择一段对话，或在商品详情里联系卖家。', list.length ? '' : browse());
      return head('消息中心', '和同学确认商品细节、面交地点与时间。') + `<div class="chat"><aside class="chat-list" aria-label="会话列表"><h2>会话</h2>${sidebar || '<p class="subtext">暂无会话</p>'}</aside><section class="conversation" aria-label="聊天内容">${conversation}</section></div>`;
    }

    function orderList(seller, filter = 'all') {
      const requested = filter === 'all' ? -1 : Number(filter);
      const my = state.orders.filter((o) => (seller ? o.seller : o.buyer) === state.me);
      const items = my.filter((o) => requested < 0 || requested === o.status);
      const tabs = `<nav class="tabs" aria-label="订单身份"><a href="${route('myorders')}"${!seller ? ' aria-current="page"' : ''}>我买到的</a><a href="${route('soldorders')}"${seller ? ' aria-current="page"' : ''}>我卖出的</a></nav>`;
      return head(seller ? '我卖出的订单' : '我买到的订单', '查看在校园里买入与卖出的物品。') + tabs + `<div class="filters"><label>订单状态 <select id="order-filter" data-page="${seller ? 'soldorders' : 'myorders'}"><option value="all">全部状态</option>${orderStatus.map((s, i) => `<option value="${i}"${i === requested ? ' selected' : ''}>${s}</option>`).join('')}</select></label><span>${items.length} 笔订单</span></div>` + (items.length ? `<div class="list">${items.map((o) => { const p = listing(o.productId); return `<article class="record"><div class="intro">${p ? media(p) : ''}<div class="body"><p class="subtext">订单 EM${esc(o.id)} · ${esc(o.time)}</p><h2>${esc(p?.title || '商品')}</h2><p class="subtext">${seller ? '买家' : '卖家'}：${esc(name(seller ? o.buyer : o.seller))}</p></div></div><div class="right">${tag(orderStatus[o.status], o.status < 3)}${money(o.amount)}${link('订单详情', route('orderdetail', o.id), 'btn')}</div></article>`; }).join('')}</div>` : empty('这个状态下没有订单', '试试切换订单状态，或回市集逛一逛。', browse()));
    }

    const choices = (group, legend, options) => `<fieldset><legend>${legend}</legend><div class="form-row">${options.map(([value, title], i) => `<label class="choice"><input type="radio" name="${group}" value="${value}"${i === 0 ? ' checked' : ''}>${title}</label>`).join('')}</div></fieldset>`;
    function checkout(p) {
      if (!p) return notFound('找不到这件商品');
      if (p.sold || p.seller === state.me) return head('确认订单') + empty('该商品不能下单', '已售出或自己发布的闲置不能购买。', link('回商品详情', route('productdetail', p.id), 'btn'));
      return head('确认订单', '选择校内交接方式，再核对商品和金额。', back('返回商品详情', route('productdetail', p.id))) + `<form class="columns" data-form="checkout"><input type="hidden" name="productId" value="${esc(p.id)}"><section class="panel form"><h2>交接与收货信息</h2>${choices('deliveryType', '交易方式', Object.entries(deliveryLabel))}<div class="form-row">${field('联系人称呼', `<input name="receiverName" value="${esc(name(state.me).slice(0, 30))}" maxlength="30" required>`)}${field('联系电话 / 微信号', '<input name="phone" maxlength="30" placeholder="请填演示信息" required>')}</div>${field('校内交接 / 收货地址', '<input name="address" maxlength="120" placeholder="例如：图书馆一楼大厅" required>')}${choices('payMethod', '付款方式', Object.entries(payLabel))}${field('订单备注（选填）', '<textarea name="remark" rows="2" maxlength="200" placeholder="例如：周三傍晚方便交接。"></textarea>')}${errorLine}</section><aside class="panel"><h2>订单商品清单</h2><div class="summary-product">${media(p)}<div><strong>${esc(p.title)}</strong><p class="subtext">${esc(name(p.seller))}</p></div></div><div class="total"><strong>合计</strong>${money(p.price)}</div>${notice('仅模拟订单流转，请勿填写真实联系方式；不会扣款。')}<div class="actions"><button type="submit" class="btn primary">立即购买</button></div></aside></form>`;
    }

    const ownsOrder = (o) => o && [o.buyer, o.seller].includes(state.me);
    function orderDetail(o, success = false) {
      if (!ownsOrder(o)) return notFound('找不到这笔订单');
      const p = listing(o.productId);
      const seller = o.seller === state.me;
      const list = route(seller ? 'soldorders' : 'myorders');
      const counterpart = seller ? o.buyer : o.seller;
      if (success) return `<section class="panel success">${tag('订单已提交', true)}${head('订单已提交', '样板已记录这笔订单，不产生付款。')}<div class="summary-product">${p ? media(p) : ''}<strong>${esc(p?.title || '商品')}</strong></div><div class="total"><span>订单 EM${esc(o.id)}</span>${money(o.amount)}</div><div class="actions">${link('查看订单详情', route('orderdetail', o.id), 'btn primary')}${browse()}</div></section>`;
      const current = o.status;
      const next = !seller && current === 0 ? ['模拟付款', 'pay'] : seller && current === 1 ? ['标记已发货', 'ship'] : !seller && current === 2 ? ['确认收货', 'confirm'] : null;
      const guidance = current === 0 ? (seller ? '等待买家完成模拟付款。' : '你可以模拟付款或取消订单。') : current === 1 ? (seller ? '与买家约定交接，并在交接后标记已发货。' : '等待卖家交接。你可以通过消息确认时间。') : current === 2 ? (seller ? '等待买家确认收货。' : '请在检查商品后确认收货。') : current === 3 ? '交易已完成，双方可以互相评价。' : '这笔订单已取消。';
      const ratings = state.ratings.filter((r) => r.orderId === o.id);
      const flow = current === 4 ? '' : `<ol class="steps" aria-label="订单进度">${orderStatus.slice(0, 4).map((s, i) => `<li class="tag${i === current ? ' current' : ''}"${i === current ? ' aria-current="step"' : ''}>${i + 1}. ${s}</li>`).join('')}</ol>`;
      const ratingForm = !ratings.some((r) => r.from === state.me) ? `<form class="form" data-form="rating"><input type="hidden" name="orderId" value="${esc(o.id)}">${field('评分', '<select name="score"><option value="5">5 分</option><option value="4">4 分</option><option value="3">3 分</option><option value="2">2 分</option><option value="1">1 分</option></select>')}${field('评价内容（选填）', '<textarea name="content" rows="3" maxlength="255"></textarea>')}${errorLine}<div class="actions"><button type="submit" class="btn primary">提交评价</button></div></form>` : '<p class="subtext">你已评价过这笔订单。</p>';
      return head('订单详情', `订单 EM${o.id} · ${o.time}`, back('返回订单列表', list)) + `<div class="columns"><div class="stack"><section class="panel"><div class="card-top"><h2>当前进度</h2>${tag(orderStatus[current], current < 3)}</div>${flow}<p>${esc(guidance)}</p><div class="actions">${next ? button(next[0], `order-${next[1]}`, o.id, true) : ''}${current < 2 ? button('取消订单', 'order-cancel', o.id) : ''}${p ? link(seller ? '联系买家' : '联系卖家', route('messagethread', counterpart, p.id), 'btn') : ''}</div></section><section class="panel"><h2>交接与付款信息</h2><dl class="info"><dt>交接方式</dt><dd>${esc(deliveryLabel[o.deliveryType])}</dd><dt>联系人</dt><dd>${esc(o.receiverName)}</dd><dt>联系电话</dt><dd>${esc(o.phone)}</dd><dt>交接地点</dt><dd>${esc(o.address)}</dd><dt>支付方式</dt><dd>${esc(payLabel[o.payMethod])}</dd><dt>订单备注</dt><dd>${esc(o.remark || '未填写')}</dd></dl></section>${current === 3 ? `<section class="panel stack"><h2>这笔订单的评价</h2>${ratings.map(ratingRecord).join('')}${ratingForm}</section>` : ''}</div><aside class="panel"><h2>订单商品</h2><div class="summary-product">${p ? media(p) : ''}<div><strong>${p ? link(p.title, route('productdetail', p.id)) : '商品'}</strong><div class="subtext">${seller ? '买家' : '卖家'}：${identity(counterpart, 'mini')}</div></div></div><div class="total"><span>合计</span>${money(o.amount)}</div></aside></div>`;
    }

    function ratingRecord(r) {
      return `<article class="record"><div class="intro">${avatar(r.from)}<div class="body"><strong>${esc(name(r.from))}</strong><p>${esc(r.content || '未填写文字评价。')}</p><p class="subtext">${esc(r.time)}</p></div></div><span class="rating" aria-label="${r.score} 分，满分 5 分">${'★'.repeat(r.score)}${'☆'.repeat(5 - r.score)}</span></article>`;
    }
    function ratingsPage(id) {
      const who = id || state.me;
      if (!who || !(Object.hasOwn(users, who) || Object.hasOwn(state.accounts, who))) return notFound('找不到该用户');
      const entries = state.ratings.filter((r) => r.to === who);
      const average = entries.length ? (entries.reduce((n, r) => n + r.score, 0) / entries.length).toFixed(1) + ' / 5' : '暂无评分';
      return head('收到的评价', '', back('返回市集', route('products'))) + `<div class="columns"><div>${entries.length ? `<div class="list">${entries.map(ratingRecord).join('')}</div>` : empty('暂无评价', '完成交易后收到的评价会显示在这里。')}</div><aside class="panel stack">${identity(who, 'large')}<p class="rating">${average}</p><p class="muted">共 ${entries.length} 条评价</p></aside></div>`;
    }

    function reportTarget(type, id) { return Number(type) === 1 ? '用户：' + name(id) : '商品：' + (listing(id)?.title || '不存在'); }
    function reportForm(type, target) {
      if ((type === '2' && !listing(target)) || (type === '1' && !(Object.hasOwn(users, target) || Object.hasOwn(state.accounts, target))) || !['1','2'].includes(type)) return notFound('找不到举报对象');
      return head('提交举报', '', back('返回市集', route('products'))) + `<div class="columns"><section class="panel"><h2>${esc(reportTarget(type, target))}</h2><form class="form" data-form="report"><input type="hidden" name="targetType" value="${type}"><input type="hidden" name="targetId" value="${esc(target)}">${field('举报理由', '<textarea name="reason" rows="5" maxlength="500" placeholder="请说明遇到的问题。" required></textarea>')}${errorLine}<div class="actions"><button type="submit" class="btn primary">提交举报</button></div></form></section><aside class="panel"><h2>处理进度</h2><p class="muted">提交后可在「我的举报」查看该条记录。此表单只用于样板演示。</p><div class="actions">${link('我的举报', route('reports'))}</div></aside></div>`;
    }
    function reportsPage(admin) {
      if (admin && !user(state.me).admin) return head('举报处理') + empty('此页面仅供管理员使用', '可从登录页切换到预置管理员演示身份。', link('去登录', route('login'), 'btn'));
      const items = state.reports.filter((r) => admin || r.from === state.me);
      return head(admin ? '举报处理' : '我提交过的举报', admin ? '查看待处理记录、标记处理结果或驳回。' : '查看提交记录及处理结果。') + (items.length ? `<div class="list">${items.map((r) => `<article class="record"><div class="body"><div class="identity">${tag(reportStatus[r.status], r.status === 0)}<span class="subtext">${esc(r.time)}</span></div><h2>${esc(reportTarget(r.targetType, r.targetId))}</h2><p>${esc(r.reason)}</p>${admin ? `<div class="subtext">举报人：${esc(name(r.from))}</div>` : ''}</div>${admin && r.status === 0 ? `<div class="right">${button('标记已处理', 'report-1', r.id, true)}${button('驳回', 'report-2', r.id)}</div>` : ''}</article>`).join('')}</div>` : empty('还没有举报记录', '提交的举报会显示在这里。', admin ? '' : browse()));
    }

    const notFound = (title) => head(title) + empty('这个页面暂不可用', '链接可能已失效。可以返回商品列表继续浏览。', browse());
    const isKnown = (id) => Object.hasOwn(users, id) || Object.hasOwn(state.accounts, id);
    const views = {
      products: () => market(), favorites: () => market(true),
      productdetail: ([id]) => productDetail(listing(id)), productadd: () => publishPage(),
      messages: () => messages(), messagethread: ([other, id]) => messages(other, id),
      myorders: ([filter]) => orderList(false, filter), soldorders: ([filter]) => orderList(true, filter),
      orderbuyerinfo: ([id]) => checkout(listing(id)), orderdetail: ([id]) => orderDetail(orderFor(id)),
      ordersuccess: ([id]) => orderDetail(orderFor(id), true), ratings: ([id]) => ratingsPage(id),
      reports: () => reportsPage(false), adminreports: () => reportsPage(true), reportadd: ([type, id]) => reportForm(type, id),
      login: () => account('login'), register: () => account('register'),
      welcome: () => head(`欢迎，${name(state.me)}`) + `<section class="panel stack">${identity(state.me, 'large')}<div class="actions">${browse()}${link('收到的评价', route('ratings', state.me), 'btn')}</div></section>`,
    };
    const protectedViews = new Set(['favorites', 'productadd', 'messages', 'messagethread', 'myorders', 'soldorders', 'orderbuyerinfo', 'orderdetail', 'ordersuccess', 'reports', 'adminreports', 'reportadd', 'welcome']);
    function currentRoute() {
      try { return (location.hash.slice(1) || 'products').split('/').map(decodeURIComponent); }
      catch { return ['not-found']; }
    }
    function renderProfile() {
      document.querySelector('#profile-summary').innerHTML = `${avatar(state.me)}<span>${esc(name(state.me))}</span>`;
      document.querySelector('#profile-menu').innerHTML = state.me ? [
        link('我的账号', route('welcome')), link('收到的评价', route('ratings', state.me)), link('我的举报', route('reports')),
        user(state.me).admin ? link('举报处理', route('adminreports')) : '', link('切换演示账号', route('login')),
        '<button type="button" data-action="logout">退出登录</button>',
      ].join('') : link('登录', route('login')) + link('注册', route('register'));
    }
    function render(focus = false) {
      const [page, ...params] = currentRoute();
      profile.open = false;
      renderProfile();
      if (!state.me && protectedViews.has(page)) {
        main.innerHTML = head('请先登录') + empty('登录后继续体验', '前端样板仅切换本机演示身份。', link('去登录', route('login', page, ...params), 'btn primary'));
      } else main.innerHTML = Object.hasOwn(views, page) ? views[page](params) : notFound('找不到该页面');
      document.title = `${main.querySelector('h1')?.textContent || '浏览商品'} · 回响市集`;
      const section = ({ productdetail: 'products', productadd: 'products', messagethread: 'messages', soldorders: 'myorders', orderdetail: 'myorders', ordersuccess: 'myorders', orderbuyerinfo: 'myorders' })[page] || page;
      document.querySelectorAll('[data-nav]').forEach((a) => {
        if (a.dataset.nav === section) a.setAttribute('aria-current', 'page'); else a.removeAttribute('aria-current');
      });
      observer?.disconnect();
      if ('IntersectionObserver' in window) {
        observer = new IntersectionObserver((entries) => entries.forEach(({ target, isIntersecting }) => {
          if (isIntersecting) { target.classList.add('enter'); observer.unobserve(target); }
        }), { threshold: 0.06 });
        main.querySelectorAll('[data-reveal]').forEach((card) => observer.observe(card));
      }
      const chat = main.querySelector('.chat-log');
      if (chat) chat.scrollTop = chat.scrollHeight;
      if (focus) { window.scrollTo(0, 0); main.focus({ preventScroll: true }); }
    }
    function syncTheme() {
      const dark = document.documentElement.dataset.theme === 'dark';
      const label = dark ? '切换亮色主题' : '切换暗色主题';
      theme.setAttribute('aria-pressed', String(dark));
      theme.setAttribute('aria-label', label);
      theme.title = label;
      theme.firstElementChild.textContent = dark ? '☀' : '☾';
    }
    function notify(text) {
      toast.textContent = text;
      toast.hidden = false;
      clearTimeout(toastTimer);
      toastTimer = setTimeout(() => { toast.hidden = true; }, 2600);
    }
    function saveFeedback(text) {
      notify(save() ? text : text + '（仅本次打开有效，浏览器未保存）');
    }
    function confirmAction(title, text, callback) {
      dialog.querySelector('#confirm-title').textContent = title;
      dialog.querySelector('#confirm-text').textContent = text;
      dialog.returnValue = 'cancel';
      pending = callback;
      dialog.showModal();
    }
    function formError(form, text = '') {
      const area = form.querySelector('[data-error]');
      if (area) { area.textContent = text; area.hidden = !text; } else if (text) notify(text);
    }
    function statusAction(type, id) {
      const o = orderFor(id);
      if (!ownsOrder(o)) return;
      const isBuyer = o.buyer === state.me;
      const allowed = {
        pay: isBuyer && o.status === 0, ship: !isBuyer && o.status === 1,
        confirm: isBuyer && o.status === 2, cancel: o.status < 2,
      };
      if (!allowed[type]) return;
      const result = { pay: 1, ship: 2, confirm: 3, cancel: 4 }[type];
      const title = { pay: '模拟付款', ship: '标记已发货', confirm: '确认收货', cancel: '取消订单' }[type];
      confirmAction(title, type === 'pay' ? '确认后只更新样板订单状态，不会扣款。' : `确认${title}？这只会更新本机样板中的记录。`, () => {
        o.status = result;
        if (type === 'cancel' && listing(o.productId)) listing(o.productId).sold = false;
        saveFeedback(`订单状态：${orderStatus[result]}`);
        render();
      });
    }
    function favorite(el) {
      const p = listing(el.dataset.value);
      if (!p) return;
      if (!state.me) return go('login', ...currentRoute());
      const ids = savedIds();
      const saved = !ids.includes(p.id);
      state.favorites = { ...state.favorites, [state.me]: saved ? [...ids, p.id] : ids.filter((id) => id !== p.id) };
      const text = saved ? '已加入收藏' : '已取消收藏';
      saveFeedback(text);
      if (currentRoute()[0] === 'favorites') {
        const controls = Array.from(main.querySelectorAll('[data-action="favorite"]'));
        const next = controls[controls.indexOf(el) + 1] || controls[controls.indexOf(el) - 1];
        render();
        (Array.from(main.querySelectorAll('[data-action="favorite"]')).find((b) => b.dataset.value === next?.dataset.value) || main).focus();
        return;
      }
      const compact = el.dataset.compact === 'true';
      el.textContent = compact ? (saved ? '♥' : '♡') : (saved ? '取消收藏' : '收藏商品');
      el.setAttribute('aria-pressed', String(saved));
      el.setAttribute('aria-label', `${saved ? '取消收藏' : '收藏'}：${p.title}`);
      el.classList.remove('pop');
      requestAnimationFrame(() => el.classList.add('pop'));
    }
    function fileURL(file) { return new Promise((resolve, reject) => { const reader = new FileReader(); reader.onload = () => resolve(reader.result); reader.onerror = reject; reader.readAsDataURL(file); }); }
    const validFile = (file) => file?.size > 0 && file.size <= 2 * 1024 * 1024 && /^image\/(png|jpeg|webp|gif|avif)$/.test(file.type);
    function messageTo(owner, other, productId, message, unread) {
      let t = state.threads.find((item) => item.owner === owner && item.other === other && item.productId === productId);
      if (!t) { t = { owner, other, productId, items: [] }; state.threads.unshift(t); }
      t.items.push(message);
      t.unread = unread;
    }
    async function submit(form) {
      const data = new FormData(form);
      const get = (key) => String(data.get(key) || '').trim();
      const task = form.dataset.form;
      formError(form);
      if (task === 'login' || task === 'register') {
        const username = get('username');
        if (task === 'register') {
          const nickname = get('nickname');
          if (username.length < 3 || !nickname) return formError(form, '请输入有效的用户名和昵称。');
          if (isKnown(username)) return formError(form, '本机已有这个演示用户名。');
          if (data.get('password') !== data.get('confirmPassword')) return formError(form, '两次输入的密码不一致。');
          state.accounts = { ...state.accounts, [username]: { username, nickname } };
        } else if (!isKnown(username)) return formError(form, '没有这个演示用户名。可以试试 xiaoman，或先注册一个本机演示身份。');
        state.me = username;
        saveFeedback(task === 'register' ? '本机演示身份已建立' : '已登录到演示身份');
        const [, next, ...params] = currentRoute();
        return Object.hasOwn(views, next) && next !== 'login' && next !== 'register' ? go(next, ...params) : go('welcome');
      }
      if (!state.me) return go('login', ...currentRoute());
      if (task === 'publish') {
        const file = data.get('imageFile');
        if (!get('title')) return formError(form, '请填写商品标题。');
        if (!validFile(file)) return formError(form, '请选择不超过 2 MB 的 PNG、JPEG、WebP、GIF 或 AVIF 图片。');
        const seller = state.me;
        const submitter = form.querySelector('[type=submit]');
        submitter.disabled = true;
        try {
          const image = await fileURL(file);
          if (!form.isConnected || state.me !== seller) return;
          const id = uid();
          state.products.unshift({ id, title: get('title'), price: Number(get('price')), categoryId: Number(get('categoryId')), image, seller, description: get('description'), sold: false });
          saveFeedback('闲置已加入本机市集');
          go('productdetail', id);
        } catch { formError(form, '读取失败，请另选一张照片。'); }
        finally { submitter.disabled = false; }
      } else if (task === 'message') {
        const text = get('content'), p = listing(get('productId')), other = get('otherId');
        if (!text) return formError(form, '请先输入消息内容。');
        if (!p || !isKnown(other) || other === state.me || (p.seller !== other && p.seller !== state.me)) return;
        const message = { from: state.me, text, time: now() };
        messageTo(state.me, other, p.id, message, false);
        messageTo(other, state.me, p.id, message, true);
        saveFeedback('消息已加入本机会话');
        render();
        main.querySelector('.compose textarea')?.focus({ preventScroll: true });
      } else if (task === 'checkout') {
        const p = listing(get('productId'));
        if (!p || p.sold || p.seller === state.me) return formError(form, '该商品不能下单。');
        if (!get('receiverName') || !get('phone') || !get('address')) return formError(form, '请完整填写校内交接信息。');
        confirmAction('确认购买', '这将创建一笔本机演示订单，不发生实际扣款。', () => {
          if (p.sold) return;
          const id = uid();
          state.orders.unshift({ id, productId: p.id, buyer: state.me, seller: p.seller, amount: p.price, status: 1, time: now(), ...Object.fromEntries(['receiverName', 'phone', 'address', 'remark', 'deliveryType', 'payMethod'].map((key) => [key, get(key)])) });
          p.sold = true;
          saveFeedback('订单已提交');
          go('ordersuccess', id);
        });
      } else if (task === 'rating') {
        const o = orderFor(get('orderId'));
        if (!ownsOrder(o) || o.status !== 3 || state.ratings.some((r) => r.orderId === o.id && r.from === state.me)) return;
        state.ratings.push({ orderId: o.id, from: state.me, to: o.buyer === state.me ? o.seller : o.buyer, score: Number(get('score')), content: get('content'), time: now() });
        saveFeedback('评价已加入本机订单');
        render();
      } else if (task === 'report') {
        const reason = get('reason');
        if (!reason) return formError(form, '请填写举报理由。');
        state.reports.unshift({ id: uid(), from: state.me, targetType: Number(get('targetType')), targetId: get('targetId'), reason, status: 0, time: now() });
        saveFeedback('举报已加入本机样板');
        go('reports');
      }
    }

    document.addEventListener('click', (event) => {
      if (!profile.contains(event.target) || event.target.closest('.profile-menu a')) profile.open = false;
      const el = event.target.closest('[data-action]');
      if (!el) return;
      const { action, value } = el.dataset;
      if (action === 'logout') { state.me = null; saveFeedback('已退出演示身份'); go('login'); }
      if (action === 'favorite') favorite(el);
      if (action.startsWith('order-')) statusAction(action.slice(6), value);
      if ((action === 'report-1' || action === 'report-2') && user(state.me).admin) {
        const report = state.reports.find((r) => r.id === value && r.status === 0);
        if (report) { report.status = Number(action.at(-1)); saveFeedback(`举报状态：${reportStatus[report.status]}`); render(); }
      }
    });
    document.addEventListener('keydown', (event) => {
      if (event.key === 'Escape' && profile.open) { profile.open = false; profile.querySelector('summary').focus(); }
    });
    document.addEventListener('error', (event) => {
      const target = event.target;
      if (target.matches?.('.avatar img')) target.remove();
      else if (target.matches?.('.product-media img, .upload-preview img')) {
        const fallback = document.createElement('span');
        fallback.className = 'photo-empty';
        fallback.textContent = '图片无法显示';
        target.replaceWith(fallback);
      }
    }, true);
    document.addEventListener('submit', (event) => {
      if (!event.target.matches('[data-form]')) return;
      event.preventDefault();
      submit(event.target);
    });
    document.addEventListener('change', async ({ target }) => {
      if (target.id === 'order-filter') go(target.dataset.page, target.value);
      if (target.name !== 'imageFile') return;
      const preview = document.querySelector('#upload-preview');
      const file = target.files[0];
      if (!file) { preview.textContent = '选择一张商品照片后，在这里预览。'; return; }
      if (!validFile(file)) { preview.textContent = '请选择常见格式的图片，大小不超过 2 MB。'; return; }
      try {
        const image = document.createElement('img');
        image.src = await fileURL(file);
        image.alt = '待发布商品图片预览';
        if (preview.isConnected && target.files[0] === file) preview.replaceChildren(image);
      } catch { preview.textContent = '无法预览这张图片，请重试。'; }
    });
    dialog.addEventListener('close', () => {
      const callback = pending;
      pending = null;
      if (dialog.returnValue === 'confirm') callback?.();
    });
    theme.addEventListener('click', () => {
      const next = document.documentElement.dataset.theme === 'dark' ? 'light' : 'dark';
      document.documentElement.dataset.theme = next;
      writeLocal(themeKey, next);
      syncTheme();
    });
    window.addEventListener('hashchange', () => render(true));
    syncTheme();
    render();

  });
})();
