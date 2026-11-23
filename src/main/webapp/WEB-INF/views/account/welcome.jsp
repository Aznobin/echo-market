<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>Echo Market - 欢迎</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/style.css">
</head>
<body>
<div class="topbar">
    <span class="topbar-user">当前用户：${sessionScope.user.username}</span>
    <a class="topbar-logout" href="${pageContext.request.contextPath}/logout">退出登录</a>
</div>

<div class="box wide">
    <h2>欢迎，${sessionScope.user.username}</h2>
    <p>注册时间：${sessionScope.user.createTime}</p>
    <p>状态：${sessionScope.user.status}</p>
    <p><a href="${pageContext.request.contextPath}/products">进入商品集市 →</a></p>
    <p><a href="${pageContext.request.contextPath}/profile">修改个人资料</a></p>
</div>
</body>
</html>
