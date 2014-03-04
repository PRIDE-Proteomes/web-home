// load google core chart package
google.load("visualization", "1", {"callback" : drawCharts, "packages":["corechart"]});

// draw statistics chart querying web service
function drawCharts() {

    $.getJSON('/pride/ws/proteomes/stats/summary', function(statsData) {

        var txt = document.createTextNode(statsData.proteinCount);
        document.getElementById('protCnt').appendChild(txt);
        txt = document.createTextNode(statsData.symbolicPeptideCount);
        document.getElementById('pepCnt').appendChild(txt);
        txt = document.createTextNode(statsData.peptiformCount);
        document.getElementById('pformCnt').appendChild(txt);

        // prepare data table
        var dataTable = new google.visualization.DataTable();
        // add columns
        dataTable.addColumn('string', 'Species');
        dataTable.addColumn('number', 'Protein count');
        dataTable.addColumn('number', 'Peptide count');
        dataTable.addColumn('number', 'Peptiform count');


        // add rows
        for(var propt in statsData.datasetStatistics){
            var data = statsData.datasetStatistics[propt];
            dataTable.addRow([data.speciesName, data.proteinCount, data.symbolicPeptideCount, data.peptiformCount]);
        }

        var options = {'title': "Species comparison",
            'pointSize':3,
            'width':400,
            'height':200,
            'legend' :{'position' :'bottom'},
            'hAxis' : {logScale: true, format:'###,###'}
        };

        var chart = new google.visualization.BarChart(document.getElementById("chart_div"));
        chart.draw(dataTable, options);

    });
}

