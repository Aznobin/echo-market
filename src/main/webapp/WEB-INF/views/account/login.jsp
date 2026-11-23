<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>登录</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/style.css">
</head>
<body>
<div class="box">
    <h2>回响市集 · 登录</h2>
    <p class="msg"><%= request.getAttribute("msg") == null ? "" : request.getAttribute("msg") %></p>
    <form action="login" method="post">
        <input type="text" name="username" placeholder="用户名" required>
        <input type="password" name="password" placeholder="密码" required>
        <button type="submit">登录</button>
    </form>
    <p class="tip">还没有账号？<a href="register.jsp">去注册</a></p>
</div>
</body>
</html>
