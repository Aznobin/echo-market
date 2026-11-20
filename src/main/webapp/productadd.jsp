<%--
  Created by IntelliJ IDEA.
  User: miku
  Date: 2026/11/20
  Time: 10:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>发布闲置商品</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/productadd.css">
</head>
<body>
<div class="publish-container">
    <div class="publish-header">
        <h2>发布闲置商品</h2>
        <a class="back-link" href="${pageContext.request.contextPath}/products">返回商品列表</a>
    </div>

    <form action="${pageContext.request.contextPath}/product/add" method="post" enctype="multipart/form-data">
        <div class="form-group">
            <label>商品名称</label>
            <input class="form-control" type="text" name="title" required />
        </div>

        <div class="form-group">
            <label>价格</label>
            <input id="priceInput" class="form-control" type="number" step="0.01" min="0.01" max="999999.99" name="price" required />
        </div>

        <script>
            const priceInput = document.getElementById("priceInput");
            const minPrice = 0.01;
            const maxPrice = 999999.99;

            priceInput.addEventListener("keydown", function (e) {
                if (e.key === "-" || e.key === "+" || e.key === "e" || e.key === "E") {
                    e.preventDefault();
                }
            });

            priceInput.addEventListener("input", function () {
                let val = priceInput.value;
                if (val.includes(".")) {
                    const parts = val.split(".");
                    if (parts[1].length > 2) {
                        priceInput.value = parts[0] + "." + parts[1].slice(0, 2);
                    }
                }
            });

            function normalizePrice() {
                if (priceInput.value === "") return;
                let val = parseFloat(priceInput.value);
                if (isNaN(val) || val < minPrice) {
                    priceInput.value = minPrice.toFixed(2);
                } else if (val > maxPrice) {
                    priceInput.value = maxPrice.toFixed(2);
                }
            }

            priceInput.addEventListener("change", normalizePrice);
            priceInput.addEventListener("blur", normalizePrice);
        </script>

        <div class="form-group">
            <label>商品分类</label>
            <select class="form-select" name="categoryId">
                <option value="1">数码电子</option>
                <option value="2">图书教材</option>
                <option value="3">生活用品</option>
                <option value="4">服饰鞋包</option>
                <option value="5">美妆个护</option>
                <option value="6">运动户外</option>
                <option value="7">家电厨具</option>
                <option value="8">虚拟卡券</option>
                <option value="9">乐器潮玩</option>
                <option value="10">其他闲置</option>
            </select>
        </div>

        <div class="form-group">
            <label>选择商品图片</label>
            <input class="form-file" type="file" name="imageFile" accept="image/*" required />
        </div>

        <div class="form-group">
            <label>商品描述</label>
            <textarea class="form-textarea" name="description"></textarea>
        </div>

        <div class="form-actions">
            <button class="btn-submit" type="submit">确认发布</button>
            <a class="btn-cancel" href="${pageContext.request.contextPath}/products">取消</a>
        </div>
    </form>
</div>
</body>
</html>