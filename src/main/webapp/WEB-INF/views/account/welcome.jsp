<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="market" tagdir="/WEB-INF/tags/market" %>
<market:layout title="欢迎" stylesheet="/css/market/account.css">
    <section class="panel welcome-panel">
        <header class="page-head"><h1>欢迎来到回响市集</h1><p>校园里有好物等你发现。</p></header>
        <market:identity name="${empty sessionScope.user.nickname ? sessionScope.user.username : sessionScope.user.nickname}"/>
        <p class="muted">注册时间：<c:out value="${sessionScope.user.createTime}"/></p>
        <div class="actions"><a class="btn primary" href="<c:url value='/products'/>">进入商品集市</a></div>
    </section>
</market:layout>
