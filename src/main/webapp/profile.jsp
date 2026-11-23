<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>Echo Market - 个人资料</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/account/profile.css">
</head>
<body>
<div class="profile-wrap">
    <aside class="profile-aside">
        <div class="avatar">
            <c:choose>
                <c:when test="${not empty user.avatar}">
                    <img src="${pageContext.request.contextPath}/images/${user.avatar}" alt="头像">
                </c:when>
                <c:otherwise>User</c:otherwise>
            </c:choose>
        </div>
        <h1><c:out value="${user.nickname}"/></h1>
        <p class="muted">@${user.username}</p>
        <a class="back" href="${pageContext.request.contextPath}/products">返回商品列表</a>
    </aside>

    <section class="profile-card">
        <h2>修改个人资料</h2>
        <c:if test="${param.ok == '1'}"><p class="ok">资料已保存</p></c:if>

        <form action="${pageContext.request.contextPath}/profile" method="post" enctype="multipart/form-data">
            <label for="nickname">昵称</label>
            <input id="nickname" name="nickname" maxlength="32" value="${user.nickname}" required>

            <label for="phone">手机号</label>
            <input id="phone" name="phone" maxlength="11" value="${user.phone}" required>

            <label for="password">新密码<span class="hint">（留空则不修改）</span></label>
            <input id="password" type="password" name="password" minlength="6" maxlength="64" placeholder="至少 6 位">

            <label for="avatar">头像<span class="hint">（PNG / JPG / GIF / WebP）</span></label>
            <input id="avatar" type="file" name="avatar" accept="image/png,image/jpeg,image/gif,image/webp">

            <button type="submit">保存修改</button>
        </form>
    </section>
</div>
</body>
</html>
