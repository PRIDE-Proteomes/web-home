<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<div id="top" class="grid_24 clearfix">
    <section id="introduction" class="grid_22 prefix_1">
        <h2>Browse PRIDE Proteome's data</h2>

        <p class="text-para">
            PRIDE Proteome is based on <b>peptiforms</b>, which correspond to observable
            fragments of a protein. These are usually called <b>peptides</b>, however
            this terms usually does not take into account that the amino acid sequence
            could carry modifications at varying positions. Proteomes generates a protein
            mapping based on those peptiforms and also a protein group mapping (to UniProt
            entries and gene level). This allows the calculation of unique identifications
            on protein isoform, UniProt protein entry or gene level.
            <br/><br/>
        </p>
    </section>

    <section id="stats_chart" class="grid_22 prefix_1">
        <svg class="d3_stats_chart">
            <text id="loading_placeholder" x="50" y="30">Loading data...</text>
        </svg>
        <%-- define the layout of the tooltip that will be displayed when hovering over chart bars --%>
        <div id="tooltip" class="hidden">
            <p><strong><span id="dataType">dataType</span></strong></p>
            <div id="details">
                <p>With evidence: <span id="wEvi">x</span></p>
                <p>Without evidence: <span id="woEvi">x</span></p>
            </div>
            <p>Total: <span id="value">x</span></p>
        </div>
        <script>

                var data = {
                    labels: ['peptiforms', 'proteins', 'UniProt Entry groups', 'Gene groups'],
                    urlPath: ['peptiforms', 'proteins', 'upgroups', 'genes'],
                    series: []
                };

                $.getJSON('/pride/ws/proteomes/stats/summary', function (statsData) {
                    fillDataset(data, statsData);

                    // draw the chart with
                    // - the data (data structure as defined above)
                    // - the total height of the graphic
                    // - the total width of the graphic (including space for labels and legend)
                    // - the space for labels (if not present or 0, no labels)
                    // - the space for the legend (if not present or 0, no legend)
                    drawBarChart(".d3_stats_chart", data, 350, 700, 130, 160);
//                    drawBarChart(".d3_stats_chart", data, 'dynamic', 700, 130, 160);
                });

                function fillDataset(dataset, dataToParse) {
                    for (var i = 0; i < dataToParse.datasetStatistics.length; i++) {
                        var data = dataToParse.datasetStatistics[i];
                        // taxid == 1 is 'All species', which we want to exclude here
                        if (data.taxid != 1) {
                            dataset.series.push({
                                label: data.commonName,
                                name: data.scientificName,
                                taxid: data.taxid,
                                values: [
                                    {counts: {total:data.peptiformCount, woevi:0}},
                                    {counts: {total:data.proteinCount, woevi:Math.round(data.proteinCount * 0.3)}},
                                    {counts: {total:data.upGroupCount, woevi:Math.round(data.upGroupCount * 0.3)}},
                                    {counts: {total:data.geneGroupCount, woevi:Math.round(data.geneGroupCount * 0.3)}}
                                ]
                            });
                        }
                    }
                }

        </script>

    </section>

    <section id="chart_desc" class="grid_22 prefix_1">
        <p class="text-para">
            <br/>
            The main use case supported by Proteomes is peptiform based, whether searching
            for a specific peptide sequence to see where it could map in the model organism
            or searching for a protein, gene or keyword to find peptiforms that support this
            identification. Therefore the Proteomes search is based on peptiforms. However,
            it is also possible to list/browse the proteins, UniProt entry groups or genes
            of the resource via simple browse pages. The interactive chart above can be used
            to quickly jump into the data. A click on any of the bars in the chart will link
            to the species browse pages, whereas a click on any legend item will redirect to
            the species independent alternative.
        </p>
    </section>


<%--
    <section id="browse-data" class="grid_16 prefix_2 suffix_4">
        <h3>
            Browse by species
        </h3>

        <div>
            <fmt:message key="human.latin.proteome.name" var="human_title"/>
        <span class="icon icon-species" data-icon="H" title="${human_title}">
        <fmt:message key="human.proteome.name"/>
        </span>

            <c:url var="peptiform_url" value="/browse/peptiforms?q=&speciesFilter=9606"/>
            <a href="${peptiform_url}" style="border-bottom-style: none" class="icon icon-conceptual" data-icon="b" title="Peptiforms"></a>

            <c:url var="protein_url" value="/browse/proteins?speciesFilter=9606"/>
            <a href="${protein_url}" style="border-bottom-style: none" class="icon icon-conceptual" data-icon="P" title="Proteins"></a>
        </div>

        <div>
            <fmt:message key="mouse.latin.proteome.name" var="mouse_title"/>
        <span class="icon icon-species" data-icon="M" title="${mouse_title}">
        <fmt:message key="mouse.proteome.name"/>
        </span>

            <c:url var="peptiform_url" value="/browse/peptiforms?q=&speciesFilter=10090"/>
            <a href="${peptiform_url}" style="border-bottom-style: none" class="icon icon-conceptual" data-icon="b" title="Peptiforms"></a>

            <c:url var="protein_url" value="/browse/proteins?speciesFilter=10090"/>
            <a href="${protein_url}" style="border-bottom-style: none" class="icon icon-conceptual" data-icon="P" title="Proteins"></a>
        </div>

        <div>
            <fmt:message key="rat.latin.proteome.name" var="rat_title"/>
        <span class="icon icon-species" data-icon="R" title="${rat_title}">
        <fmt:message key="rat.proteome.name"/>
        </span>

            <c:url var="peptiform_url" value="/browse/peptiforms?q=&speciesFilter=10116"/>
            <a href="${peptiform_url}" style="border-bottom-style: none" class="icon icon-conceptual" data-icon="b" title="Peptiforms"></a>

            <c:url var="protein_url" value="/browse/proteins?speciesFilter=10116"/>
            <a href="${protein_url}" style="border-bottom-style: none" class="icon icon-conceptual" data-icon="P" title="Proteins"></a>
        </div>

        <div>
            <fmt:message key="arabidopsis.latin.proteome.name" var="cress_title"/>
        <span class="icon icon-species" data-icon="P" title="${cress_title}">
        <fmt:message key="arabidopsis.proteome.name"/>
        </span>

            <c:url var="peptiform_url" value="/browse/peptiforms?q=&speciesFilter=3702"/>
            <a href="${peptiform_url}" style="border-bottom-style: none" class="icon icon-conceptual" data-icon="b" title="Peptiforms"></a>

            <c:url var="protein_url" value="/browse/proteins?speciesFilter=3702"/>
            <a href="${protein_url}" style="border-bottom-style: none" class="icon icon-conceptual" data-icon="P" title="Proteins"></a>
        </div>

    </section>
--%>

</div>

