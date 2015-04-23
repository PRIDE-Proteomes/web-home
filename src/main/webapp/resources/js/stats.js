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
// Set bar chart options
var materialOptions = {
    chart: { title: "Browse PRIDE Proteome's data" },
    width: 900,
    height: 400,
    vAxis: { title: '',
        textStyle: {color: 'black'}
    },
    hAxis: {
        format: 'decimal',
        //logScale: true, // does not work in material design charts (possible bug)
        textStyle: {color: 'black'}
    },
    legend: {textStyle: {color: 'black'}
    },
    titleTextStyle: {color: 'black'},
    colors: ['#B2D1FF', '#FF9999', '#FFE680', '#99EBC2'],
    bars: 'horizontal'
};

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


    $.getJSON('/pride/ws/proteomes/stats/summary', function(statsData) {
        if (logging) {
            console.log("Statistics data retrieved from web service:");
        }
        // add rows
        for(var propt in statsData.datasetStatistics){
            var data = statsData.datasetStatistics[propt];
            if (logging) {
                console.log(
                      "species:" + data.speciesName
                    + " taxid:" + data.taxid
                    + " proteins:" + data.proteinCount
                    + " peptiforms:" + data.peptiformCount
                    + " upGroups:" + data.upGroupCount
                    + " geneGroups:" + data.geneGroupCount);
            }
            // taxid == 1 is 'All species', which we want to exclude here
            if (data.taxid != 1) {
                dataTable.addRow([
                    data.speciesName,
                    data.taxid,
                    data.peptiformCount,
                    data.proteinCount,
                    data.upGroupCount,
                    data.geneGroupCount
                ]);
            }
        }
    });

    // test data
    //dataTable.addRow(['Human', 9606, 10000, 500, 400, 300]);
    //dataTable.addRow(['Mouse', 10090, 14000, 1000, 800, 700]);
    //dataTable.addRow(['Rat', 10116, 5000, 300, 200, 100]);


    var dataview = new google.visualization.DataView(dataTable);
    dataview.hideColumns([1]);

    dataBarChart = new google.charts.Bar(document.getElementById('bar_chart'));
    //dataBarChart = new google.visualization.BarChart(document.getElementById('bar_chart'));


    google.visualization.events.addListener(dataBarChart, 'select', myClickHandler);
    //google.visualization.events.addListener(dataBarChart, 'onmouseover', barMouseOver);
    //google.visualization.events.addListener(dataBarChart, 'onmouseout', barMouseOut);


    dataBarChart.draw(dataview, google.charts.Bar.convertOptions(materialOptions));
    //dataBarChart.draw(dataview, materialOptions);

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
                    window.location.assign("browse/peptiforms?speciesFilter="+taxid);
                    break;
                case 2 :
                    message += "Proteins for " + taxid;
                    window.location.assign("browse/proteins?speciesFilter="+taxid);
                    break;
                case 3 :
                    message += "UP Groups for " + taxid;
                    window.location.assign("browse/upgroups?speciesFilter="+taxid);
                    break;
                case 4 :
                    message += "Genes for " + taxid;
                    window.location.assign("browse/genes?speciesFilter="+taxid);
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
                    window.location.assign("browse/peptiforms");
                    break;
                case 2 :
                    message += "Proteins";
                    window.location.assign("browse/proteins");
                    break;
                case 3 :
                    message += "UP Groups";
                    window.location.assign("browse/upgroups");
                    break;
                case 4 :
                    message += "Genes";
                    window.location.assign("browse/genes");
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

