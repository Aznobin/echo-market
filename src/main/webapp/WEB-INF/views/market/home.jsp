<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="zh-CN" data-theme="light">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="回响市集校园二手交易平台的静态前端样板。">
  <title>浏览商品 · 回响市集</title>
  <script src="<c:url value='/js/market/fixtures.js'/>"></script>
  <script src="<c:url value='/js/market/mock-api.js'/>"></script>
  <script src="<c:url value='/js/market/api.js'/>"></script>
  <script src="<c:url value='/js/market/bootstrap.js'/>"></script>
  <script src="<c:url value='/js/market/market.js'/>"></script>
  <link rel="stylesheet" href="<c:url value='/css/market/market.css'/>">
</head>
<body>
  <header class="navbar">
    <div class="navbar-inner wrap">
      <a class="brand" href="#products">
        <span class="brand-mark" aria-hidden="true"><i></i><i></i><i></i></span>
        <span><strong>回响市集</strong><small>EchoMarket</small></span>
      </a>
      <nav class="nav-links" aria-label="主导航">
        <a href="#products" data-nav="products">浏览商品</a>
        <a href="#messages" data-nav="messages">消息</a>
        <a href="#myorders" data-nav="myorders">订单</a>
        <a href="#favorites" data-nav="favorites">我的收藏</a>
      </nav>
      <div class="nav-tools">
        <a class="btn primary publish" href="#productadd"><span aria-hidden="true">＋</span> 发布闲置</a>
        <button type="button" class="btn theme" id="theme-toggle" aria-label="切换暗色主题" title="切换暗色主题" aria-pressed="false"><span aria-hidden="true">☾</span></button>
        <details class="profile" id="profile">
          <summary id="profile-summary"><span class="avatar" aria-hidden="true">User</span><span>小满</span></summary>
          <div class="profile-menu" id="profile-menu"></div>
        </details>
      </div>
    </div>
  </header>
  <main id="view" class="wrap main" tabindex="-1">
    <noscript><p class="notice">请启用 JavaScript，以查看页面和前端演示数据。</p></noscript>
  </main>
  <footer class="footer wrap">
    <span><strong>回响市集</strong> · EchoMarket</span>
    <p>前端样板 · 数据仅供演示，不产生真实交易</p>
  </footer>
  <div class="toast" id="toast" role="status" hidden></div>
  <dialog id="confirm-dialog" aria-labelledby="confirm-title">
    <form method="dialog" class="dialog-body">
      <h2 id="confirm-title"></h2><p id="confirm-text" class="muted"></p>
      <div class="actions"><button class="btn" value="cancel" autofocus>再想想</button><button class="btn primary" value="confirm">确认</button></div>
    </form>
  </dialog>
</body>
</html>
