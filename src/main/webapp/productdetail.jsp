<%--
  Created by IntelliJ IDEA.
  User: miku
  Date: 2026/11/20
  Time: 20:19
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>Echo Market - 商品详情</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/productdetail.css">
</head>
<body>
<div class="detail-container">
    <div class="detail-topbar">
        <a class="back-link" href="${pageContext.request.contextPath}/products">← 返回商品列表</a>
        <c:if test="${not empty product}">
            <span class="product-id-badge">#${product.id}</span>
        </c:if>
    </div>

    <c:if test="${not empty msg}">
        <div class="empty-box">
            <p class="empty-msg">${msg}</p>
            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/products">返回商品列表</a>
        </div>
    </c:if>

    <c:if test="${not empty product}">
        <div class="detail-card">
            <div class="detail-media">
                <c:choose>
                    <c:when test="${not empty product.image}">
                        <img class="detail-image"
                             src="${pageContext.request.contextPath}/images/${product.image}"
                             alt="${product.title}">
                    </c:when>
                    <c:otherwise>
                        <div class="image-placeholder">暂无图片</div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="detail-info">
                <div class="detail-tags">
                    <c:choose>
                        <c:when test="${product.status == 0}">
                            <span class="status-badge status-pending">待售</span>
                        </c:when>
                        <c:when test="${product.status == 1}">
                            <span class="status-badge status-sold">已售</span>
                        </c:when>
                        <c:otherwise>
                            <span class="status-badge status-offline">已下架</span>
                        </c:otherwise>
                    </c:choose>
                    <span class="meta-item">分类 ID：${product.categoryId}</span>
                    <span class="meta-item">卖家：${seller.username}</span>
                    <span class="meta-item">卖家评分：<fmt:formatNumber value="${sellerScore}" pattern="0.0"/> 分（${sellerRateCount} 条）</span>
                    <a class="meta-link" href="${pageContext.request.contextPath}/ratings?userId=${product.sellerId}">看 TA 收到的评价</a>
                </div>

                <h1 class="detail-title">${product.title}</h1>

                <div class="price-panel">
                    <span class="price-label">商品价格</span>
                    <span class="price-amount">¥ <fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></span>
                </div>

                <div class="desc-panel">
                    <h2 class="desc-heading">商品描述</h2>
                    <p class="desc-content">
                        <c:out value="${empty product.description ? '暂无详细描述' : product.description}"/>
                    </p>
                </div>

                <div class="detail-actions">
                    <c:choose>
                        <c:when test="${product.status == 0}">
                            <a class="btn btn-primary"
                               href="${pageContext.request.contextPath}/productbuy?productId=${product.id}">立即下单
                            </a>
                        </c:when>
                        <c:otherwise>
                            <button type="button" class="btn btn-disabled" disabled>当前状态不可下单</button>
                        </c:otherwise>
                    </c:choose>
                    <a class="btn btn-secondary" href="${pageContext.request.contextPath}/products">继续浏览</a>

                    <form action="${pageContext.request.contextPath}/favoritetoggle" method="post" class="inline-form">
                        <input type="hidden" name="productId" value="${product.id}">
                        <c:choose>
                            <c:when test="${favorited}">
                                <button class="btn btn-secondary" type="submit">取消收藏</button>
                            </c:when>
                            <c:otherwise>
                                <button class="btn btn-secondary" type="submit">收藏这个商品</button>
                            </c:otherwise>
                        </c:choose>
                    </form>
                </div>
            </div>
        </div>
    </c:if>
</div>
</body>
</html>
