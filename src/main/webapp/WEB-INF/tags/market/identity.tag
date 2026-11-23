<%@ tag pageEncoding="UTF-8" body-content="empty" %>
<%@ attribute name="name" required="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<span class="identity">
    <%-- This slot can render a validated avatar image once uploads are supported. --%>
    <span class="avatar" aria-hidden="true">User</span>
    <span class="identity-name"><c:out value="${name}"/></span>
</span>
