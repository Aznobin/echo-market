<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="market" tagdir="/WEB-INF/tags/market" %>
<market:layout title="注册" stylesheet="/css/market/account.css">
    <div class="columns account-layout">
        <aside class="panel account-intro">
            <p>回响市集 · EchoMarket</p>
            <strong>把闲置留给<br>用得上的同学。</strong>
            <p class="muted">昵称是其他同学在市集里看到的名字。</p>
            <market:identity name="你的昵称"/>
        </aside>
        <section class="panel account-panel" aria-labelledby="account-title">
            <header class="page-head"><h1 id="account-title">创建账号</h1><p>填写下面的信息，开始逛市集。</p></header>
            <c:if test="${not empty msg}"><p class="notice" role="alert"><c:out value="${msg}"/></p></c:if>
            <form class="form" action="<c:url value='/register'/>" method="post" id="register-form">
                <div class="form-row">
                    <label class="field">用户名<input name="username" maxlength="32" pattern=".{3,32}" autocomplete="username" placeholder="3–32 个字符" required></label>
                    <label class="field">昵称<input name="nickname" maxlength="32" autocomplete="nickname" required></label>
                </div>
                <label class="field">手机号<input type="tel" name="phone" maxlength="11" pattern="1[3-9][0-9]{9}" autocomplete="tel-national" inputmode="tel" required></label>
                <div class="form-row">
                    <label class="field">密码<input type="password" name="password" minlength="6" maxlength="64" autocomplete="new-password" required><small>至少 6 个字符</small></label>
                    <label class="field">确认密码<input type="password" name="confirmPassword" maxlength="64" autocomplete="new-password" required></label>
                </div>
                <label class="account-agree"><input type="checkbox" name="agree" value="1" required> 我已阅读并同意《用户协议》</label>
                <button class="btn primary" type="submit">注册</button>
            </form>
            <p class="muted account-switch">已有账号？<a class="text-link" href="<c:url value='/login.jsp'/>">去登录</a></p>
        </section>
    </div>
    <script src="<c:url value='/js/market/register.js'/>"></script>
</market:layout>
