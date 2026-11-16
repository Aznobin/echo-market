<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>欢迎</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="box wide">
    <h2>欢迎，${sessionScope.user.username}</h2>
    <p>注册时间：${sessionScope.user.createTime}</p>
    <p>状态：${sessionScope.user.status}</p>
    <p><a href="logout">退出登录</a></p>
</div>
</body>
</html>
