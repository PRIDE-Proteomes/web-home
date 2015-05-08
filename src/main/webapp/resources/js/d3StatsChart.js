function drawBarChart (selector, data, chartH, chartW, labelSpace, legendSpace) {

    // ToDo: tooltips (may include coordinate extraction + translation!)
    // ToDo: try to put colors into CSS

    var chartWidth       = 100,
        chartHeight      = 100,
        gapBetweenGroups = 10,
        spaceForLabels   = 0,
        spaceForLegend   = 0;
    var legendRectSize   = 15,
        legendSpacing    = 4,
        axisPadding      = 30;
    var tooltipOffset    = -100;

    var numberOfBars = numBars(data);

    if (legendSpace > 0) {
        spaceForLegend = legendSpace;
    }
    if (labelSpace > 0) {
        spaceForLabels = labelSpace;
    }
    if (chartH > 0) {
        chartHeight = chartH;
    }
    if (chartH == 'dynamic') {
        chartHeight = numberOfBars * 13;
    }
    if (chartW > 0) {
        chartWidth = chartW - spaceForLabels - spaceForLegend;
    }


    var barHeight       = (chartHeight - gapBetweenGroups * data.series.length) / numberOfBars,
        groupHeight      = barHeight * data.labels.length;

    function findMax(dataset) {
        var max = 0;
        for (var j=0; j<dataset.series.length; j++) {
            for (var i=0; i<dataset.labels.length; i++) {
                var x = Math.max(dataset.series[j].values[i].counts.total, dataset.series[j].values[i].counts.woevi);
                if (x > max){
                    max = x;
                }
            }
        }
        return max;
    }
    function findMin(dataset) {
        var min = dataset.series[0].values[0].counts.total;
        for (var j=0; j<dataset.series.length; j++) {
            for (var i=0; i<dataset.labels.length; i++) {
                var x = dataset.series[j].values[i].counts.total;
                if (x < min && x > 0){ // exclude negative values and 0 (e.g. if no real data is available)
                    min = x;
                }
                var y = dataset.series[j].values[i].counts.woevi;
                if (y < min && y > 0){ // exclude negative values and 0 (e.g. if no real data is available)
                    min = y;
                }
            }
        }
        return min;
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
    function calcXScaleOffset(minValue) {
        return Math.pow(10, Math.floor(Math.log10(minValue)));
    }

    var maxDataValue = findMax(data);
    var minDataValue = findMin(data);
    var xScaleOffset = calcXScaleOffset(minDataValue);


// Set up the scales
    // Colour scale for main bar (entries with evidence)
    var color = d3.scale.ordinal().range(["#6b486b", "#7b6888", "#8a89a6", "#98abc5"]);
    // Colour scale for stacked bar (entries without evidence)
    var color2 = d3.scale.ordinal().range(["#826382", "#988BA1", "#B3B3C4", "#C6D2E2"]);
    // scale for x values
    //var xScale = d3.scale.linear()
    var xScale = d3.scale.log()
        .domain([xScaleOffset, maxDataValue])
        .range([0, chartWidth]);

    var xAxis = d3.svg.axis()
        .scale(xScale)
        .orient("bottom")
        .ticks(10, ",.1s"); // for log scale (remove for linear scale)

// Create the chart

    // Create the chart area in the HTML placeholder element
    var chart = d3.select(selector)
        .attr("width", spaceForLabels + chartWidth + spaceForLegend)
        .attr("height", chartHeight+axisPadding);

    // remove the loading placeholder if there is one
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
        })
        .attr("transform", function(d, i) {
            return "translate(0," + (i * barHeight) + ")";
        });

    // Add the rectangles to the bar groups
    bars.append("rect")
        .attr("fill", function(d,i) {return color(i % data.labels.length); })
        .attr("width", function(d) {
            var x = xScale(d.counts.total - d.counts.woevi);
            return x;
        })
        .attr("height", barHeight - 1)
        .attr("bar", function(d){
            return (d.counts.total - d.counts.woevi);
        });
    bars.append("rect")
        .attr("fill", function(d,i) {return color2(i % data.labels.length); })
        .attr("width", function(d) {
            var x = xScale(d.counts.total);
            var y = xScale(d.counts.total - d.counts.woevi);
            return (x-y);
        })
        .attr("height", barHeight - 1)
        .attr("transform", function(d, i) {
            var x = xScale(d.counts.total - d.counts.woevi);
            return "translate("+ x +",0)";
        })
        .attr("bar", function(d){
            return d.counts.woevi;
        });

    // Add the text label to the bar groups
    bars.append("text")
        .attr("x", function(d) {
            var tmp = d.counts.total;
            return xScale(tmp) + 5;
        })
        .attr("y", barHeight / 2)
        .attr("dy", ".35em")
        .text(function(d) { return d.counts.total; });

    bars.append("text")
        .attr("class", "sub_bar")
        .attr("x", function(d) {
            var tmp = (d.counts.total - d.counts.woevi);
            return (xScale(tmp) / 2);
        })
        .attr("y", barHeight / 2)
        .attr("dy", ".35em")
        .text(function(d) { return (d.counts.total- d.counts.woevi); });

    bars.append("text")
        .attr("class", "sub_bar")
        .attr("x", function(d) {
            var x = xScale(d.counts.total);
            var y = xScale(d.counts.total - d.counts.woevi);
            return (x - ((x-y) / 2));
        })
        .attr("y", barHeight / 2)
        .attr("dy", ".35em")
        .text(function(d) {
            if (d.counts.woevi>0) {
                return d.counts.woevi
            } else {
                return '';
            }
        });

    // Add mouse listeners to the bar groups
    bars.on("mouseover", function(d) {
        bars.attr("fade_out", true);
        d3.select(this)
            .attr("fade_out", null);
        var totalNo = d.counts.total;
        var unmNo = d.counts.woevi;
        var labelId = d3.select(this).attr("dataType");
        var dataType = data.labels[labelId];

        var translate = d3.transform(d3.select(this).attr("transform")).translate;
        var parentTranslate = d3.transform(d3.select(this.parentNode).attr("transform")).translate;

        var tooltip = d3.select("#tooltip");
        tooltip.style("left", (parentTranslate[0]+translate[0]+tooltipOffset) + "px");
        tooltip.style("top", (parentTranslate[1]+translate[1]) + "px");
        tooltip.select("#dataType").text(dataType);
        tooltip.select("#wEvi").text(totalNo-unmNo);
        tooltip.select("#woEvi").text(unmNo);
        tooltip.select("#value").text(totalNo);
        if (labelId == 0) {
            tooltip.select("#details").classed("hidden", true);
        } else {
            tooltip.select("#details").classed("hidden", false);
        }

        d3.select("#tooltip").classed("hidden", false);
    });
    bars.on("mouseout", function() {
        bars.attr("fade_out", null);
        d3.select("#tooltip").classed("hidden", true);
    });
    bars.on("click", function() {
        var seriesId = d3.select(this.parentNode).attr("series");
        var labelId = d3.select(this).attr("dataType");
        var url = getUrl(labelId, seriesId);
        //console.log("url: " + url);
        window.location.assign(url);
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
        bars.attr("fade_out", true);
        d3.selectAll(".bar_"+index)
            .attr("fade_out", null);
    });
    legend.on("mouseout", function(){
        bars.attr("fade_out", null);
    });
    legend.on("click", function() {
        var labelId = d3.select(this).attr("label");
        var url = getUrl(labelId);
        //console.log(url);
        window.location.assign(url);
    });

    chart.append("g")
        .call(xAxis)
        .attr("class", "axis")
        .attr("transform", function() {
            return "translate(" + spaceForLabels + ","+(chartHeight)+")";
        });

    function getUrl(labelId, seriesId) {
        var url = "/browse/" + data.urlPath[parseInt(labelId)];
        if (seriesId >= 0) {
            url += '?speciesFilter=' + data.series[parseInt(seriesId)].taxid;
        }
        return url;
    }
}
