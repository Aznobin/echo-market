(() => {
  'use strict';
  let storage;
  try { storage = localStorage; } catch { /* The app can run in memory. */ }

  window.echoMarket = window.EchoMarketApi.connect({
    createAdapter: window.EchoMarketHttp.createHttpApi,
    storage,
  });
})();
