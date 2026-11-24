<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>Echo Market - 编辑商品</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/product/productadd.css">
</head>
<body>
<div class="publish-container">
    <div class="publish-header">
        <h2>编辑商品</h2>
        <a class="back-link" href="${pageContext.request.contextPath}/productdetail?id=${product.id}">返回商品详情</a>
    </div>

    <form action="${pageContext.request.contextPath}/product/manage" method="post">
        <input type="hidden" name="id" value="${product.id}">

        <div class="form-group">
            <label>商品名称</label>
            <input class="form-control" type="text" name="title" maxlength="100" value="${product.title}" required>
        </div>

        <div class="form-group">
            <label>价格</label>
            <input class="form-control" type="number" step="0.01" min="0.01" max="999999.99"
                   name="price" value="${product.price}" required>
        </div>

        <div class="form-group">
            <label>商品分类</label>
            <input class="form-control" type="number" min="1" name="categoryId" value="${product.categoryId}" required>
        </div>

        <div class="form-group">
            <label>商品描述</label>
            <textarea class="form-textarea" name="description">${product.description}</textarea>
        </div>

        <div class="form-actions">
            <button class="btn-submit" type="submit">保存修改</button>
            <a class="btn-cancel" href="${pageContext.request.contextPath}/products">取消</a>
        </div>
    </form>

    <form action="${pageContext.request.contextPath}/product/manage" method="post"
          onsubmit="return confirm('确定下架这件商品吗？');">
        <input type="hidden" name="id" value="${product.id}">
        <input type="hidden" name="action" value="remove">
        <button class="btn-cancel" type="submit">下架商品</button>
    </form>
</div>
</body>
</html>
