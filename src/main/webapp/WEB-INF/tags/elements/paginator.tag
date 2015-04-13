<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="customElement" tagdir="/WEB-INF/tags/elements"%>

<%@ attribute name="baseUrl" required="false" type="java.lang.String" %> <%-- base URL to use if not the search --%>
<%@ attribute name="page" required="true" type="org.springframework.data.domain.Page" %>
<%@ attribute name="query" required="false" type="java.lang.String" %>
<%@ attribute name="speciesFilters" required="false" type="java.util.Collection" %>

<%-- Pagination Bar--%>
<div class="grid_24">
    <div class="col_pager">
        <div class="pr-pager">
            <%-- 1 based page number to be displayed on web page --%>
            <c:set var="myPage" value="${page.number + 1}"/>

            <c:if test="${page.totalElements gt 0}">
                <c:if test="${page.totalPages gt 1}">
                    <fmt:message key="search.page"/>
                    <c:choose>
                        <c:when test="${0 eq page.number}">
                            <span>1</span>
                        </c:when>
                        <c:otherwise>
                            <customElement:hrefSearch baseUrl="${baseUrl}" label="1" qt="${query}" ps="${page.size}" pn="${0}" so="${page.sort}" speciesFilter="${speciesFilters}"/>
                        </c:otherwise>
                    </c:choose>
                </c:if>
                <c:if test="${myPage gt 4 and page.totalPages gt 5 }">...</c:if>

                <c:if test="${myPage le 5 and page.totalPages le 5}">
                    <c:set var="start" value="2" />
                    <c:set var="stop" value="${page.totalPages-1}" />
                </c:if>

                <c:if test="${myPage le 4 and page.totalPages gt 5}">
                    <c:set var="start" value="2" />
                    <c:set var="stop" value="5" />
                </c:if>

                <c:if test="${myPage gt 4 and page.totalPages gt 5}">
                    <c:set var="start" value="${myPage+2 gt page.totalPages-2 ? page.totalPages-4 : myPage-2}" />
                    <c:set var="stop" value="${myPage+2 gt page.totalPages-2 ? page.totalPages-1 : myPage+2}" />
                </c:if>

                <c:if test="${page.totalPages gt 2}">
                    <c:forEach var="nPage" begin="${start}" end="${stop}">
                        <c:choose>
                            <c:when test="${nPage-1 eq page.number}">
                                <span>${nPage}</span>
                            </c:when>
                            <c:otherwise>
                                <customElement:hrefSearch baseUrl="${baseUrl}" label="${nPage}" qt="${query}" ps="${page.size}" pn="${nPage-1}" so="${page.sort}" speciesFilter="${speciesFilters}"/>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </c:if>

                <c:if test="${page.totalPages gt 5 and myPage le page.totalPages-4}">...</c:if>

                <c:if test="${page.totalPages gt 1}">
                    <c:choose>
                        <c:when test="${page.totalPages-1 eq page.number}">
                            <span>${page.totalPages}</span>
                        </c:when>
                        <c:otherwise>
                            <customElement:hrefSearch baseUrl="${baseUrl}" label="${page.totalPages}" qt="${query}" ps="${page.size}" pn="${page.totalPages-1}" so="${page.sort}" speciesFilter="${speciesFilters}"/>
                        </c:otherwise>
                    </c:choose>

                </c:if>
            </c:if>
        </div>

        <div class="pr-page-size">
            <c:if test="${page.totalElements gt 10}">
                <fmt:message key="search.show.entries"/>
                <c:choose>
                    <c:when test="${page.size eq  10}">
                        <span>10</span>
                    </c:when>
                    <c:otherwise>
                        <customElement:hrefSearch baseUrl="${baseUrl}" label="10" qt="${query}" ps="10" pn="0" so="${page.sort}" speciesFilter="${speciesFilters}"/>
                    </c:otherwise>
                </c:choose>
            </c:if>

            <c:if test="${page.totalElements ge 20}">
                <c:choose>
                    <c:when test="${page.size eq  20}">
                        <span>20</span>
                    </c:when>
                    <c:otherwise>
                        <customElement:hrefSearch baseUrl="${baseUrl}" label="20" qt="${query}" ps="20" pn="0" so="${page.sort}" speciesFilter="${speciesFilters}"/>
                    </c:otherwise>
                </c:choose>
            </c:if>

            <c:if test="${page.totalElements ge 50}">
                <c:choose>
                    <c:when test="${page.size eq  50}">
                        <span>50</span>
                    </c:when>
                    <c:otherwise>
                        <customElement:hrefSearch baseUrl="${baseUrl}" label="50" qt="${query}" ps="50" pn="0" so="${page.sort}" speciesFilter="${speciesFilters}"/>
                    </c:otherwise>
                </c:choose>
            </c:if>

            <c:if test="${page.totalElements ge 100}">
                <c:choose>
                    <c:when test="${page.size eq  100}">
                        <span>100</span>
                    </c:when>
                    <c:otherwise>
                        <customElement:hrefSearch baseUrl="${baseUrl}" label="100" qt="${query}" ps="100" pn="" so="${page.sort}" speciesFilter="${speciesFilters}"/>
                    </c:otherwise>
                </c:choose>
            </c:if>
        </div>

        <div class="pr-stats">
            <fmt:message key="search.page.showing.start"/>
            <span>${page.size * page.number + 1} - ${page.size * page.number + page.numberOfElements}</span>
            <fmt:message key="search.page.showing.middle"/>
            <span>${page.totalElements}</span>
            <fmt:message key="search.page.showing.end"/>
        </div>
    </div>
</div>
