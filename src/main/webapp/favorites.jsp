<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>Echo Market - 我的收藏</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/favorites.css">
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
    <h2 class="page-title">我的收藏</h2>

    <c:if test="${not empty msg}">
        <div class="alert-msg">${msg}</div>
    </c:if>

    <c:choose>
        <c:when test="${empty favorites}">
            <div class="empty-box">
                <p>还没有收藏任何东西，看到喜欢的商品点一下「收藏」就会出现在这里。</p>
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/products">去逛商品</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="fav-list">
                <c:forEach items="${favorites}" var="f">
                    <div class="fav-card">
                        <c:choose>
                            <c:when test="${not empty f.productImage}">
                                <img class="fav-img" src="${pageContext.request.contextPath}/images/${f.productImage}" alt="商品图片">
                            </c:when>
                            <c:otherwise>
                                <div class="fav-img-empty">无图</div>
                            </c:otherwise>
                        </c:choose>

                        <div class="fav-info">
                            <div class="fav-title">${f.productTitle}</div>
                            <div class="fav-price">¥ ${f.productPrice}</div>
                            <div class="fav-sub">
                                收藏时间：${f.createTime}
                                <c:if test="${f.productStatus != 0}">
                                    （该商品已经不是待售状态了）
                                </c:if>
                            </div>
                        </div>

                        <div class="fav-actions">
                            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/productdetail?id=${f.productId}">查看商品</a>
                            <form action="${pageContext.request.contextPath}/favoritetoggle" method="post" class="inline-form">
                                <input type="hidden" name="productId" value="${f.productId}">
                                <button class="btn btn-plain" type="submit">取消收藏</button>
                            </form>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</main>
</body>
</html>
