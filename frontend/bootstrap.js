(() => {
  'use strict';
  let storage;
  try { storage = localStorage; } catch { /* The app can run in memory. */ }

  // A deployed adapter can be wired here once the real HTTP contract is agreed.
  // Standalone preview deliberately ships only the local mock.
  window.echoMarket = window.EchoMarketApi.connect({
    createAdapter: window.EchoMarketMock.createMockApi,
    storage,
  });
})();
