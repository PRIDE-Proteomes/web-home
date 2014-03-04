<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="customElement" tagdir="/WEB-INF/tags/elements" %>


<div id="search-result">

<%-- bread crumb & EBI global search --%>
<div class="grid_24 clearfix">
    <div class="grid_18 alpha">
    <nav id="breadcrumb">
        <p>
            <spring:url var="prideUrl" value="http://www.ebi.ac.uk/pride"/>
            <spring:url var="proteomesUrl" value="/"/>
            <a href="${prideUrl}">PRIDE</a> &gt; <a href="${proteomesUrl}">PRIDE Proteomes</a> &gt; Search
        </p>
    </nav>
    </div>
    <c:set var="numFilters" value="${fn:length(speciesFilters)}" />

    <%-- Add the global EBI search widget --%>
    <%-- This will take it's search parameter from the query of the search header, e.g. the query field q --%>
    <c:if test="${q!='' && numFilters<1}">
        <aside class="grid_6 omega shortcuts expander" id="search-extras">
            <div id="ebi_search_results">
                <h3 class="slideToggle icon icon-functional" data-icon="u">Show more data from EMBL-EBI</h3>
            </div>
        </aside>
    </c:if>
</div>


<%-- Title and count --%>
<div id="result-count" class="grid_18 alpha clearfix">
    <c:set var="numFilters" value="${fn:length(speciesFilters)}" />
    <h2>
        <strong>${numResults}</strong> <fmt:message key="search.result.title"/>
        <c:if test="${q!=''}">
            <fmt:message key="search.result.forterm"/> <span class="searchterm" id="query">${q}</span>
        </c:if>
        <c:if test="${numFilters>0}">+ ${numFilters} filters</c:if>
    </h2>
</div>


<%-- No results to show --%>
<%-- we add an invisible div in case no results are returned. this is used by some JS to set a defined class for the global EBI search to use --%>
<c:if test="${empty proteinList}">
    <h4><fmt:message key="search.result.empty"/></h4>
    <div style="visibility: hidden" id="noresults"></div>
</c:if>

<%-- List of proteins --%>
<c:if test="${not empty proteinList}">

<%-- Data table, filters and controls --%>
<section class="grid_24 clearfix">

<%-- Filters --%>
<div class="grid_6 left-column">
    <h4>Filter your results</h4>
    <spring:url var="searchUrl" value="/search"/>
    <%-- ADD filter form --%>
    <form action="${searchUrl}" method="get">
        <fieldset class="no-padding">
            <input type='hidden' name='q' value='${q}'/>
            <input type='hidden' name='show' value='${show}'/>
            <input type='hidden' name='page' value='${page}'/>
            <input type='hidden' name='sort' value='${sort}'/>
            <input type='hidden' name='order' value='${order}'/>

            <%--active filters: used to keep a list of active filters and give it back to the server--%>
            <customElement:inputHiddenList items="${speciesFilters}" name="speciesFilters"/>

            <ul id="filter-options" class="no-padding list-style-none">
                <li>
                    <label for="species-filter">Species</label>
                    <customElement:selectFilterSpecies id="species-filter" items="${availableSpeciesList}" name="newSpeciesFilter"/>
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
        <%-- Remove all --%>
        <form action="${searchUrl}" method="get">
            <fieldset>
                <input type='hidden' name='q' value='${q}'/>
                <input type='hidden' name='show' value='${show}'/>
                <input type='hidden' name='page' value='${page}'/>
                <input type='hidden' name='sort' value='${sort}'/>
                <input type='hidden' name='order' value='${order}'/>
                <button type="submit">
                    Remove all
                    <%-- E.g. submit again with the query term, but without any filters --%>
                </button>
            </fieldset>
        </form>

        <%-- Selected Filters --%>

        <%-- Species filters --%>
        <c:if test="${not empty speciesFilters}">
            Species:
            <c:forEach var="theSpeciesFilter" items="${speciesFilters}">
                <form action="${searchUrl}" method="get">
                <fieldset>
                    <input type='hidden' name='q' value='${q}'/>
                    <input type='hidden' name='show' value='${show}'/>
                    <input type='hidden' name='page' value='${page}'/>
                    <input type='hidden' name='sort' value='${sort}'/>
                    <input type='hidden' name='order' value='${order}'/>
                    <%-- remove the selected 'theSpeciesFilter' from the speciesFilters --%>
                    <customElement:inputHiddenListExcluding items="${speciesFilters}" name="speciesFilters" excludeItem="${theSpeciesFilter}"/>
                    <c:choose>
                        <c:when test="${theSpeciesFilter == 9606}">Homo sapiens (Human)</c:when>
                        <c:when test="${theSpeciesFilter == 10090}">Mus musculus (Mouse)</c:when>
                        <c:when test="${theSpeciesFilter == 10116}">Rattus norvegicus (Rat)</c:when>
                        <c:when test="${theSpeciesFilter == 3702}">Arabidopsis thaliana (Mouse-ear cress)</c:when>
                    </c:choose>
                    <button type="submit" class="remove-filter-button">
                        x
                        <%-- E.g submit again with the query term, but with the selected speciesFilter removed (other filters are kept) --%>
                    </button>

                </fieldset>
                </form>
            </c:forEach>
        </c:if>


    </c:if> <%-- end of active/remove filters section --%>
