<%@ tag pageEncoding="UTF-8" body-content="scriptless" %>
<%@ attribute name="id" required="true" %>
<%@ attribute name="name" required="true" %>
<%@ attribute name="image" required="true" %>
<%@ attribute name="price" required="true" type="java.math.BigDecimal" %>
<%@ attribute name="label" required="true" %>
<%@ attribute name="seller" required="false" %>
<%@ attribute name="loading" required="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="market" tagdir="/WEB-INF/tags/market" %>
<c:url var="detail" value="/productdetail"><c:param name="id" value="${id}"/></c:url>
<article class="product-card" data-testid="product-card">
    <a class="product-media" href="${detail}" tabindex="-1" aria-hidden="true"><market:productImage image="${image}" alt="" loading="${loading}"/></a>
    <div class="card-copy">
        <div class="card-top"><span class="tag"><c:out value="${label}"/></span><span class="price"><small>¥</small> <fmt:formatNumber value="${price}" pattern="#,##0.00"/></span></div>
        <h3><a href="${detail}"><c:out value="${name}"/></a></h3>
        <div class="card-bottom">
            <c:if test="${not empty seller}"><market:identity name="${seller}"/></c:if>
            <jsp:doBody/>
        </div>
    </div>
</article>
