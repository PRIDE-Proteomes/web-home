<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="customElement" tagdir="/WEB-INF/tags/elements" %>

<c:set var="peptiformFacets" value="${peptiformPage.content}"/>
<c:set var="size" value="${peptiformPage.size}"/>

<div id="search-result">
    <c:set var="numFilters" value="${fn:length(speciesFilters)}" />

    <%-- bread crumb & EBI global search --%>
    <div class="grid_24 clearfix">
        <div class="grid_18 alpha">
            <nav id="breadcrumb">
                <p>
                    <spring:url var="prideUrl" value="http://www.ebi.ac.uk/pride"/>
                    <spring:url var="proteomesUrl" value="/"/>
                    <a href="${prideUrl}">PRIDE</a> &gt; <a href="${proteomesUrl}">PRIDE Proteomes</a> &gt; Peptiforms
                </p>
            </nav>
        </div>

        <%-- EBI global search widget
             It will take it's search parameter from the query of the search header.
             We only need to show this for non-empty queries (e.g. there is a query term)
             and we should disable it if we apply and filters --%>
        <c:if test="${query!='' && numFilters<1}">
            <aside class="grid_6 omega shortcuts expander" id="search-extras">
                <div id="ebi_search_results">
                    <h3 class="slideToggle icon icon-functional" data-icon="u">Show more data from EMBL-EBI</h3>
                </div>
            </aside>
        </c:if>
    </div> <%--end of bread crumb a& EBI global search --%>


    <%-- Title and count --%>
    <div id="result-count" class="grid_18 alpha clearfix">
        <h3>
            <strong>${peptiformPage.totalElements}</strong> <fmt:message key="search.result.msg.part1"/>
            <c:if test="${query!=''}">
                <fmt:message key="search.result.msg.part2"/> <span class="searchterm" id="query">${query}</span>
            </c:if>
            <c:if test="${numFilters==1}"> (1 filter applied)</c:if>
            <c:if test="${numFilters>1}"> (${numFilters} filters applied)</c:if>
        </h3>
    </div>


    <%-- If we have no results we show a statement
         and we add an invisible div, which used by some JS to set a defined class for the global EBI search to use --%>
    <c:if test="${empty peptiformFacets}">
        <h4><fmt:message key="search.result.empty"/></h4>
        <div style="visibility: hidden" id="noresults"></div>
    </c:if>

    <%-- Data table, filters and controls --%>
    <section class="grid_24 clearfix">

        <%-- Filters --%>
        <div class="grid_4 left-column">
            <h4>Filter results</h4>
            <spring:url var="peptiformsUrl" value="/search"/>
            <%-- ADD filter form --%>
            <form action="${peptiformsUrl}" method="get">
                <fieldset class="no-padding">
                    <customElement:inputDefaultParams query="${query}"  pn="0" ps="${peptiformPage.size}" sort="${peptiformPage.sort}"/>

                    <%--active filters: used to keep a list of active filters and give it back to the server--%>
                    <customElement:inputHiddenList items="${speciesFilters}" name="speciesFilter"/>

                    <ul id="filter-options" class="no-padding list-style-none">
                        <li>
                            <label for="species-filter">Species</label>
                            <customElement:selectFilterSpecies id="species-filter" items="${availableSpeciesList}" name="speciesFilter"/>
                        </li>
                        <li>
                            <button type="submit">Add filter</button>
                        </li>
                    </ul>
                </fieldset>
            </form>

            <%-- show active filters & REMOVE filters forms --%>
            <c:if test="${numFilters>0}">
                <h4>Current active filters</h4>
                <%-- Remove all filters --%>
                <form action="${peptiformsUrl}" method="get">
                    <fieldset>
                        <customElement:inputDefaultParams query="${query}"  pn="0" ps="${peptiformPage.size}" sort="${peptiformPage.sort}"/>
                            <%-- E.g. submit again with the query term, but without any filters --%>
                        <button type="submit">Remove all</button>
                    </fieldset>
                </form>

                <%-- Selected Filters --%>
                <c:if test="${not empty speciesFilters}">
                    Species:
                    <c:forEach var="appliedSpeciesFilter" items="${speciesFilters}">
                        <form action="${peptiformsUrl}" method="get">
                            <fieldset>
                                <customElement:inputDefaultParams query="${query}" pn="0" ps="${peptiformPage.size}" sort="${peptiformPage.sort}"/>
                                <customElement:inputHiddenListExcluding items="${speciesFilters}" name="speciesFilter" excludeItem="${appliedSpeciesFilter}"/>
                                <c:choose>
                                    <%-- ToDo: this should happen dynamically (map taxid to species name) --%>
                                    <c:when test="${appliedSpeciesFilter == 9606}">Homo sapiens (Human)</c:when>
                                    <c:when test="${appliedSpeciesFilter == 10090}">Mus musculus (Mouse)</c:when>
                                    <c:when test="${appliedSpeciesFilter == 10116}">Rattus norvegicus (Rat)</c:when>
                                    <c:when test="${appliedSpeciesFilter == 3702}">Arabidopsis thaliana (Mouse-ear cress)</c:when>
                                </c:choose>
                                <button type="submit" class="remove-filter-button">
                                    x <%-- E.g submit again with the query term, but with the selected speciesFilter removed (other filters are kept) --%>
                                </button>

                            </fieldset>
                        </form>
                    </c:forEach>
                </c:if>

            </c:if> <%-- end of active/remove filters section --%>
        </div><%-- end of filters --%>


        <%-- List of peptiforms --%>
        <c:if test="${not empty peptiformFacets}">
            <%-- Table and controls --%>

            <div id="search-result-table" class="grid_20 omega">
                    <%-- Peptiform Table --%>
                <customElement:paginator page="${peptiformPage}" query="${query}" speciesFilters="${speciesFilters}"/>
                <table class="summary-table">
                        <%-- Headers --%>
                    <thead>
                        <%-- ToDo: implement sort --%>
                    <tr>
                        <%--<th>--%>
                            <%--Peptiform ID--%>
                        <%--</th>--%>
                        <th>
                            Sequence
                                <%--<spring:url var="showUrlRating"--%>
                                <%--value="/search?q=${q}&show=${show}&page=${page}&sort={sort}&order={order}&species=${species}&description=${description}&rating=${rating}">--%>
                                <%--<spring:param name="sort" value="peptiform_sequence" />--%>
                                <%--<spring:param name="order" value="${(sort=='peptiform_sequence') ? ((order=='asc')?'desc':'asc') : order}" />--%>
                                <%--</spring:url>--%>
                                <%--<a href="${showUrlRating}">Sequence</a>--%>
                        </th>
                        <th>
                            Modifications
                        </th>
                        <th>
                            Species
                        </th>
                        <th>
                            Protein(s)
                        </th>
                        <th>
                            UniProt Entry Groups(s)
                        </th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="peptiformFacet" items="${peptiformFacets}">
                        <tr>
                            <%--<td>--%>
                                    <%--${peptiform.id}--%>
                            <%--</td>--%>
                            <td>
                                    ${peptiformFacet.sequence}
                            </td>
                            <td>
                                <c:forEach var="modi" items="${peptiformFacet.mods}">
                                    ${modi}
                                </c:forEach>
                            </td>
                            <td>
                                    ${peptiformFacet.species}
                            </td>
                            <td>
                                <c:forEach var="protein" items="${peptiformFacet.proteins}">
                                    <spring:url var="showUrlPeptide" value="/viewer/#protein={protein_accession}&peptide={peptide_sequence}">
                                        <spring:param name="protein_accession" value="${protein}" />
                                        <spring:param name="peptide_sequence" value="${peptiformFacet.sequence}" />
                                    </spring:url>
                                    <a href="${showUrlPeptide}">${protein}</a>
                                </c:forEach>
                            </td>
                            <td>
                                <c:forEach var="upGroup" items="${peptiformFacet.upGroups}">
                                    <spring:url var="showUrlPeptide" value="/viewer/#group={group}">
                                        <spring:param name="group" value="${upGroup}" />
                                    </spring:url>
                                    <a href="${showUrlPeptide}">${upGroup}</a>
                                </c:forEach>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
                <customElement:paginator page="${peptiformPage}" query="${query}" speciesFilters="${speciesFilters}"/>

            </div><%-- end of result table --%>
        </c:if><%-- end of list of peptiforms --%>

    </section><%-- end of data table, filters and controls --%>


</div>
