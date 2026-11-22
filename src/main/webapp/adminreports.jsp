<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>Echo Market - 举报处理</title>
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
    <h2 class="page-title">全部举报（管理员）</h2>

    <c:if test="${not empty msg}">
        <div class="alert-msg">${msg}</div>
    </c:if>

    <c:choose>
        <c:when test="${empty reports}">
            <div class="empty-box">
                <p>目前没有举报。</p>
            </div>
        </c:when>
        <c:otherwise>
            <table class="report-table">
                <thead>
                <tr>
                    <th width="60">编号</th>
                    <th width="110">举报人</th>
                    <th width="150">举报对象</th>
                    <th>理由</th>
                    <th width="90">进度</th>
                    <th width="230">处理</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${reports}" var="r">
                    <tr>
                        <td>#${r.id}</td>
                        <td>${r.reporterName}</td>
                        <td>
                            <c:choose>
                                <c:when test="${r.targetType == 1}">用户 ${r.targetTitle}</c:when>
                                <c:otherwise>商品 ${r.targetTitle}</c:otherwise>
                            </c:choose>
                        </td>
                        <td>${r.reason}</td>
                        <td>
                            <c:choose>
                                <c:when test="${r.handleStatus == 0}">待处理</c:when>
                                <c:when test="${r.handleStatus == 1}">已处理</c:when>
                                <c:when test="${r.handleStatus == 2}">已驳回</c:when>
                                <c:otherwise>未知</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <form action="${pageContext.request.contextPath}/adminreporthandle" method="post" class="inline-form">
                                <input type="hidden" name="id" value="${r.id}">
                                <input type="hidden" name="handleStatus" value="1">
                                <button class="btn btn-primary" type="submit">标记已处理</button>
                            </form>
                            <form action="${pageContext.request.contextPath}/adminreporthandle" method="post" class="inline-form">
                                <input type="hidden" name="id" value="${r.id}">
                                <input type="hidden" name="handleStatus" value="2">
                                <button class="btn btn-plain" type="submit">驳回</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</main>
</body>
</html>
