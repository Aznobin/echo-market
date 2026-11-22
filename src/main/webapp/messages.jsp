<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>Echo Market - 消息中心</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/messages.css">
</head>
<body>
<header class="navbar">
    <a href="${pageContext.request.contextPath}/products" class="brand">Echo Market 二手集市</a>
    <div style="display: flex; align-items: center; gap: 12px;">
        <a href="${pageContext.request.contextPath}/productaddpage" class="btn btn-primary">+ 发布闲置商品</a>
        <a href="${pageContext.request.contextPath}/products">浏览商品</a>
        <a href="${pageContext.request.contextPath}/myorders">我买到的</a>
        <a href="${pageContext.request.contextPath}/soldorders">我卖出的</a>
        <a href="${pageContext.request.contextPath}/favorites">我的收藏</a>
        <a href="${pageContext.request.contextPath}/messages">消息</a>
        <a href="${pageContext.request.contextPath}/reports">我的举报</a>
        <c:if test="${sessionScope.user.role == 1}">
            <a href="${pageContext.request.contextPath}/adminreports">举报处理</a>
        </c:if>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">退出登录</a>
    </div>
</header>

<main class="container">
    <h2 class="page-title">消息中心</h2>

    <c:if test="${unreadCount > 0}">
        <div class="alert-msg">你有 ${unreadCount} 条未读消息</div>
    </c:if>

    <c:if test="${not empty msg}">
        <div class="alert-msg">${msg}</div>
    </c:if>

    <c:choose>
        <c:when test="${empty conversations}">
            <div class="empty-box">
                <p>还没有收到消息。在商品详情页点「联系卖家」就能开始聊。</p>
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/products">去看商品</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="conv-list">
                <c:forEach items="${conversations}" var="m">
                    <a class="conv-item"
                       href="${pageContext.request.contextPath}/messagethread?otherId=${m.otherId}&productId=${m.productId}">
                        <div class="conv-avatar">${m.otherName}</div>
                        <div class="conv-main">
                            <div class="conv-title">
                                ${m.otherName}
                                <span class="conv-product">关于：${m.productTitle}</span>
                            </div>
                            <div class="conv-last">${m.content}</div>
                        </div>
                        <div class="conv-time">${m.createTime}</div>
                    </a>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</main>
</body>
</html>
