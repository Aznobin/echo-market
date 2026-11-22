<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>Echo Market - 订单详情</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/orderdetail.css">
</head>
<body>
<header class="navbar">
    <a href="${pageContext.request.contextPath}/products" class="brand">Echo Market 二手集市</a>
    <div style="display: flex; align-items: center; gap: 12px;">
        <a href="${pageContext.request.contextPath}/productaddpage" class="btn btn-primary">+ 发布闲置商品</a>
        <a href="${pageContext.request.contextPath}/products">浏览商品</a>
        <a href="${pageContext.request.contextPath}/myorders">我买到的</a>
        <a href="${pageContext.request.contextPath}/soldorders">我卖出的</a>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">退出登录</a>
    </div>
</header>

<main class="container">
    <c:if test="${not empty msg}">
        <div class="alert-msg">${msg}</div>
    </c:if>

    <c:if test="${not empty order}">
        <div class="detail-card">
            <div class="detail-head">
                <h2 class="page-title">
                    <c:choose>
                        <c:when test="${not empty sessionScope.lastOrder and sessionScope.lastOrder.id == order.id}">购买成功</c:when>
                        <c:otherwise>订单详情</c:otherwise>
                    </c:choose>
                </h2>
                <span class="order-status">
                    <c:choose>
                        <c:when test="${order.status == 0}">待付款</c:when>
                        <c:when test="${order.status == 1}">已付款</c:when>
                        <c:when test="${order.status == 2}">已发货</c:when>
                        <c:when test="${order.status == 3}">已完成</c:when>
                        <c:when test="${order.status == 4}">已取消</c:when>
                        <c:otherwise>未知状态</c:otherwise>
                    </c:choose>
                </span>
            </div>

            <div class="detail-product">
                <c:choose>
                    <c:when test="${not empty order.productImage}">
                        <img class="detail-thumb" src="${pageContext.request.contextPath}/images/${order.productImage}" alt="商品图片">
                    </c:when>
                    <c:otherwise>
                        <div class="detail-thumb-empty">无图</div>
                    </c:otherwise>
                </c:choose>
                <div class="detail-product-info">
                    <div class="detail-title">${order.productTitle}</div>
                    <a class="link" href="${pageContext.request.contextPath}/productdetail?id=${order.productId}">查看商品页</a>
                </div>
                <div class="detail-amount">¥ ${order.amount}</div>
            </div>

            <table class="info-table">
                <tr>
                    <th>订单编号</th>
                    <td>${order.orderNo}</td>
                    <th>订单状态</th>
                    <td>${order.status}</td>
                </tr>
                <tr>
                    <th>买家</th>
                    <td>${order.buyerName}</td>
                    <th>卖家</th>
                    <td>${order.sellerName}</td>
                </tr>
                <tr>
                    <th>交易方式</th>
                    <td>
                        <c:choose>
                            <c:when test="${order.deliveryType == 'meetup'}">校内当面交易</c:when>
                            <c:otherwise>送货到宿舍楼下</c:otherwise>
                        </c:choose>
                    </td>
                    <th>支付方式</th>
                    <td>
                        <c:choose>
                            <c:when test="${order.payMethod == 'online'}">在线担保支付</c:when>
                            <c:otherwise>当面验货付款</c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <th>联系人</th>
                    <td>${order.receiverName}</td>
                    <th>联系电话</th>
                    <td>${order.phone}</td>
                </tr>
                <tr>
                    <th>交接地址</th>
                    <td colspan="3">${order.address}</td>
                </tr>
                <tr>
                    <th>备注</th>
                    <td colspan="3">${empty order.remark ? '无' : order.remark}</td>
                </tr>
                <tr>
                    <th>更新时间</th>
                    <td colspan="3">${order.updateTime}</td>
                </tr>
            </table>

            <div class="action-bar">
                <c:if test="${isBuyer and order.status == 0}">
                    <form action="${pageContext.request.contextPath}/orderstatus" method="post" class="inline-form">
                        <input type="hidden" name="orderId" value="${order.id}">
                        <input type="hidden" name="action" value="pay">
                        <button class="btn btn-primary" type="submit">去付款</button>
                    </form>
                </c:if>

                <c:if test="${isSeller and order.status == 1}">
                    <form action="${pageContext.request.contextPath}/orderstatus" method="post" class="inline-form">
                        <input type="hidden" name="orderId" value="${order.id}">
                        <input type="hidden" name="action" value="ship">
                        <button class="btn btn-primary" type="submit">标记已发货</button>
                    </form>
                </c:if>

                <c:if test="${isBuyer and order.status == 2}">
                    <form action="${pageContext.request.contextPath}/orderstatus" method="post" class="inline-form">
                        <input type="hidden" name="orderId" value="${order.id}">
                        <input type="hidden" name="action" value="confirm">
                        <button class="btn btn-primary" type="submit">确认收货</button>
                    </form>
                </c:if>

                <c:if test="${(isBuyer or isSeller) and (order.status == 0 or order.status == 1)}">
                    <form action="${pageContext.request.contextPath}/orderstatus" method="post" class="inline-form">
                        <input type="hidden" name="orderId" value="${order.id}">
                        <input type="hidden" name="action" value="cancel">
                        <button class="btn btn-plain" type="submit">取消订单</button>
                    </form>
                </c:if>

                <a class="btn btn-plain" href="${pageContext.request.contextPath}/myorders">返回订单列表</a>
            </div>
        </div>
    </c:if>
</main>
</body>
</html>
