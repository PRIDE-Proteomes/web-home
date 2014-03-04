<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@attribute name="id" required="true"%>
<%@ attribute name="items" required="true" type="java.util.Map" %>
<%@ attribute name="name" required="true" %>
<select id="${id}" name="${name}" style="overflow:hidden; max-width:150px;">
    <option value="" selected>-Any-</option>
    <c:forEach var="theItem" items="${items}">
        <c:if test="${theItem.value > 0}">
            <option value="${theItem.key}">
                <c:choose>
                    <c:when test="${theItem.key == 9606}">Homo sapiens (Human)</c:when>
                    <c:when test="${theItem.key == 10090}">Mus musculus (Mouse)</c:when>
                    <c:when test="${theItem.key == 10116}">Rattus norvegicus (Rat)</c:when>
                    <c:when test="${theItem.key == 3702}">Arabidopsis thaliana (Mouse-ear cress)</c:when>
                </c:choose>
                (${theItem.value})
            </option>
        </c:if>
    </c:forEach>
</select>
