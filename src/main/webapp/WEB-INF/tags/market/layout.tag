<%@ tag pageEncoding="UTF-8" body-content="scriptless" %>
<%@ attribute name="title" required="true" %>
<%@ attribute name="section" required="false" %>
<%@ attribute name="stylesheet" required="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="market" tagdir="/WEB-INF/tags/market" %>
<!doctype html>
<html lang="zh-CN" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><c:out value="${title}"/> · 回响市集</title>
    <script src="<c:url value='/js/market/theme.js'/>"></script>
    <link rel="stylesheet" href="<c:url value='/css/market/base.css'/>">
    <c:if test="${not empty stylesheet}"><link rel="stylesheet" href="<c:url value='${stylesheet}'/>"></c:if>
</head>
<body>
<a class="skip-link" href="#market-main">跳到主要内容</a>
<header class="navbar">
    <div class="wrap navbar-inner">
        <a class="brand" href="<c:url value='/products'/>">
            <span class="brand-mark" aria-hidden="true"><i></i><i></i><i></i></span>
            <span><strong>回响市集</strong><small>EchoMarket</small></span>
        </a>
        <nav class="nav-links" aria-label="主导航">
            <a href="<c:url value='/products'/>" ${section eq 'products' ? 'aria-current="page"' : ''}>浏览商品</a>
            <a href="<c:url value='/messages'/>" ${section eq 'messages' ? 'aria-current="page"' : ''}>消息</a>
            <a href="<c:url value='/myorders'/>" ${section eq 'orders' ? 'aria-current="page"' : ''}>订单</a>
            <a href="<c:url value='/favorites'/>" ${section eq 'favorites' ? 'aria-current="page"' : ''}>我的收藏</a>
        </nav>
        <div class="nav-tools">
            <a class="btn primary" href="<c:url value='/productaddpage'/>"><span aria-hidden="true">＋</span> 发布闲置</a>
            <button type="button" class="btn theme" id="theme-toggle" aria-label="切换暗色主题" aria-pressed="false" hidden><span aria-hidden="true">☾</span></button>
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <details class="profile">
                        <summary><market:identity name="${empty sessionScope.user.nickname ? sessionScope.user.username : sessionScope.user.nickname}"/></summary>
                        <div class="profile-menu">
                            <a href="<c:url value='/soldorders'/>">我卖出的</a>
                            <a href="<c:url value='/reports'/>">我的举报</a>
                            <c:if test="${sessionScope.user.role eq 1}"><a href="<c:url value='/adminreports'/>">举报处理</a></c:if>
                            <a href="<c:url value='/logout'/>">退出登录</a>
                        </div>
                    </details>
                </c:when>
                <c:otherwise><a class="btn" href="<c:url value='/login.jsp'/>">登录</a></c:otherwise>
            </c:choose>
        </div>
    </div>
</header>
<main class="wrap main" id="market-main" tabindex="-1">
    <jsp:doBody/>
</main>
<footer class="wrap footer"><span><strong>回响市集</strong> · EchoMarket</span><span>校园二手市集</span></footer>
</body>
</html>
