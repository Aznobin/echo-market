<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>Echo Market - 二手商品首页</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/products.css">
</head>

<body>
<header class="navbar">
    <a href="${pageContext.request.contextPath}/products" class="brand">Echo Market 二手集市</a>
    <div style="display: flex; align-items: center; gap: 12px;">
        <a href="${pageContext.request.contextPath}/productaddpage" class="btn btn-primary">+ 发布闲置商品</a>
        <a href="${pageContext.request.contextPath}/products">浏览商品</a>
        <a href="${pageContext.request.contextPath}/myorders">我买到的</a>
        <a href="${pageContext.request.contextPath}/soldorders">我卖出的</a>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">退出登录</a>
    </div>
</header>

<main class="container">
    <div class="page-header">
        <h2>🔥 正在热卖的商品列表</h2>
    </div>

    <div class="card">
        <table class="product-table">
            <thead>
            <tr>
                <th width="70">商品ID</th>
                <th width="90">商品图片</th>
                <th>商品标题</th>
                <th width="120">价格</th>
                <th>描述</th>
                <th width="110">商品状态</th>
            </tr>
            </thead>

            <tbody>
            <c:forEach items="${products}" var="p">
                <tr class="product-row" data-href="${pageContext.request.contextPath}/productdetail?id=${p.id}">
                    <td>#${p.id}</td>

                    <td>
                        <c:choose>
                            <c:when test="${not empty p.image}">
                                <img src="${pageContext.request.contextPath}/images/${p.image}" alt="商品图片" class="product-img" />
                            </c:when>
                            <c:otherwise>
                                <div class="no-img">暂无图片</div>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td>
                        <div class="product-title">${p.title}</div>
                    </td>

                    <td>
                        <span class="price">¥ ${p.price}</span>
                    </td>

                    <td>
                        <div class="product-desc" title="${p.description}">${p.description}</div>
                    </td>

                    <td>
                        <c:choose>
                            <c:when test="${p.status == 0}">
                                <span class="badge badge-sale">待售</span>
                            </c:when>
                            <c:when test="${p.status == 1}">
                                <span class="badge badge-sold">已售</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-off">未知</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
            </tbody>


            <script>
                document.querySelectorAll('.product-row[data-href]').forEach(function (row) {
                    row.addEventListener('click', function (e) {
                        if (e.target.closest('a, button, input, select, textarea')) {
                            return;
                        }
                        var href = row.getAttribute('data-href');
                        if (href) {
                            window.location.href = href;
                        }
                    });
                });
            </script>



        </table>
    </div>
</main>

</body>
</html>