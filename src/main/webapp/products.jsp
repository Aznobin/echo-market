<%--
  Created by IntelliJ IDEA.
  User: miku
  Date: 2026/11/17
  Time: 20:36
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Echo Market - 二手商品首页</title>
</head>
<body>
<h1>欢迎来到 Echo Market 二手市场</h1>

<h2>🔥 正在热卖的商品列表</h2>

<!-- 使用 JSTL 的 c:forEach 循环遍历 Servlet 传过来的 products 列表 -->
<table border="1" cellpadding="10">
    <tr>
        <th>商品ID</th>
        <th>商品标题</th>
        <th>价格</th>
        <th>描述</th>
    </tr>

    <c:forEach items="${products}" var="p">
        <tr>
            <td>${p.id}</td>
            <td>${p.title}</td>
            <td style="color: red;">￥${p.price}</td>
            <td>${p.description}</td>
        </tr>
    </c:forEach>
</table>
</body>
</html>