<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="market" tagdir="/WEB-INF/tags/market" %>
<market:layout title="${empty product ? '商品详情' : product.title}" section="products" stylesheet="/css/market/products.css">
    <a class="text-link crumb" href="<c:url value='/products'/>">← 返回商品列表</a>
    <c:choose>
        <c:when test="${empty product}">
            <div class="empty"><h1>找不到这个商品</h1><p><c:out value="${msg}" default="请从商品列表选择要查看的商品。"/></p></div>
        </c:when>
        <c:otherwise>
            <c:url var="ratingsUrl" value="/ratings"><c:param name="userId" value="${product.sellerId}"/></c:url>
            <c:url var="buyUrl" value="/productbuy"><c:param name="productId" value="${product.id}"/></c:url>
            <c:url var="messageUrl" value="/messagethread"><c:param name="otherId" value="${product.sellerId}"/><c:param name="productId" value="${product.id}"/></c:url>
            <c:url var="reportUrl" value="/reportadd"><c:param name="targetType" value="2"/><c:param name="targetId" value="${product.id}"/></c:url>
            <div class="columns detail-layout">
                <figure class="product-media detail-photo"><market:productImage image="${product.image}" alt="${product.title}"/></figure>
                <section class="panel detail-info">
                    <div class="actions">
                        <span class="tag"><c:out value="${empty product.categoryName ? '闲置商品' : product.categoryName}"/></span>
                        <span class="tag state">${product.status eq 0 ? '待售' : product.status eq 1 ? '已售' : '已下架'}</span>
                    </div>
                    <header class="page-head"><h1><c:out value="${product.title}"/></h1></header>
                    <p class="price"><small>¥</small> <fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></p>
                    <p class="description"><c:out value="${empty product.description ? '卖家还没有填写商品描述。' : product.description}"/></p>
                    <div class="seller">
                        <div><market:identity name="${empty product.sellerName ? '市集用户' : product.sellerName}"/>
                            <p class="muted"><c:choose><c:when test="${sellerRateCount gt 0}"><fmt:formatNumber value="${sellerScore}" pattern="0.0"/> 分 · ${sellerRateCount} 条评价</c:when><c:otherwise>暂无评价</c:otherwise></c:choose></p>
                        </div>
                        <a class="text-link" href="<c:out value='${ratingsUrl}'/>">查看卖家评价</a>
                    </div>
                    <div class="actions detail-actions">
                        <c:if test="${product.status eq 0 and (empty sessionScope.user or sessionScope.user.id ne product.sellerId)}"><a class="btn primary" href="<c:out value='${buyUrl}'/>">立即下单</a></c:if>
                        <c:if test="${empty sessionScope.user or sessionScope.user.id ne product.sellerId}"><a class="btn" href="<c:out value='${messageUrl}'/>">联系卖家</a></c:if>
                        <form action="<c:url value='/favoritetoggle'/>" method="post">
                            <input type="hidden" name="productId" value="${product.id}">
                            <button class="btn" type="submit" aria-pressed="${favorited eq true}">${favorited ? '取消收藏' : '收藏商品'}</button>
                        </form>
                        <a class="text-link" href="<c:out value='${reportUrl}'/>">举报商品</a>
                    </div>
                </section>
            </div>
        </c:otherwise>
    </c:choose>
    <script src="<c:url value='/js/market/product-media.js'/>"></script>
</market:layout>
