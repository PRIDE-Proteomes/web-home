<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%--<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>--%>
<%--<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>--%>


<section id="top" class="grid_24 clearfix">
    <h2>
        Introduction
    </h2>
    <p class="text-para">
        PRIDE Proteomes is a protein identification resource based on
        <b title="Observable protein fragments, e.g. unique combinations of
                  an amino acid sequence (traditional peptide definition),
                  any sequence modifications (including their positions) and
                  (for simplicity) the sample species.">peptiforms</b>
        observed in public mass spectrometry datasets. It tries to evaluate
        and aggregate peptide identifications across several public datasets
        and generate a global picture of the available data.
        <br/>
    </p>
</section>

<section id="mouse_part" class="grid_24">
    <div id="mouse_img_div" class="grid_10">
        <img id="mouse_img" src="resources/images/mouse-group.png"/>
    </div>
    <div id="mouse_spacer" class="grid_2">
        <p><br/></p>
    </div>
    <div id="mouse_desc" class="grid_12 omega">
        <p class="text-para">
            PRIDE Proteomes tries to benefit from repeated observations of the same
            data that is available from PRIDE Archive. The Archive hosts datasets from
            experiments done on the same sample, but in different labs, with different
            focus or different points in time.
        </p>
        <p class="text-para">
            The principle behind Proteomes is that the same sample should lead to the
            same identifications, regardless of when, where or by whom the experiments
            are conducted and that by aggregating those data we can establish a good,
            with enough data perhaps even better image of the original sample than an
            individual dataset generally can. Over time Proteomes data will become more
            and more accurate and hopefully will establish a true and complete picture
            of the supported samples. Until then its data can be very useful for result
            validation or the design of targeted approaches.
        </p>
    </div>
</section>

<div class="grid_24">
    <br/><br/> <%-- spacer to separate the previous from the next section --%>
</div>

<section class="grid_24">
    <section class="grid_8 alpha">
        <h3 class="icon icon-functional" data-icon="4">
            Data Browsing
        </h3>
        <spring:url var="browseUrl" value="/browse"/>
        <p class="text-para">
            Please see the <a href="${browseUrl}">Browse</a> page
            for a summary of the data and entry to data views.
        </p>
    </section>
    <section class="grid_8">
        <h3 class="icon icon-functional" data-icon="4">
            Documentation
        </h3>
        <p class="text-para">
            PRIDE Proteomes features extensive
            <a href="/pride/help/proteomes">documentation pages</a>
            explaining various aspects of the project.
        </p>
    </section>
    <section class="grid_8 omega">
        <h3 class="icon icon-functional" data-icon="4">
            Web Service
        </h3>
        <p class="text-para">
            The data in PRIDE Proteomes is accessible via a
            <a href="/pride/ws/proteomes">RESTful web service</a>.
        </p>
    </section>
</section>



