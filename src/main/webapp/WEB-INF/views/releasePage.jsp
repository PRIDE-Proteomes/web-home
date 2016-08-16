<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>--%>
<%--<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>--%>


<section id="top" class="grid_24 clearfix">
    <h2>
        Release Summary
    </h2>

    <section id="release_summary_chart">
        <div id="molecules_chart"></div>
    </section>

    <h2>
        Species in the release and reference proteomes
    </h2>

    <section class="push_2 grid_20">
        <table class="summary-table">
            <thead>
            <tr>
                <th>Scientific Name</th>
                <th>Taxon Id</th>
                <th>Reference Database</th>
                <th>Reference Database version</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="releaseSummary" items="${releaseSummaries}">
                <tr>
                    <td>
                        <spring:url var="releaseSpeciesUrl" value="/release/{species}">
                            <spring:param name="species" value="${releaseSummary.taxonID}"/>
                        </spring:url>
                        <a href="${releaseSpeciesUrl}" class="icon icon-functional" data-icon="4">${releaseSummary.scientificName}</a>
                    </td>
                    <td>${releaseSummary.taxonID}</td>
                    <td>
                        <spring:url var="uniprotProteomesUrl" value="http://www.uniprot.org/proteomes/{proteomeId}">
                            <spring:param name="proteomeId" value="${releaseSummary.referenceDatabase}"/>
                        </spring:url>
                        <a href="${uniprotProteomesUrl}" class="icon icon-generic" data-icon="x">${releaseSummary.referenceDatabase}</a>
                    </td>
                    <td>${releaseSummary.referenceDatabaseVersion}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </section>


    <script>
        // Load the Visualization API and the corechart package.
        google.charts.load('current', {'packages': ['corechart', 'bar']});

        // Set a callback to run when the Google Visualization API is loaded.
        google.charts.setOnLoadCallback(drawSummaryChart);

        function drawSummaryChart() {

            var data = [];
            data[0] = ([
                {label: 'Species', type: 'string'},
                {label: 'Peptiforms', type: 'number'},
                {label: 'Peptides', type: 'number'},
                {label: 'Proteins', type: 'number'},
                {label: 'Genes', type: 'number'},
                {type: 'string', role: 'annotation'}]);

            <c:forEach varStatus="status" var="releaseSummary" items="${releaseSummaries}">
            data[${status.index}+1] = [
                '${releaseSummary.scientificName}',
                ${releaseSummary.numPeptiforms},
                ${releaseSummary.numPeptides},
                ${releaseSummary.numProteins},
                ${releaseSummary.numGenes},
                ''];
            </c:forEach>

            var data_proteins = google.visualization.arrayToDataTable(data, false);

            var options_proteins = {
                title: 'Number of Molecules per Species',
                titleTextStyle: {
                    fontSize: 15,
                    color: '#757575'

                },
                tooltip: {
                    showColorCode: true
                },
                fontSize: 12,
                fontName: 'Roboto',
                colors: ['#4285f4', '#db4437', '#f4b400', '#0f9d58'],
                height: 350,
                legend: {
                    position: 'right',
                    textStyle: {
                        color: '#757575'
                    }
                },
                vAxis: {
                    format: 'decimal',
                    textStyle: {
                        color: '#757575'
                    }
                },
                hAxis: {
                    textStyle: {
                        color: '#757575'
                    },
                    slantedText: true,
                    slantedTextAngle: 15
                }
            };

            // Instantiate and draw our chart, passing in some options.
            var molecules_chart = new google.visualization.ColumnChart(document.getElementById('molecules_chart'));
            molecules_chart.draw(data_proteins, options_proteins);

        }

    </script>

</section>




