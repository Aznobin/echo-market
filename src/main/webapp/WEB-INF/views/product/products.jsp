<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="market" tagdir="/WEB-INF/tags/market" %>
<market:layout title="浏览商品" section="products" stylesheet="/css/market/products.css">
    <section class="hero" aria-labelledby="market-title">
        <div class="hero-copy">
            <span class="kicker">CAMPUS MARKET · 校园闲置交易</span>
            <h1 id="market-title">闲置换手，<em>好物接着用。</em></h1>
            <p>看看同学们挂上了什么，遇到合适的就聊聊。</p>
        </div>
        <div class="hero-art" aria-hidden="true"><div class="stamp"><div>ECHO<br>MARKET<span>校园流转</span></div></div></div>
    </section>
    <section aria-labelledby="latest-products">
        <header class="section-heading">
            <h2 id="latest-products">在售好物</h2>
            <c:if test="${empty msg}"><span class="muted">共 ${fn:length(products)} 件</span></c:if>
        </header>
        <c:choose>
            <c:when test="${not empty msg}"><p class="notice" role="alert"><c:out value="${msg}"/></p></c:when>
            <c:when test="${empty products}"><div class="empty"><h2>暂时没有在售商品</h2><p>有用不上的好物？可以先发布一件。</p></div></c:when>
            <c:otherwise>
                <div class="product-grid">
                    <c:forEach items="${products}" var="p" varStatus="loop">
                        <market:productCard id="${p.id}" name="${p.title}" image="${p.image}" price="${p.price}"
                            label="${empty p.categoryName ? '闲置商品' : p.categoryName}"
                            seller="${empty p.sellerName ? '市集用户' : p.sellerName}" loading="${loop.index ge 4 ? 'lazy' : 'eager'}"/>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </section>
    <script src="<c:url value='/js/market/product-media.js'/>"></script>
</market:layout>
