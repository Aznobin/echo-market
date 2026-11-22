<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>Echo Market - 我的举报</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/report/report.css">
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
    <h2 class="page-title">我提交过的举报</h2>

    <c:if test="${not empty msg}">
        <div class="alert-msg">${msg}</div>
    </c:if>

    <c:choose>
        <c:when test="${empty reports}">
            <div class="empty-box">
                <p>还没有提交过举报。</p>
            </div>
        </c:when>
        <c:otherwise>
            <c:forEach items="${reports}" var="r">
                <div class="report-card">
                    <div class="report-head">
                        <span class="report-target">
                            举报对象：
                            <c:choose>
                                <c:when test="${r.targetType == 1}">用户 ${r.targetTitle}</c:when>
                                <c:otherwise>商品 ${r.targetTitle}</c:otherwise>
                            </c:choose>
                        </span>
                        <span class="report-status">
                            <c:choose>
                                <c:when test="${r.handleStatus == 0}">待处理</c:when>
                                <c:when test="${r.handleStatus == 1}">已处理</c:when>
                                <c:when test="${r.handleStatus == 2}">已驳回</c:when>
                                <c:otherwise>未知</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <p class="report-reason">${r.reason}</p>
                    <p class="report-time">提交时间：${r.createTime}</p>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</main>
</body>
</html>
