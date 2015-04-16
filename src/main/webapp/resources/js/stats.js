//// load google core chart package
//google.load("visualization", "1", {"callback" : drawCharts, "packages":["corechart"]});
//
//// draw statistics chart querying web service
//function drawCharts() {
//
//    $.getJSON('/pride/ws/proteomes/stats/summary', function(statsData) {
//
//        // add the counts to the total content fields
//        var txt = document.createTextNode(statsData.proteinCount);
//        document.getElementById('protCnt').appendChild(txt);
//        txt = document.createTextNode(statsData.symbolicPeptideCount);
//        document.getElementById('pepCnt').appendChild(txt);
//        txt = document.createTextNode(statsData.peptiformCount);
//        document.getElementById('pformCnt').appendChild(txt);
//
//
//        // prepare data table
//        var dataTable = new google.visualization.DataTable();
//        // add columns
//        dataTable.addColumn('string', 'Species');
//        dataTable.addColumn('number', 'Protein count');
//        dataTable.addColumn('number', 'Peptide count');
//        dataTable.addColumn('number', 'Peptiform count');
//
//
//        // add rows
//        for(var propt in statsData.datasetStatistics){
//            var data = statsData.datasetStatistics[propt];
//            dataTable.addRow([data.speciesName, data.proteinCount, data.symbolicPeptideCount, data.peptiformCount]);
//        }
//
//        var options = {'title': "Species comparison",
//            'pointSize':3,
//            'width':400,
//            'height':200,
//            'legend' :{'position' :'bottom'},
//            'hAxis' : {logScale: true, format:'###,###'}
//        };
//
//        var chart = new google.visualization.BarChart(document.getElementById("chart_div"));
//        chart.draw(dataTable, options);
//
//    });
//}

google.load('visualization', '1', {'packages': ['corechart','bar']});
google.setOnLoadCallback(drawCharts2);

var logging = false;

var dataBarChart;
var dataTable;

function drawCharts2() {

    // prepare data table
    dataTable = new google.visualization.DataTable();
    dataTable.addColumn('string', 'Species');
    //dataTable.addColumn('string', 'Latin Name');
    dataTable.addColumn('number', 'taxid');
    dataTable.addColumn('number', '# Peptiforms');
    dataTable.addColumn('number', '# Proteins');
    dataTable.addColumn('number', '# UP groups');
    dataTable.addColumn('number', '# genes');

    //dataTable.addRow(['Human', 'Homo sapiens', 1000, 500, 400, 300]);
    //dataTable.addRow(['Mouse', 'Mus musculus', 2000, 1000, 800, 700]);
    //dataTable.addRow(['Rat', 'Rattus norvegicus', 500, 300, 200, 100]);

    dataTable.addRow(['Human', 9606, 1000, 500, 400, 300]);
    dataTable.addRow(['Mouse', 10090, 1400, 1000, 800, 700]);
    dataTable.addRow(['Rat', 10116, 500, 300, 200, 100]);



    var dataview = new google.visualization.DataView(dataTable);
    dataview.hideColumns([1]);


    // Set bar chart options
    var materialOptions = {
        chart: { title: "Proteomes data" },
        width: 800,
        height: 250,
        vAxis:{ title: '' },
        hAxis : { format: '###,###' },
        colors: ['#B2D1FF', '#FF9999', '#FFE680', '#99EBC2'],
        bars: 'horizontal'
    };
    var options = {
        width: 900,
        height: 400
    };

    dataBarChart = new google.charts.Bar(document.getElementById('bar_chart'));
    //dataBarChart = new google.visualization.BarChart(document.getElementById('bar_chart'));


    google.visualization.events.addListener(dataBarChart, 'select', myClickHandler);
    //google.visualization.events.addListener(dataBarChart, 'onmouseover', barMouseOver);
    //google.visualization.events.addListener(dataBarChart, 'onmouseout', barMouseOut);


    dataBarChart.draw(dataview, google.charts.Bar.convertOptions(materialOptions));
    //dataBarChart.draw(dataview, options);

}

function myClickHandler(e){
    var selection = dataBarChart.getSelection();

    var message = '';
    for (var i = 0; i < selection.length; i++) {
        var item = selection[i];
        if (item.row != null && item.column != null) {
            message += '{row:' + item.row + ',column:' + item.column + '}';
            var taxid = dataTable.getValue(item.row, 1);
            switch (item.column) {
                case 1 :
                    message += "Peptiforms for " + taxid;
                    window.location.assign("./search?speciesFilter="+taxid);
                    break;
                case 2 :
                    message += "Proteins for " + taxid;
                    window.location.assign("./proteins?speciesFilter="+taxid);
                    break;
                case 3 :
                    message += "UP Groups for " + taxid;
                    //window.location.assign("./upgroups?speciesFilter="+taxid);
                    break;
                case 4 :
                    message += "Genes for " + taxid;
                    //window.location.assign("./genes?speciesFilter="+taxid);
                    break;
                default : message += "unknown data type";
            }

        } else if (item.row != null) {
            message += '{row:' + item.row + '}';
        } else if (item.column != null) {
            message += '{column:' + item.column + '}';
            switch (item.column) {
                case 1 :
                    message += "Peptiforms";
                    window.location.assign("./search");
                    break;
                case 2 :
                    message += "Proteins";
                    window.location.assign("./proteins");
                    break;
                case 3 :
                    message += "UP Groups";
                    break;
                case 4 :
                    message += "Genes";
                    break;
                default : message += "unknown data type";
            }
        }
    }
    if (message == '') {
        message = 'nothing';
    }
    if (logging) {
        console.log('You selected ' + message);
    }
}

function barMouseOver(e) {
    dataBarChart.setSelection([e]);
    if (logging) {
        console.log("mouse over");
        showRowColumn(e);
    }
    //dataBarChart.setSelection([{row: 1, column: 1}]);
}

function barMouseOut(e) {
    if (logging) {
        console.log("mouse out");
    }
    dataBarChart.setSelection([{'row': 1, 'column': 1}]);
//        dataBarChart.setSelection([{'row': 2, 'column': 2}]);
}

function showRowColumn(item) {
    var message = '';
    if (item != null) {
        if (item.row != null && item.column != null) {
            message += '{row:' + item.row + ',column:' + item.column + '}';
            var taxid = dataTable.getValue(item.row, 1);
            switch (item.column) {
                case 1 : message += "Peptiforms for " + taxid;
                    break;
                case 2 : message += "Proteins for " + taxid;
                    break;
                case 3 : message += "UP Groups for " + taxid;
                    break;
                case 4 : message += "Genes for " + taxid;
                    break;
                default : message += "unknown data type";
            }

        } else if (item.row != null) {
            message += '{row:' + item.row + '}';
        } else if (item.column != null) {
            message += '{column:' + item.column + '}';
            switch (item.column) {
                case 1 : message += "Peptiforms";
                    break;
                case 2 : message += "Proteins";
                    break;
                case 3 : message += "UP Groups";
                    break;
                case 4 : message += "Genes";
                    break;
                default : message += "unknown data type";
            }
        } else {
            message += "{row:null,column:null}nothing selected";
        }
    } else {
        message += "event null";

    }
    console.log('hovered: ' + message);
}

