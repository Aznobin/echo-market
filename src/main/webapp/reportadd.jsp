<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>Echo Market - 提交举报</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/report.css">
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
    <h2 class="page-title">提交举报</h2>

    <c:if test="${not empty msg}">
        <div class="alert-msg">${msg}</div>
    </c:if>

    <div class="report-card">
        <p class="report-target">
            举报对象：
            <c:choose>
                <c:when test="${param.targetType == 1}">用户（编号 ${param.targetId}）</c:when>
                <c:otherwise>商品（编号 ${param.targetId}）</c:otherwise>
            </c:choose>
        </p>

        <form action="${pageContext.request.contextPath}/reportadd" method="post">
            <input type="hidden" name="targetType" value="${param.targetType}">
            <input type="hidden" name="targetId" value="${param.targetId}">

            <div class="form-row">
                <label for="reason">举报理由</label>
                <textarea id="reason" name="reason" rows="5" maxlength="500" class="form-textarea" required
                          placeholder="写清楚遇到了什么问题，比如虚假描述、联系不上卖家、卖假货等等"></textarea>
            </div>

            <div class="action-bar">
                <button class="btn btn-primary" type="submit">提交举报</button>
                <a class="btn btn-plain" href="${pageContext.request.contextPath}/products">算了，回商品列表</a>
            </div>
        </form>

        <p class="tip-text">提交后管理员会看到这条举报并处理，你可以在「我的举报」里查看处理进度。</p>
    </div>
</main>
</body>
</html>
