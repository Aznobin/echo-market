<%--
  Created by IntelliJ IDEA.
  User: miku
  Date: 2026/11/21
  Time: 14:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>Echo Market - 下单成功</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/order/ordersuccess.css">
</head>
<body>
<main class="checkout-container">
    <div class="empty-box">
        <h2 class="panel-title" style="margin-bottom: 12px;">购买成功</h2>
        <c:choose>
            <c:when test="${not empty sessionScope.lastOrder}">
                <p class="empty-msg">订单编号：<strong>${sessionScope.lastOrder.orderNo}</strong></p>
                <p class="safety-note" style="margin-bottom: 20px;">
                    订单金额：¥ ${sessionScope.lastOrder.amount} ｜ 交接地址：${sessionScope.lastOrder.address}
                </p>
            </c:when>
            <c:otherwise>
                <p class="empty-msg">下单已完成，请返回商品列表查看。</p>
            </c:otherwise>
        </c:choose>
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/products">返回商品列表</a>
    </div>
</main>
</body>
</html>