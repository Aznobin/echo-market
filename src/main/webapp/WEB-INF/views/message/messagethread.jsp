<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>Echo Market - 聊天</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/message/messages.css">
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
    <div class="thread-head">
        <h2 class="page-title">和 ${other.username} 的对话</h2>
        <c:if test="${not empty product}">
            <div class="thread-product">
                聊的商品：
                <a class="link" href="${pageContext.request.contextPath}/productdetail?id=${product.id}">${product.title}</a>
                <span class="thread-price">¥ ${product.price}</span>
            </div>
        </c:if>
    </div>

    <div class="chat-box">
        <c:choose>
            <c:when test="${empty messages}">
                <p class="tip-text">还没有聊过，先问一句吧。</p>
            </c:when>
            <c:otherwise>
                <c:forEach items="${messages}" var="m">
                    <div class="chat-row ${m.fromId == sessionScope.user.id ? 'chat-mine' : 'chat-other'}">
                        <div class="chat-bubble">
                            <div class="chat-text">${m.content}</div>
                            <div class="chat-time">${m.createTime}</div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>

    <form class="chat-form" action="${pageContext.request.contextPath}/messagesend" method="post">
        <input type="hidden" name="otherId" value="${otherId}">
        <input type="hidden" name="productId" value="${productId}">
        <textarea class="chat-input" name="content" rows="3" maxlength="500" required
                  placeholder="问一句这个商品还在不在、能不能便宜点……"></textarea>
        <button class="btn btn-primary" type="submit">发送</button>
    </form>
</main>
</body>
</html>
