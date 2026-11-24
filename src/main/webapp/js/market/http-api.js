(() => {
  'use strict';

  const base = document.documentElement.dataset.ctx || '';
  const fail = (message, code = 'invalid') => { throw Object.assign(new Error(message || '请求失败'), { code }); };

  function call(action, params = {}, method = 'GET') {
    const search = new URLSearchParams({ action, ...params });
    const url = base + '/api?' + search.toString();
    const xhr = new XMLHttpRequest();
    xhr.open(method, url, false);
    if (method === 'POST') xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded;charset=UTF-8');
    xhr.send(null);
    if (xhr.status >= 400) fail(parse(xhr)?.error || '请求失败');
    return parse(xhr);
  }

  function parse(xhr) {
    try { return JSON.parse(xhr.responseText || 'null'); } catch { return null; }
  }

  function createHttpApi() {
    let cachedMe;
    const refreshMe = () => { cachedMe = call('me'); return cachedMe; };
    const requireMe = () => cachedMe || refreshMe() || fail('请先登录', 'unauthorized');

    return Object.freeze({
      account: Object.freeze({
        currentId: () => (refreshMe() ? String(cachedMe.id) : null),
        find: (id) => (/^\d+$/.test(String(id || '')) ? call('user', { id }) : null),
        login: () => { refreshMe(); return { value: cachedMe, persisted: true }; },
        register: () => { refreshMe(); return { value: cachedMe, persisted: true }; },
        logout() { call('logout'); cachedMe = null; return { value: null, persisted: true }; },
      }),
      catalog: Object.freeze({
        categories: () => call('categories'),
        list: () => call('products'),
        find: (id) => call('product', { id }),
        publish({ title, price, categoryId, image, description }) {
          const form = new FormData();
          form.append('title', title);
          form.append('price', String(price));
          form.append('categoryId', String(categoryId));
          form.append('description', description || '');
          if (typeof image === 'string' && image.startsWith('data:')) {
            const [meta, data] = image.split(',');
            const type = meta.match(/data:([^;]+)/)?.[1] || 'image/jpeg';
            const bytes = Uint8Array.from(atob(data), (c) => c.charCodeAt(0));
            form.append('image', new Blob([bytes], { type }), 'photo.jpg');
          }
          const xhr = new XMLHttpRequest();
          xhr.open('POST', base + '/api?action=publish', false);
          xhr.send(form);
          const result = parse(xhr);
          if (xhr.status >= 400) fail(result?.error || '发布失败');
          return { value: result, persisted: true };
        },
      }),
      favorites: Object.freeze({
        ids: () => { try { return call('favorites'); } catch { return []; } },
        list: () => call('favoriteproducts'),
        toggle: (productId) => ({ value: call('favorite', { id: productId }), persisted: true }),
      }),
      messages: Object.freeze({
        list: () => { try { return call('messages'); } catch { return []; } },
        canOpen: () => true,
        open: (other, productId) => call('thread', { other, product: productId }),
        send({ otherId, productId, content }) {
          call('message', { other: otherId, product: productId, content }, 'POST');
          return { value: true, persisted: true };
        },
      }),
      orders: Object.freeze({
        list: (side) => { try { return call('orders', { side: side === 'seller' ? 'seller' : 'buyer' }); } catch { return []; } },
        find: (id) => call('order', { id }),
        create({ productId, receiverName, phone, address, remark, deliveryType, payMethod }) {
          const value = call('orderadd', {
            product: productId, deliveryType: deliveryType || 'meetup', payMethod: payMethod || 'cod',
            receiverName, phone, address, remark: remark || '',
          }, 'POST');
          return { value, persisted: true };
        },
        transition(id, action) {
          return { value: call('orderstatus', { id, status: action }, 'POST'), persisted: true };
        },
      }),
      ratings: Object.freeze({
        forUser: (id) => { try { return call('ratings', { user: id }); } catch { return []; } },
        forOrder: (id) => call('orderratings', { id }),
        create({ orderId, score, content }) {
          call('rating', { order: orderId, score, content }, 'POST');
          return { value: true, persisted: true };
        },
      }),
      reports: Object.freeze({
        list: () => { try { return call('reports'); } catch { return []; } },
        create({ targetType, targetId, reason }) {
          call('report', { targetType, targetId, reason }, 'POST');
          return { value: true, persisted: true };
        },
        handle(id, status, remark) {
          call('reporthandle', { id, status, remark: remark || '' }, 'POST');
          return { value: true, persisted: true };
        },
      }),
    });
  }

  window.EchoMarketHttp = Object.freeze({ createHttpApi });
})();
