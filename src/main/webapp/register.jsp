<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>Echo Market - 注册</title>
    <link rel="stylesheet" href="css/register.css">
</head>
<body>
<div class="register-wrap">
    <div class="register-card">
        <h2 class="register-title">Echo Market 二手集市 · 注册</h2>
        <p class="msg"><%= request.getAttribute("msg") == null ? "" : request.getAttribute("msg") %></p>
        <form action="register" method="post">
            <div class="form-row">
                <label for="username">用户名</label>
                <input type="text" id="username" name="username" maxlength="32" pattern=".{3,32}"
                       title="用户名 3~32 个字符" placeholder="用来登录（3~32 个字符）" required>
            </div>
            <div class="form-row">
                <label for="nickname">昵称</label>
                <input type="text" id="nickname" name="nickname" maxlength="32" placeholder="展示在商品和订单上" required>
            </div>
            <div class="form-row">
                <label for="phone">手机号</label>
                <input type="tel" id="phone" name="phone" maxlength="11" pattern="1[3-9][0-9]{9}"
                       title="请填写手机号" placeholder="11 位手机号" required>
            </div>
            <div class="form-row">
                <label for="password">密码</label>
                <input type="password" id="password" name="password" minlength="6" maxlength="64"
                       placeholder="至少 6 位" required>
            </div>
            <div class="form-row">
                <label for="confirmPassword">确认密码</label>
                <input type="password" id="confirmPassword" name="confirmPassword" maxlength="64" placeholder="再输一次密码" required>
            </div>
            <label class="agree-row">
                <input type="checkbox" name="agree" value="1" required>
                我已阅读并同意《用户协议》
            </label>
            <button class="register-btn" type="submit">注册</button>
        </form>
        <p class="tip">已有账号？<a href="login.jsp">去登录</a></p>
    </div>
</div>

<script>
    document.querySelector("form").addEventListener("submit", function (e) {
        var pwd = document.getElementById("password").value;
        var confirmPwd = document.getElementById("confirmPassword").value;
        if (pwd !== confirmPwd) {
            e.preventDefault();
            alert("两次输入的密码不一致");
        }
    });
</script>
</body>
</html>
