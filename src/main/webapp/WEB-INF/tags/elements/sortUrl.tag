<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%@ attribute name="baseUrl" required="false" type="java.lang.String" %> <%-- base URL to use if not /search --%>
<%@ attribute name="label" required="true" type="java.lang.String"%><%-- link label --%>
<%@ attribute name="ps" required="true" type="java.lang.Integer"%><%-- page size --%>
<%@ attribute name="pn" required="true" type="java.lang.Integer"%><%-- page number --%>
<%@ attribute name="so" required="true" type="java.lang.String"%><%-- sort parameters --%>
<%@ attribute name="speciesFilter" required="true" type="java.util.Collection" %>
<%@ attribute name="hrefClass" required="false" %>


<%-- we only want to add parameters if they are sensible and differ from the defaults --%>

<c:choose>
    <c:when test="${empty baseUrl}">
        <c:set var="url" value="/search"/>
    </c:when>
    <c:otherwise>
        <c:set var="url" value="${baseUrl}"/>
    </c:otherwise>
</c:choose>
<spring:url var="showUrl" value="${url}">
    <c:if test="${ps != 10}">
        <spring:param name='size' value='${ps}'/>
    </c:if>
    <c:if test="${pn != 0}">
        <spring:param name='page' value='${pn}'/>
    </c:if>
    <c:if test="${not empty so}">
        <spring:param name='sort' value='${so}'/>
    </c:if>
    <c:forEach var="appliedFilter" items="${speciesFilter}">
        <spring:param name="speciesFilter" value="${appliedFilter}"/>
    </c:forEach>
</spring:url>
<a href="${showUrl}" class="${hrefClass}">${label}</a>


