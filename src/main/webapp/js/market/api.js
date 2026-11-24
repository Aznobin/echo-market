(() => {
  'use strict';

  const contract = Object.freeze({
    account: ['currentId', 'find', 'login', 'register', 'logout'],
    catalog: ['categories', 'list', 'find', 'publish'],
    favorites: ['ids', 'list', 'toggle'],
    messages: ['list', 'canOpen', 'open', 'send'],
    orders: ['list', 'find', 'create', 'transition'],
    ratings: ['forUser', 'forOrder', 'create'],
    reports: ['list', 'create', 'handle'],
  });

  function connect({ createAdapter, storage }) {
    const adapter = createAdapter({ storage });
    for (const [domain, methods] of Object.entries(contract)) {
      for (const method of methods) {
        if (typeof adapter?.[domain]?.[method] !== 'function') {
          throw new TypeError(`前端接口缺失：${domain}.${method}`);
        }
      }
    }
    return adapter;
  }

  window.EchoMarketApi = Object.freeze({ connect });
})();
