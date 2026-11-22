<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>Echo Market - 我买到的订单</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/order/orders.css">
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
    <h2 class="page-title">我买到的订单</h2>

    <div class="filter-bar">
        <a class="filter-item ${status == -1 ? 'active' : ''}" href="${pageContext.request.contextPath}/myorders?status=-1">全部</a>
        <a class="filter-item ${status == 0 ? 'active' : ''}" href="${pageContext.request.contextPath}/myorders?status=0">待付款</a>
        <a class="filter-item ${status == 1 ? 'active' : ''}" href="${pageContext.request.contextPath}/myorders?status=1">已付款</a>
        <a class="filter-item ${status == 2 ? 'active' : ''}" href="${pageContext.request.contextPath}/myorders?status=2">已发货</a>
        <a class="filter-item ${status == 3 ? 'active' : ''}" href="${pageContext.request.contextPath}/myorders?status=3">已完成</a>
        <a class="filter-item ${status == 4 ? 'active' : ''}" href="${pageContext.request.contextPath}/myorders?status=4">已取消</a>
    </div>

    <c:if test="${not empty msg}">
        <div class="alert-msg">${msg}</div>
    </c:if>

    <c:choose>
        <c:when test="${empty orders}">
            <div class="empty-box">
                <p>这里还没有订单，去商品列表逛一逛吧。</p>
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/products">去逛逛</a>
            </div>
        </c:when>
        <c:otherwise>
            <c:forEach items="${orders}" var="o">
                <div class="order-card">
                    <div class="order-head">
                        <span class="order-no">订单号：${o.orderNo}</span>
                        <span class="order-status">
                            <c:choose>
                                <c:when test="${o.status == 0}">待付款</c:when>
                                <c:when test="${o.status == 1}">已付款</c:when>
                                <c:when test="${o.status == 2}">已发货</c:when>
                                <c:when test="${o.status == 3}">已完成</c:when>
                                <c:when test="${o.status == 4}">已取消</c:when>
                                <c:otherwise>未知状态</c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <div class="order-body">
                        <c:choose>
                            <c:when test="${not empty o.productImage}">
                                <img class="order-thumb" src="${pageContext.request.contextPath}/images/${o.productImage}" alt="商品图片">
                            </c:when>
                            <c:otherwise>
                                <div class="order-thumb-empty">无图</div>
                            </c:otherwise>
                        </c:choose>

                        <div class="order-info">
                            <div class="order-title">${o.productTitle}</div>
                            <div class="order-sub">卖家：${o.sellerName}</div>
                            <div class="order-sub">下单时间：${o.updateTime}</div>
                        </div>

                        <div class="order-amount">¥ ${o.amount}</div>
                    </div>

                    <div class="order-actions">
                        <a class="btn btn-secondary" href="${pageContext.request.contextPath}/orderdetail?id=${o.id}">查看详情</a>

                        <c:if test="${o.status == 0}">
                            <form action="${pageContext.request.contextPath}/orderstatus" method="post" class="inline-form">
                                <input type="hidden" name="orderId" value="${o.id}">
                                <input type="hidden" name="action" value="pay">
                                <button class="btn btn-primary" type="submit">去付款</button>
                            </form>
                            <form action="${pageContext.request.contextPath}/orderstatus" method="post" class="inline-form">
                                <input type="hidden" name="orderId" value="${o.id}">
                                <input type="hidden" name="action" value="cancel">
                                <button class="btn btn-plain" type="submit">取消订单</button>
                            </form>
                        </c:if>

                        <c:if test="${o.status == 1}">
                            <form action="${pageContext.request.contextPath}/orderstatus" method="post" class="inline-form">
                                <input type="hidden" name="orderId" value="${o.id}">
                                <input type="hidden" name="action" value="cancel">
                                <button class="btn btn-plain" type="submit">取消订单</button>
                            </form>
                        </c:if>

                        <c:if test="${o.status == 2}">
                            <form action="${pageContext.request.contextPath}/orderstatus" method="post" class="inline-form">
                                <input type="hidden" name="orderId" value="${o.id}">
                                <input type="hidden" name="action" value="confirm">
                                <button class="btn btn-primary" type="submit">确认收货</button>
                            </form>
                        </c:if>

                        <c:if test="${o.status == 3}">
                            <a class="btn btn-primary" href="${pageContext.request.contextPath}/orderdetail?id=${o.id}">去评价</a>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</main>
</body>
</html>
