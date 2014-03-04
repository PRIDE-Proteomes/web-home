<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ attribute name="label" required="true" %>
<%@ attribute name="q" required="true" %>
<%@ attribute name="show" required="true" %>
<%@ attribute name="page" required="true" %>
<%@ attribute name="sort" required="true" %>
<%@ attribute name="order" required="true" %>
<%@ attribute name="speciesFilters" required="true" type="java.util.Collection" %>
<%--<%@ attribute name="tissueFilters" required="true" type="java.util.Collection" %>--%>
<%@ attribute name="hrefClass" required="false" %>
<spring:url var="showUrl" value="/search">
    <spring:param name="q" value="${q}" />
    <spring:param name="show" value="${show}" />
    <spring:param name="page" value="${page}" />
    <spring:param name="sort" value="${sort}" />
    <spring:param name="order" value="${order}" />
    <c:forEach var="theFilter" items="${speciesFilters}">
        <spring:param name="speciesFilters" value="${theFilter}"/>
    </c:forEach>
    <%--<c:forEach var="theFilter" items="${tissueFilters}">--%>
        <%--<spring:param name="tissueFilters" value="${theFilter}"/>--%>
    <%--</c:forEach>--%>
</spring:url>
<a href="${showUrl}" class="${hrefClass}">${label}</a>