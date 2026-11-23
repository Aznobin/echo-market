(() => {
  'use strict';

  // The mock keeps the existing local data readable across preview updates.
  const key = 'echo-market.preview.data.v1';
  const { users, categories, createData } = window.EchoPreviewFixtures;
  const fail = (message, code = 'invalid') => { throw Object.assign(new Error(message), { code }); };

  function createMockApi({ storage, now = () => new Date() } = {}) {
    let state = createData();
    try {
      const saved = JSON.parse(storage?.getItem(key) ?? 'null');
      if (saved && ['products', 'threads', 'orders', 'ratings', 'reports'].every((k) => Array.isArray(saved[k])) && saved.accounts && saved.favorites) {
        for (const product of saved.products) {
          if (typeof product.image !== 'string') continue;
          product.image = product.image.replace(/^\.\/preview-assets\//, './images/market/')
            .replace(/^\.\/src\/main\/webapp\/images\//, './images/');
        }
        state = saved;
      }
    } catch { /* Unavailable or invalid storage starts a clean demo. */ }
    const copy = (value) => value == null ? value : JSON.parse(JSON.stringify(value));
    const timestamp = () => new Intl.DateTimeFormat('zh-CN', { month: 'numeric', day: 'numeric', hour: '2-digit', minute: '2-digit' }).format(now());
    let lastId = 0;
    const nextId = (rows) => {
      lastId = Math.max(now().getTime(), lastId + 1, ...rows.map((row) => Number(row.id) + 1).filter(Number.isFinite));
      return String(lastId);
    };
    const catalogItem = (id) => state.products.find((p) => p.id === id);
    const orderItem = (id) => state.orders.find((o) => o.id === id && [o.buyer, o.seller].includes(state.me));
    const getUser = (id) => (Object.hasOwn(users, id) && users[id]) || (Object.hasOwn(state.accounts, id) && state.accounts[id]);
    const requireUser = () => state.me || fail('请先登录演示账号。', 'unauthorized');
    const favorites = () => state.me && Object.hasOwn(state.favorites, state.me) ? state.favorites[state.me] : [];
    const threadFor = (owner, other, productId) => state.threads.find((t) => t.owner === owner && t.other === other && t.productId === productId);
    const canMessage = (owner, other, p) => Boolean(owner && p && owner !== other && getUser(other) && (p.seller === other || p.seller === owner));
    const finish = (value) => {
      let persisted = false;
      try { if (storage) { storage.setItem(key, JSON.stringify(state)); persisted = true; } } catch { /* In-memory state remains usable. */ }
      return { value: copy(value), persisted };
    };

    return Object.freeze({
      account: Object.freeze({
        currentId: () => state.me,
        find: (id) => copy(getUser(id)) ?? null,
        login({ username }) {
          if (!getUser(username)) fail('没有这个演示用户名。可以试试 xiaoman，或先注册一个本机演示身份。', 'not_found');
          state.me = username;
          return finish(getUser(username));
        },
        register({ username, nickname, password, confirmPassword }) {
          if (username.length < 3 || !nickname) fail('请输入有效的用户名和昵称。');
          if (getUser(username)) fail('本机已有这个演示用户名。', 'conflict');
          if (password !== confirmPassword) fail('两次输入的密码不一致。');
          state.accounts = { ...state.accounts, [username]: { username, nickname } };
          state.me = username;
          return finish(getUser(username));
        },
        logout() { state.me = null; return finish(null); },
      }),
      catalog: Object.freeze({
        categories: () => [...categories],
        list: ({ availableOnly = false } = {}) => copy(availableOnly ? state.products.filter((p) => !p.sold) : state.products),
        find: (id) => copy(catalogItem(id)) ?? null,
        publish({ title, price, categoryId, image, description }) {
          const seller = requireUser();
          if (!title || !Number.isFinite(price) || price < .01 || price > 999999.99 || !categories[categoryId - 1] || !image) fail('请检查标题、价格、分类和商品照片。');
          const item = { id: nextId(state.products), title, price, categoryId, image, seller, description, sold: false };
          state.products.unshift(item);
          return finish(item);
        },
      }),
      favorites: Object.freeze({
        ids: () => [...favorites()],
        toggle(productId) {
          const id = requireUser();
          if (!catalogItem(productId)) fail('找不到商品。', 'not_found');
          const all = favorites(), saved = !all.includes(productId);
          state.favorites = { ...state.favorites, [id]: saved ? [...all, productId] : all.filter((item) => item !== productId) };
          return finish(saved);
        },
      }),
      messages: Object.freeze({
        list: () => copy(state.threads.filter((t) => t.owner === state.me)),
        canOpen: (other, productId) => canMessage(state.me, other, catalogItem(productId)),
        open(other, productId) {
          if (!canMessage(state.me, other, catalogItem(productId))) return null;
          const active = threadFor(state.me, other, productId);
          if (active?.unread) { active.unread = false; return finish(active).value; }
          return copy(active) ?? null;
        },
        send({ otherId, productId, content }) {
          const sender = requireUser();
          if (!content) fail('请先输入消息内容。');
          if (!canMessage(sender, otherId, catalogItem(productId))) fail('无法联系该用户。');
          const message = { from: sender, text: content.slice(0, 500), time: timestamp() };
          for (const [owner, other, unread] of [[sender, otherId, false], [otherId, sender, true]]) {
            let thread = threadFor(owner, other, productId);
            if (!thread) { thread = { owner, other, productId, items: [] }; state.threads.unshift(thread); }
            thread.items.push(message);
            thread.unread = unread;
          }
          return finish(message);
        },
      }),
      orders: Object.freeze({
        list: (side = 'buyer') => copy(state.orders.filter((o) => state.me && o[side === 'seller' ? 'seller' : 'buyer'] === state.me)),
        find: (id) => copy(orderItem(id)) ?? null,
        create({ productId, receiverName, phone, address, remark, deliveryType, payMethod }) {
          const buyer = requireUser(), p = catalogItem(productId);
          if (!p || p.sold || p.seller === buyer) fail('该商品不能下单。', 'conflict');
          if (!receiverName || !phone || !address) fail('请完整填写校内交接信息。');
          const item = { id: nextId(state.orders), productId, buyer, seller: p.seller, amount: p.price, status: 1,
            time: timestamp(), receiverName, phone, address, remark, deliveryType, payMethod };
          state.orders.unshift(item);
          p.sold = true;
          return finish(item);
        },
        transition(id, action) {
          requireUser();
          const o = orderItem(id);
          if (!o) fail('找不到这笔订单。', 'not_found');
          const buyer = o.buyer === state.me;
          const allowed = { pay: buyer && o.status === 0, ship: !buyer && o.status === 1, confirm: buyer && o.status === 2, cancel: o.status < 2 };
          if (!Object.hasOwn(allowed, action) || !allowed[action]) fail('当前订单状态不支持此操作。', 'conflict');
          o.status = { pay: 1, ship: 2, confirm: 3, cancel: 4 }[action];
          const p = catalogItem(o.productId);
          if (action === 'cancel' && p) p.sold = false;
          return finish(o);
        },
      }),
      ratings: Object.freeze({
        forUser: (id) => copy(state.ratings.filter((r) => r.to === id)),
        forOrder: (id) => orderItem(id) ? copy(state.ratings.filter((r) => r.orderId === id)) : [],
        create({ orderId, score, content }) {
          const from = requireUser(), o = orderItem(orderId);
          if (!o || o.status !== 3 || state.ratings.some((r) => r.orderId === o.id && r.from === from)) fail('这笔订单目前不能评价。', 'conflict');
          if (!Number.isInteger(score) || score < 1 || score > 5) fail('评分须为 1 到 5 分。');
          const item = { orderId, from, to: o.buyer === from ? o.seller : o.buyer, score, content: content.slice(0, 255), time: timestamp() };
          state.ratings.push(item);
          return finish(item);
        },
      }),
      reports: Object.freeze({
        list(admin = false) {
          if (!state.me || (admin && !getUser(state.me)?.admin)) return [];
          return copy(state.reports.filter((r) => admin || r.from === state.me));
        },
        create({ targetType, targetId, reason }) {
          const from = requireUser();
          if (!(targetType === 2 ? catalogItem(targetId) : targetType === 1 && getUser(targetId))) fail('找不到举报对象。', 'not_found');
          if (!reason) fail('请填写举报理由。');
          const item = { id: nextId(state.reports), from, targetType, targetId, reason: reason.slice(0, 500), status: 0, time: timestamp() };
          state.reports.unshift(item);
          return finish(item);
        },
        handle(id, status) {
          if (!getUser(requireUser())?.admin) fail('此操作仅供管理员使用。', 'forbidden');
          const item = state.reports.find((r) => r.id === id);
          if (!item || item.status !== 0 || ![1, 2].includes(status)) fail('举报已处理或不存在。', 'conflict');
          item.status = status;
          return finish(item);
        },
      }),
    });
  }
  window.EchoMarketMock = Object.freeze({ createMockApi });
})();
