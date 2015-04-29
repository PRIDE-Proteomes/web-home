


function drawBarChart (selector, data, chartH, chartW, labelSpace, legendSpace) {

    // ToDo: tooltips
    // ToDo: try to put colors into CSS
    // ToDo: try to be flexible with dataset series length (currently switch case is hard coded)

    var chartWidth       = 100,
        chartHeight      = 100,
        gapBetweenGroups = 10,
        spaceForLabels   = 0,
        spaceForLegend   = 0;
    var legendRectSize   = 15,
        legendSpacing    = 4,
        axisPadding      = 30;

    if (legendSpace > 0) {
        spaceForLegend = legendSpace;
    }
    if (labelSpace > 0) {
        spaceForLabels = labelSpace;
    }
    if (chartH > 0) {
        chartHeight = chartH;
    }
    if (chartW > 0) {
        chartWidth = chartW - spaceForLabels - spaceForLegend;
    }


    var barHeight       = (chartHeight- gapBetweenGroups * data.series.length) / numBars(data),
        groupHeight      = barHeight * data.series.length;

    // function that will return the max value of all values of all data series
    function findMax(dataset) {
        var max = 0;
        for (var j=0; j<dataset.series.length; j++) {
            for (var i=0; i<dataset.labels.length; i++) {
                if (dataset.series[j].values[i] > max){
                    max = dataset.series[j].values[i];
                }
            }
        }
        return max;
    }
    function numBars(dataset) {
        var cnt = 0;
        for (var i=0; i<dataset.series.length; i++) {
            cnt += dataset.series[i].values.length;
        }
        return cnt;
    }
    function indexForLabel(label) {
        for (var i=0; i<data.labels.length; i++) {
            if (data.labels[i] === label) {
                return i;
            }
        }
    }

    var maxDataValue = findMax(data);
// Set up the scales
    // Color scale
    var color = d3.scale.ordinal().range(["#6b486b", "#7b6888", "#8a89a6", "#98abc5"]);
    // scale for x values
    //var xScale = d3.scale.linear()
    var xScale = d3.scale.log()
        .domain([1, maxDataValue])
        .range([0, chartWidth]);

    var xAxis = d3.svg.axis()
        .scale(xScale)
        .orient("bottom")
        .ticks(10, ",.1s");

// Create the chart

    // Create the chart area where the HTML element with class 'chart' is
    var chart = d3.select(selector)
        .attr("width", spaceForLabels + chartWidth + spaceForLegend)
        .attr("height", chartHeight+axisPadding);

    chart.selectAll("#loading_placeholder").remove();


    // create a svg group for each series in the data (e.g. per species)
    var groups = chart.selectAll("g")
        .data(data.series)
        .enter()
        .append("g")
        .attr("transform", function(d, i) {
            return "translate(" + spaceForLabels + "," + (i * barHeight *(data.labels.length) + i*gapBetweenGroups) + ")";
        })
        .attr("series", function(d,i){
            return i;
        });

    // create a svg group for each 'bar' (e.g. to hold the bar rectangle and any bar text/label)
    var bars = groups.selectAll("g")
        .data(function(d){
            return d.values;
        })
        .enter()
        .append("g")
        .attr("class", function(d,i) {
            return "bar_"+i;
        })
        .attr("dataType", function(d,i){
            return i;
        });

    // Add the rectangles to the bar groups
    bars.append("rect")
        .attr("fill", function(d,i) { return color(i % data.labels.length); })
        .attr("width", xScale)
        .attr("height", barHeight - 1)
        .attr("transform", function(d, i) {
            return "translate(0," + (i * barHeight) + ")";
        });

    // Add the text label to the bar groups
    bars.append("text")
        .attr("x", function(d) { return xScale(d) - 3; })
        .attr("y", barHeight / 2)
        .attr("dy", ".35em")
        .text(function(d) { return d; })
        .attr("transform", function(d, i) {
            return "translate(0," + (i * barHeight) + ")";
        });

    // Add mouse listeners to the bar groups
    bars.on("mouseover", function() {
        bars.attr("hovered", true);
        d3.select(this)
            .attr("hovered", null);
    });
    bars.on("mouseout", function() {
        bars.attr("hovered", null);
    });
    bars.on("click", function() {
        var seriesId = d3.select(this.parentNode).attr("series");
        var labelId = d3.select(this).attr("dataType");
        var url = getUrl(labelId, seriesId);
        console.log("url: " + url);
        //window.location.assign(url);
    });


// Draw labels for each series group (e.g. the species label)
    groups.append("text")
        .attr("class", "label")
        .attr("x", function() { return -5; })
        .attr("y", groupHeight / 2)
        .attr("dy", ".35em")
        .text(function(d) {
            return d.label;
        });


// Draw legend
    var legend = chart.selectAll('.legend')
        .data(data.labels)
        .enter()
        .append('g')
        .attr('transform', function (d, i) {
            var height = legendRectSize + legendSpacing;
            var offset = -gapBetweenGroups/2;
            var horz = spaceForLabels + chartWidth + 40 - legendRectSize;
            var vert = i * height - offset;
            return 'translate(' + horz + ',' + vert + ')';
        })
        .attr("label", function(d,i){
            return i;
        });

    legend.append('rect')
        .attr("class", "bar")
        .attr('width', legendRectSize)
        .attr('height', legendRectSize)
        .style('fill', function (d, i) { return color(i); })
        .style('stroke', function (d, i) { return color(i); });

    legend.append('text')
        .attr('class', 'legend')
        .attr('x', legendRectSize + legendSpacing)
        .attr('y', legendRectSize - legendSpacing)
        .text(function (d) { return d; });

    legend.on("mouseover", function(d){
        var index = indexForLabel(d);
        bars.attr("hovered", true);
        d3.selectAll(".bar_"+index)
            .attr("hovered", null);
    });
    legend.on("mouseout", function(){
        bars.attr("hovered", null);
    });
    legend.on("click", function() {
        var labelId = d3.select(this).attr("label");
        var url = getUrl(labelId);
        console.log(url);
        //window.location.assign(url);
    });

    chart.append("g")
        .call(xAxis)
        .attr("class", "axis")
        .attr("transform", function() {
            return "translate(" + spaceForLabels + ","+(chartHeight)+")";
        });

    function getUrl(labelId, seriesId) {
        var url = "/browse/";
        switch (parseInt(labelId)) {
            case 0 :
                url +="peptiforms";
                break;
            case 1 :
                url +="proteins";
                break;
            case 2 :
                url +="upgroups";
                break;
            case 3 :
                url +="genes";
                break;
            default : console.log("Unrecognised series: " + labelId);
        }
        if (seriesId >= 0) {
            url += getSpeciesPart(seriesId);
        }
        return url;
    }
    function getSpeciesPart(seriesId) {
        var speciesPart = '?speciesFilter=';
        switch (parseInt(seriesId)) {
            case 0 :
                //speciesPart += "foo0";
                speciesPart +="" + data.series[0].taxid;
                break;
            case 1 :
                //speciesPart += "foo1";
                speciesPart +="" + data.series[1].taxid;
                break;
            case 2 :
                //speciesPart += "foo2";
                speciesPart +="" + data.series[2].taxid;
                break;
            case 3 :
                //speciesPart += "foo3";
                speciesPart +="" + data.series[3].taxid;
                break;
            default : console.log("Unrecognised taxid");
        }
        return speciesPart;
    }
}
