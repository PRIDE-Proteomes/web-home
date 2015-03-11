<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ attribute name="query" required="true" type="java.lang.String"%><%-- query term --%>
<%@ attribute name="ps" required="true" type="java.lang.Integer"%><%-- page size --%>
<%@ attribute name="pn" required="true" type="java.lang.Integer"%><%-- page number --%>
<%@ attribute name="sort" required="true" type="org.springframework.data.domain.Sort"%><%-- page parameters --%>

<%-- we only add parameters if they differ from the defaults --%>
<c:if test="${query != ''}">
    <input type='hidden' name='query' value='${query}'/>
</c:if>
<c:if test="${pn != 0}">
    <input type='hidden' name='page' value='${pn}'/>
</c:if>
<c:if test="${ps != 10}">
    <input type='hidden' name='size' value='${ps}'/>
</c:if>
<%-- ToDo: handle sorting parameter(s): split and add appropriately --%>
<c:if test="${sort != null && sort != ''}">
    <input type='hidden' name='sort' value='${sort}'/>
</c:if>
