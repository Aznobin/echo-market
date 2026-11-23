<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="market" tagdir="/WEB-INF/tags/market" %>
<market:layout title="发布闲置" stylesheet="/css/market/products.css">
    <a class="text-link crumb" href="<c:url value='/products'/>">← 返回商品列表</a>
    <header class="page-head"><h1>发布闲置</h1><p>拍一张清楚的照片，描述物品成色和交易方式。</p></header>
    <c:if test="${not empty msg}"><p class="notice publish-notice" role="alert"><c:out value="${msg}"/></p></c:if>
    <form class="columns publish-layout" action="<c:url value='/product/add'/>" method="post" enctype="multipart/form-data">
        <section class="panel form" aria-label="商品信息">
            <label class="field">商品名称<input name="title" maxlength="100" required></label>
            <div class="form-row">
                <label class="field">价格（元）<input type="number" inputmode="decimal" name="price" step="0.01" min="0.01" max="999999.99" required></label>
                <label class="field">商品分类<select name="categoryId" required>
                    <c:forEach items="${categories}" var="category"><option value="${category.id}"><c:out value="${category.name}"/></option></c:forEach>
                </select></label>
            </div>
            <label class="field">商品描述<textarea name="description" rows="5" placeholder="使用情况、配件、适合在哪里交接"></textarea></label>
            <div class="actions"><button class="btn primary" type="submit">确认发布</button><a class="btn" href="<c:url value='/products'/>">取消</a></div>
        </section>
        <section class="panel form" aria-label="商品照片">
            <label class="field">商品照片<input type="file" name="imageFile" id="product-photo" accept="image/*" required></label>
            <figure class="upload-preview"><img id="photo-preview" alt="待发布商品的照片" hidden><span id="photo-hint" class="muted">选择照片后可查看预览</span></figure>
        </section>
    </form>
    <script src="<c:url value='/js/market/product-media.js'/>"></script>
</market:layout>
