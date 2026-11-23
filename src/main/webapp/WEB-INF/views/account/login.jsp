<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="market" tagdir="/WEB-INF/tags/market" %>
<market:layout title="登录" stylesheet="/css/market/account.css">
    <div class="columns account-layout">
        <aside class="panel account-intro">
            <p>回响市集 · EchoMarket</p>
            <strong>校园里的闲置，<br>在这里继续流转。</strong>
            <p class="muted">登录后可以联系卖家、收藏好物和查看订单。</p>
        </aside>
        <section class="panel account-panel" aria-labelledby="account-title">
            <header class="page-head"><h1 id="account-title">欢迎回来</h1><p>用你的市集账号登录。</p></header>
            <c:if test="${not empty msg}"><p class="notice" role="alert"><c:out value="${msg}"/></p></c:if>
            <form class="form" action="<c:url value='/login'/>" method="post">
                <label class="field">用户名<input name="username" autocomplete="username" required></label>
                <label class="field">密码<input type="password" name="password" autocomplete="current-password" required></label>
                <button class="btn primary" type="submit">登录</button>
            </form>
            <p class="muted account-switch">还没有账号？<a class="text-link" href="<c:url value='/register.jsp'/>">去注册</a></p>
        </section>
    </div>
</market:layout>