</div><%-- end of filters --%>


<%-- Table and controls --%>
<div id="search-result-table" class="grid_18 omega">
    <%-- Protein Table --%>
    <table class="summary-table">
        <%-- Headers --%>
        <thead>
        <%-- ToDo: implement sort --%>
            <tr>
                <%-- Accession --%>
                <th>
                    <%--<spring:url var="showUrlAccession"--%>
                                <%--value="/search?q=${q}&show=${show}&page=${page}&sort={sort}&order={order}&species=${species}&description=${description}&rating=${rating}">--%>
                        <%--<spring:param name="sort" value="protein_accession" />--%>
                        <%--<spring:param name="order" value="${(sort == 'protein_accession') ? ((order=='asc')?'desc':'asc') : order}" />--%>
                    <%--</spring:url>--%>
                    <%--<a href="${showUrlAccession}">Accession</a>--%>
                    Protein Accession
                </th>
                <%-- Description --%>
                <th>
                    <%--<spring:url var="showUrlDescription"--%>
                                <%--value="/search?q=${q}&show=${show}&page=${page}&sort={sort}&order={order}&species=${species}&description=${description}&rating=${rating}">--%>
                        <%--<spring:param name="sort" value="protein_description" />--%>
                        <%--<spring:param name="order" value="${(sort=='protein_description') ? ((order=='asc')?'desc':'asc') : order}" />--%>
                    <%--</spring:url>--%>
                    <%--<a href="${showUrlDescription}">Description</a>--%>
                    Description
                </th>
                <%-- Species --%>
                <th>
                    <%--<spring:url var="showUrlSpecies"--%>
                                <%--value="/search?q=${q}&show=${show}&page=${page}&sort={sort}&order={order}&species=${species}&description=${description}&rating=${rating}">--%>
                        <%--<spring:param name="sort" value="protein_species" />--%>
                        <%--<spring:param name="order" value="${(sort=='protein_species_name') ? ((order=='asc')?'desc':'asc') : order}" />--%>
                    <%--</spring:url>--%>
                    <%--<a href="${showUrlSpecies}">Species</a>--%>
                    Species
                </th>
                <%-- Rating --%>
                <th>
                    <%--<spring:url var="showUrlRating"--%>
                                <%--value="/search?q=${q}&show=${show}&page=${page}&sort={sort}&order={order}&species=${species}&description=${description}&rating=${rating}">--%>
                        <%--<spring:param name="sort" value="protein_rating" />--%>
                        <%--<spring:param name="order" value="${(sort=='protein_rating') ? ((order=='asc')?'desc':'asc') : order}" />--%>
                    <%--</spring:url>--%>
                    <%--<a href="${showUrlRating}">Rating</a>--%>
                    Rating
                </th>
            </tr>
        </thead>
        <%-- Proteins --%>
        <tbody>
            <c:forEach var="protein" items="${proteinList}">
                <tr>
                    <%-- Protein accession --%>
                    <td>
                        <%-- preformat the URL to link to the Proteomes Viewer --%>
                        <spring:url var="showUrlProteinAccession" value="/viewer/#protein={protein_accession}">
                            <spring:param name="protein_accession" value="${protein.accession}" />
                        </spring:url>
                        <a href="${showUrlProteinAccession}">${protein.accession}</a>
                    </td>
                    <%-- protein description --%>
                    <td>
                        ${protein.description}
                    </td>
                    <%-- protein species --%>
                    <td>
                        ${protein.speciesName}
                    </td>
                    <%-- protein rating --%>
                    <td>
                        ${protein.rating}
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>


    <!-- paging buttons -->
    <div class="grid_24">
        <c:if test="${numPages>1}">
            <div id="paging-buttons" class="grid_12 alpha">
                <ul class="search-menu">
                        <%--First --%>
                    <li><customElement:hrefSearch
                            label="1"
                            q="${q}"
                            show="${show}"
                            page="1"
                            sort="${sort}"
                            order="${order}"
                            speciesFilters="${speciesFilters}"
                            hrefClass="${page==1?'selected':''}"
                            />
                    </li>
                    <c:if test="${page>4}"><li>...</li></c:if>

                        <%--In between pages--%>
                    <c:forEach var="nPage" begin="${(page<5) ? 2 : (page-2)}" end="${(page>(numPages-4)) ? numPages-1 : (page+2)}">
                        <li><customElement:hrefSearch
                                label="${nPage}"
                                q="${q}"
                                show="${show}"
                                page="${nPage}"
                                sort="${sort}"
                                order="${order}"
                                speciesFilters="${speciesFilters}"
                                hrefClass="${page==nPage?'selected':''}"
                                />
                        </li>
                    </c:forEach>
                        <%-- Last   --%>
                    <c:if test="${page<(numPages-4)}"><li>...</li></c:if>
                    <li><customElement:hrefSearch
                            label="${numPages}"
                            q="${q}"
                            show="${show}"
                            page="${numPages}"
                            sort="${sort}"
                            order="${order}"
                            speciesFilters="${speciesFilters}"
                            hrefClass="${page==numPages?'selected':''}"
                            />
                    </li>

                </ul>
            </div>
        </c:if>

        <!-- Show entries controls -->
        <c:choose>
            <c:when test="${numPages>1}">
                <c:set var="show_entries_class" value="grid_12 omega"/>
            </c:when>
            <c:otherwise>
                <c:set var="show_entries_class" value="grid_23 omega"/>
            </c:otherwise>
        </c:choose>
        <div id="show-entries" class="${show_entries_class}">
            <ul class="search-menu-right-align">
                <c:if test="${numResults>10}">
                    <li><fmt:message key="search.show.entries"/></li>
                    <li><customElement:hrefSearch
                            label="10"
                            q="${q}"
                            show="10"
                            page="${page}"
                            sort="${sort}"
                            order="${order}"
                            speciesFilters="${speciesFilters}"
                            hrefClass="${show==10?'selected':''}"
                            /></li>

                    <li><customElement:hrefSearch
                            label="20"
                            q="${q}"
                            show="20"
                            page="${page}"
                            sort="${sort}"
                            order="${order}"
                            speciesFilters="${speciesFilters}"
                            hrefClass="${show==20?'selected':''}"
                            /></li>

                    <%-- if we have more than 20 results, show options to increase the results per page --%>
                    <c:if test="${numResults>20}">
                        <li><customElement:hrefSearch
                                label="50"
                                q="${q}"
                                show="50"
                                page="${page}"
                                sort="${sort}"
                                order="${order}"
                                speciesFilters="${speciesFilters}"
                                hrefClass="${show==50?'selected':''}"
                                /></li>

                        <c:if test="${numResults>50}">
                            <li><customElement:hrefSearch
                                    label="100"
                                    q="${q}"
                                    show="100"
                                    page="${page}"
                                    sort="${sort}"
                                    order="${order}"
                                    speciesFilters="${speciesFilters}"
                                    hrefClass="${show==100?'selected':''}"
                                    /></li>
                        </c:if> <!--50-->
                    </c:if> <!--20-->
                </c:if> <!--10-->
            </ul>
        </div>
    </div>

</div><%-- end of result table --%>
</section><%-- end of data table, filters and controls --%>

</c:if><%-- end of if proteinList not empty --%>

</div>
