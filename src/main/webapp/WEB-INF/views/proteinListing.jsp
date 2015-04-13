<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="customElement" tagdir="/WEB-INF/tags/elements" %>

<c:set var="proteinFacets" value="${facetPage.content}"/>
<c:set var="size" value="${facetPage.size}"/>

<div id="protein-list">
  <c:set var="numFilters" value="${fn:length(speciesFilters)}" />

  <%-- bread crumb & EBI global search --%>
  <div class="grid_24 clearfix">
    <nav id="breadcrumb">
      <p>
        <spring:url var="prideUrl" value="http://www.ebi.ac.uk/pride"/>
        <spring:url var="proteomesUrl" value="/"/>
        <a href="${prideUrl}">PRIDE</a> &gt; <a href="${proteomesUrl}">PRIDE Proteomes</a> &gt; Proteins
      </p>
    </nav>
  </div> <%--end of bread crumb a& EBI global search --%>


  <%-- Title and count --%>
  <div id="result-count" class="grid_18 alpha clearfix">
    <h3>
      <strong>${facetPage.totalElements}</strong>
      <fmt:message key="proteins.page.results.header"/>
      <c:if test="${numFilters==1}"> (1 filter applied)</c:if>
      <c:if test="${numFilters>1}"> (${numFilters} filters applied)</c:if>
    </h3>
  </div>


  <%-- If we have no results we show a statement
       and we add an invisible div, which used by some JS to set a defined class for the global EBI search to use --%>
  <c:if test="${empty proteinFacets}">
    <h4><fmt:message key="search.result.empty"/></h4>
    <div style="visibility: hidden" id="noresults"></div>
  </c:if>

  <%-- Data table, filters and controls --%>
  <section class="grid_24 clearfix">

    <%-- Filters --%>
    <div class="grid_4 left-column">
      <h4>Filter results</h4>
      <spring:url var="proteinsUrl" value="/proteins"/>
      <%-- ADD filter form --%>
      <form action="${proteinsUrl}" method="get">
        <fieldset class="no-padding">
          <customElement:inputDefaultParams query=""  pn="0" ps="${facetPage.size}" sort="${facetPage.sort}"/>

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
        <form action="${proteinsUrl}" method="get">
          <fieldset>
            <customElement:inputDefaultParams query=""  pn="0" ps="${facetPage.size}" sort="${facetPage.sort}"/>
              <%-- E.g. submit again with the query term, but without any filters --%>
            <button type="submit">Remove all</button>
          </fieldset>
        </form>

        <%-- Selected Filters --%>
        <c:if test="${not empty speciesFilters}">
          Species:
          <c:forEach var="appliedSpeciesFilter" items="${speciesFilters}">
            <form action="${proteinsUrl}" method="get">
              <fieldset>
                <customElement:inputDefaultParams query="" pn="0" ps="${facetPage.size}" sort="${facetPage.sort}"/>
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
    <c:if test="${not empty proteinFacets}">
      <%-- Table and controls --%>

      <div id="search-result-table" class="grid_20 omega">
          <%-- Peptiform Table --%>
        <customElement:paginator baseUrl="/proteins" page="${facetPage}" query="" speciesFilters="${speciesFilters}"/>
        <table class="summary-table">
          <thead>
            <%-- ToDo: implement sort --%>
          <tr>
            <th>
              <c:choose>
                <c:when test="${facetPage.sort != null && fn:contains(facetPage.sort, 'index') }">
                  Protein accession
                </c:when>
                <c:otherwise>
                  <customElement:sortUrl baseUrl="/proteins" label="Protein accession" ps="${facetPage.size}" pn="${facetPage.number}" so="index:DESC" speciesFilter="${speciesFilters}"/>
                </c:otherwise>
              </c:choose>
            </th>
            <th>
              <c:choose>
                <c:when test="${facetPage.sort != null && fn:contains(facetPage.sort, 'index') }">
                  <customElement:sortUrl baseUrl="/proteins" label="# Peptiforms" ps="${facetPage.size}" pn="${facetPage.number}" so="" speciesFilter="${speciesFilters}"/>
                </c:when>
                <c:otherwise>
                  # Peptiforms
                </c:otherwise>
              </c:choose>
            </th>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="proteinFacet" items="${proteinFacets}">
            <tr>
              <td>
                <spring:url var="viewerProteinUrl" value="/viewer/#protein={protein_accession}">
                  <spring:param name="protein_accession" value="${proteinFacet.value}" />
                </spring:url>
                <a href="${viewerProteinUrl}">${proteinFacet.value}</a>
              </td>
              <td>
                ${proteinFacet.valueCount}
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
        <customElement:paginator baseUrl="/proteins" page="${facetPage}" query="" speciesFilters="${speciesFilters}"/>

      </div><%-- end of result table --%>
    </c:if><%-- end of list of peptiforms --%>

  </section><%-- end of data table, filters and controls --%>


</div>
