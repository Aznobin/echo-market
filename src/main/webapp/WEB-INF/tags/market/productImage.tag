<%@ tag pageEncoding="UTF-8" body-content="empty" %>
<%@ attribute name="image" required="true" %>
<%@ attribute name="alt" required="true" %>
<%@ attribute name="loading" required="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:if test="${not empty image}">
    <c:url var="photo" value="/images/${image}"/>
    <img src="${fn:escapeXml(photo)}" alt="${fn:escapeXml(alt)}" loading="${loading eq 'lazy' ? 'lazy' : 'eager'}" decoding="async">
</c:if>
<span class="photo-empty" ${not empty image ? 'hidden' : ''}>暂无图片</span>
