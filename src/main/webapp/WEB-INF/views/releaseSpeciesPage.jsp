<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>--%>
<%--<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>--%>

<script>
    // Load the Visualization API and the corechart package.
    google.charts.load('current', {'packages':['corechart','bar']});

    // Set a callback to run when the Google Visualization API is loaded.
    google.charts.setOnLoadCallback(drawChartSpecies);

    function drawChartSpecies() {

        var data_mapped_proteins = google.visualization.arrayToDataTable([
            ['Species', 'Canonical Proteins', 'Isoform Proteins', {role: 'annotation'}, {role: 'style'}],
            ['Proteins', ${releaseSummary.numCanonicalProteins}, ${releaseSummary.numIsoformProteins}, '', ''],
            ['Mapped Proteins', ${releaseSummary.numMappedCanonicalProteins}, ${releaseSummary.numMappedCanonicalProteins}, '', '']
        ]);

        var options_data_mapped_proteins = {
            height: 400,
            legend: {position: 'top', maxLines: 4},
            isStacked: true,
            vAxis: {
                title: 'Num Proteins'
            }
        };
        var chart_mapped_proteins = new google.visualization.ColumnChart(document.getElementById('chart_mapped_proteins'));
        chart_mapped_proteins.draw(data_mapped_proteins, options_data_mapped_proteins);


        var data_peptides = google.visualization.arrayToDataTable([
            [
                'Species',
                'Mapped Unique Peptides to Canonical Proteins',
                'Mapped Unique Peptides to Isoform Proteins',
                'Mapped Unique Peptides to Genes',
                {role: 'annotation'}
            ],
            [
                'Unique peptides',
                ${releaseSummary.numMappedUniquePeptidesToCanonicalProteins},
                ${releaseSummary.numMappedUniquePeptidesToIsoformProteins},
                ${releaseSummary.numMappedUniquePeptidesToGenes},
                ''
            ]
        ]);


        var options_peptides = {
            height: 400,
            legend: { position: 'top', maxLines: 3 },
            vAxis: {
                scaleType: 'mirrorLog',
                title: 'Num Peptides'
            }
        };
        var chart_peptides = new google.visualization.ColumnChart(document.getElementById('chart_peptides'));
        chart_peptides.draw(data_peptides, options_peptides);


        var data_evidence = google.visualization.arrayToDataTable([
            ['Task', 'Protein Evidence ${releaseSummary.scientificName}'],
            ['Experimental Evidence at protein level', ${releaseSummary.numProteinsWithExpEvidence}],
            ['Experimental Evidence at Transcript Level', ${releaseSummary.numProteinsWithExpEvidenceAtTranscript}],
            ['Evidence Inferred by Homology', ${releaseSummary.numProteinsWithEvidenceInferredByHomology}],
            ['Evidence Predicted', ${releaseSummary.numProteinsWithEvidenceInferredByHomology}],
            ['Evidence Uncertain',  ${releaseSummary.numProteinsWithEvidenceUncertain}],
            ['Evidence not reported', ${releaseSummary.numProteinsWithEvidenceNotReported}]

        ]);
        var options_evidence = {
            height: 400,
            title: 'Human Protein Evidence',
            pieHole: 0.2,
        };
        var chart_evidence = new google.visualization.PieChart(document.getElementById('chart_evidence'));
        chart_evidence.draw(data_evidence, options_evidence);

        //40895
        //9969 + 30926 = 40895
        var data_mapped_evidence = google.visualization.arrayToDataTable([
            ['Task', 'Mapped Protein ${releaseSummary.scientificName}'],
            ['Experimental Evidence at protein level', ${releaseSummary.numMappedProteinsWithExpEvidence}],
            ['Experimental Evidence at Transcript Level', ${releaseSummary.numMappedProteinsWithExpEvidenceAtTranscript}],
            ['Evidence Inferred by Homology', ${releaseSummary.numMappedProteinsWithEvidenceInferredByHomology}],
            ['Evidence Predicted', ${releaseSummary.numMappedProteinsWithEvidenceInferredByHomology}],
            ['Evidence Uncertain',  ${releaseSummary.numMappedProteinWithEvidenceUncertain}],
            ['Evidence not reported', ${releaseSummary.numMappedProteinsWithEvidenceNotReported}]
        ]);

        var options_mapped_evidence = {
            height: 400,
            title: 'Human Protein Mapped Evidence',
            pieHole: 0.2,
        };
        var chart_mapped_evidence = new google.visualization.PieChart(document.getElementById('chart_mapped_evidence'));
        chart_mapped_evidence.draw(data_mapped_evidence, options_mapped_evidence);

    }

</script>

