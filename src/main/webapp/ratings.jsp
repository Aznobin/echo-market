<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>Echo Market - 收到的评价</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ratings.css">
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
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">退出登录</a>
    </div>
</header>

<main class="container">
    <h2 class="page-title">${target.username} 收到的评价</h2>

    <div class="score-panel">
        <span class="score-big"><fmt:formatNumber value="${avgScore}" pattern="0.0"/></span>
        <span class="score-unit">分</span>
        <span class="score-count">共 ${rateCount} 条评价</span>
    </div>

    <c:choose>
        <c:when test="${empty ratings}">
            <div class="empty-box">
                <p class="empty-msg">还没有人评价过 TA。</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="rating-list">
                <c:forEach items="${ratings}" var="r">
                    <div class="rating-card">
                        <div class="rating-head">
                            <span class="rating-from">${r.fromName}</span>
                            <span class="rating-score">${r.score} 星</span>
                        </div>
                        <p class="rating-content">${r.content}</p>
                        <p class="rating-time">${r.createTime}</p>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</main>
</body>
</html>
