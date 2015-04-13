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

        <div>
            <fmt:message key="human.latin.proteome.name" var="human_title"/>
            <span class="icon icon-species" data-icon="H" title="${human_title}">
                <fmt:message key="human.proteome.name"/>
            </span>

            <c:url var="peptiform_url" value="search?q=&speciesFilter=9606"/>
            <a href="${peptiform_url}" style="border-bottom-style: none" class="icon icon-conceptual" data-icon="b" title="Peptiforms"></a>

            <c:url var="protein_url" value="proteins?speciesFilter=9606"/>
            <a href="${protein_url}" style="border-bottom-style: none" class="icon icon-conceptual" data-icon="P" title="Proteins"></a>
        </div>

        <div>
            <fmt:message key="mouse.latin.proteome.name" var="mouse_title"/>
            <span class="icon icon-species" data-icon="M" title="${mouse_title}">
                <fmt:message key="mouse.proteome.name"/>
            </span>

            <c:url var="peptiform_url" value="search?q=&speciesFilter=10090"/>
            <a href="${peptiform_url}" style="border-bottom-style: none" class="icon icon-conceptual" data-icon="b" title="Peptiforms"></a>

            <c:url var="protein_url" value="proteins?speciesFilter=10090"/>
            <a href="${protein_url}" style="border-bottom-style: none" class="icon icon-conceptual" data-icon="P" title="Proteins"></a>
        </div>

        <div>
            <fmt:message key="rat.latin.proteome.name" var="rat_title"/>
            <span class="icon icon-species" data-icon="R" title="${rat_title}">
                <fmt:message key="rat.proteome.name"/>
            </span>

            <c:url var="peptiform_url" value="search?q=&speciesFilter=10116"/>
            <a href="${peptiform_url}" style="border-bottom-style: none" class="icon icon-conceptual" data-icon="b" title="Peptiforms"></a>

            <c:url var="protein_url" value="proteins?speciesFilter=10116"/>
            <a href="${protein_url}" style="border-bottom-style: none" class="icon icon-conceptual" data-icon="P" title="Proteins"></a>
        </div>

        <div>
            <fmt:message key="arabidopsis.latin.proteome.name" var="cress_title"/>
            <span class="icon icon-species" data-icon="P" title="${cress_title}">
                <fmt:message key="arabidopsis.proteome.name"/>
            </span>

            <c:url var="peptiform_url" value="search?q=&speciesFilter=3702"/>
            <a href="${peptiform_url}" style="border-bottom-style: none" class="icon icon-conceptual" data-icon="b" title="Peptiforms"></a>

            <c:url var="protein_url" value="proteins?speciesFilter=3702"/>
            <a href="${protein_url}" style="border-bottom-style: none" class="icon icon-conceptual" data-icon="P" title="Proteins"></a>
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