<section id="top" class="grid_24 clearfix">
    <h2>${releaseSummary.scientificName} (${releaseSummary.taxonID})</h2>
    <h3>Reference Database: ${releaseSummary.referenceDatabase} </h3>
    <h3>Reference Database version: ${releaseSummary.referenceDatabaseVersion} </h3>


    <section class="grid_24">
        <section id="mapped_proteins" class="grid_12">
            <div id="chart_mapped_proteins"></div>
        </section>
        <section id="peptides" class="grid_12">
            <div id="chart_peptides"></div>
        </section>
    </section>

    <section class="grid_24">
        <section id="evidence" class="grid_12">
            <div id="chart_evidence"></div>
        </section>
        <section id="mapped_evidence" class="grid_12">
            <div id="chart_mapped_evidence"></div>
        </section>
    </section>

<%--<section id="proteins_two" class="grid_24">--%>
    <%--<div id="chart_div_two"></div>--%>
    <%--</section>--%>
    <%--<section id="peptides" class="grid_24">--%>
    <%--<div id="chart_div_three"></div>--%>
    <%--</section>--%>

    <%--<section id="protein_evidence" class="grid_24">--%>
    <%--<div id="chart_evidence"></div>--%>
    <%--</section>--%>

    <%--<section id="mapped_protein_evidence" class="grid_24">--%>
    <%--<div id="chart_mapped_evidence"></div>--%>
    <%--</section>--%>


    <section class="push_2 grid_20">
        <table class="summary-table">
            <thead>
            <tr>
                <th>
                    Description
                </th>
                <th>
                    Count
                </th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td>Peptiforms</td>
                <td>${releaseSummary.numPeptiforms}</td>
            </tr>
            <tr>
                <td>Peptides</td>
                <td>${releaseSummary.numPeptides}</td>
            </tr>
            <tr>
                <td>Proteins</td>
                <td>${releaseSummary.numProteins}</td>
            </tr>
            <tr>
                <td>Canonical Proteins</td>
                <td>${releaseSummary.numCanonicalProteins}</td>
            </tr>
            <tr>
                <td>Isoform Proteins</td>
                <td>${releaseSummary.numIsoformProteins}</td>
            </tr>
            <tr>
                <td>Genes</td>
                <td>${releaseSummary.numGenes}</td>
            </tr>
            <tr>
                <td>Mapped Proteins</td>
                <td>${releaseSummary.numMappedProteins}</td>
            </tr>
            <tr>
                <td>Mapped Canonical Proteins</td>
                <td>${releaseSummary.numMappedCanonicalProteins}</td>
            </tr>
            <tr>
                <td>Mapped Isoform Proteins</td>
                <td>${releaseSummary.numMappedIsoformProteins}</td>
            </tr>
            <tr>
                <td>Mapped Genes</td>
                <td>${releaseSummary.numGenes}</td>
            </tr>
            <tr>
                <td>Mapped Peptides to Proteins</td>
                <td>${releaseSummary.numMappedPeptidesToProteins}</td>
            </tr>
            <tr>
                <td>Mapped Unique Peptides to Proteins</td>
                <td>${releaseSummary.numMappedUniquePeptidesToProteins}</td>
            </tr>
            <tr>
                <td>Mapped Uniqiue Peptides to Canonical Proteins</td>
                <td>${releaseSummary.numMappedUniquePeptidesToCanonicalProteins}</td>
            </tr>
            <tr>
                <td>Mapped Unique Peptides to Isoform Proteins</td>
                <td>${releaseSummary.numMappedUniquePeptidesToIsoformProteins}</td>
            </tr>
            <tr>
                <td>Mapped Unique Peptides to Genes</td>
                <td>${releaseSummary.numMappedUniquePeptidesToGenes}</td>
            </tr>
            <tr>
                <td>Mapped Proteins with Unique Peptides</td>
                <td>${releaseSummary.numMappedProteinsWithUniquePeptides}</td>
            </tr>
            <tr>
                <td>Mapped Canonical Proteins with Unique Peptides</td>
                <td>${releaseSummary.numMappedCanonicalProteinsWithUniquePeptides}</td>
            </tr>
            <tr>
                <td>Mapped Isoform Proteins with Unique Peptides</td>
                <td>${releaseSummary.numMappedIsoformProteinsWithUniquePeptides}</td>
            </tr>
            <tr>
                <td>Mapped Genes with Unique Peptides</td>
                <td>${releaseSummary.numMappedGenesWithUniquePeptides}</td>
            </tr>
            <tr>
                <td>Mapped Proteins with Experimental Evidence at Transcript Level</td>
                <td>${releaseSummary.numMappedProteinsWithExpEvidenceAtTranscript}</td>
            </tr>
            <tr>
                <td>Mapped Proteins with Evidence Inferred by Homology</td>
                <td>${releaseSummary.numMappedProteinsWithEvidenceInferredByHomology}</td>
            </tr>
            <tr>
                <td>Mapped Proteins with Evidence Predicted</td>
                <td>${releaseSummary.numMappedProteinWithEvidencePredicted}</td>
            </tr>
            <tr>
                <td>Mapped Proteins with Evidence Uncertain</td>
                <td>${releaseSummary.numMappedProteinWithEvidenceUncertain}</td>
            </tr>
            </tbody>
        </table>
    </section>
</section>




