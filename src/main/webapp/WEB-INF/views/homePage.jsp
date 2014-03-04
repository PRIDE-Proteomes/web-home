<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<div id="top" class="grid_24 clearfix">

    <section id="introduction" class="grid_18 alpha">
        <h2>
            <fmt:message key="welcome.intro.caption"/>
        </h2>

        <p>
            <fmt:message key="welcome.intro.body"/>
        </p>
    </section>
</div>

<div id="bottom" class="grid_24">

    <section id="browse-data" class="grid_8">
        <h3>
            <fmt:message key="welcome.browse.proteomes.caption"/>
        </h3>

        <div class="row">
             <span class="icon icon-species" data-icon="H">
                 <fmt:message key="human.proteome.name"/>
             </span>
            (
            <span class="latin-species">
                <fmt:message key="human.latin.proteome.name"/>
            </span>
            )
            <c:url var="browse_human_url" value="search?q=&newSpeciesFilter=9606"/>
            <a href="${browse_human_url}">Browse</a>
        </div>

        <div class="row">
            <span class="icon icon-species" data-icon="M">
                <fmt:message key="mouse.proteome.name"/>
            </span>
            (
            <span class="latin-species">
                <fmt:message key="mouse.latin.proteome.name"/>
            </span>
            )
            <c:url var="browse_mouse_url" value="search?q=&newSpeciesFilter=10090"/>
            <a href="${browse_mouse_url}">Browse</a>
        </div>

        <div class="row">
            <span class="icon icon-species" data-icon="R">
                <fmt:message key="rat.proteome.name"/>
            </span>
            (
            <span class="latin-species">
                <fmt:message key="rat.latin.proteome.name"/>
            </span>
            )
            <c:url var="browse_rat_url" value="search?q=&newSpeciesFilter=10116"/>
            <a href="${browse_rat_url}">Browse</a>
        </div>

        <div class="row">
            <span class="icon icon-species" data-icon="P">
                <fmt:message key="arabidopsis.proteome.name"/>
            </span>
            (
            <span class="latin-species">
                <fmt:message key="arabidopsis.latin.proteome.name"/>
            </span>
            )
            <c:url var="browse_arabidopsis_url" value="search?q=&newSpeciesFilter=3702"/>
            <a href="${browse_arabidopsis_url}">Browse</a>
        </div>

    </section>

    <section id="statistics" class="grid_16 clearfix">
        <h3>
            <fmt:message key="welcome.statistics.caption"/>
        </h3>

        <div id="stats_div" class="grid_8 clearfix">
            <p><fmt:message key="statistics.sub.caption"/></p>
            <ul>
                <li>
                    <div id="protCnt">Proteins:</div>
                </li>
                <li>
                    <div id="pepCnt">Peptides:</div>
                </li>
                <li>
                    <div id="pformCnt">Peptiforms:</div>
                </li>
            </ul>
        </div>

        <div id="chart_div" class="grid_8"></div>
    </section>

</div>

