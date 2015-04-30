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
        <br/><br/>
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

<div id="bottom" class="grid_24">
    <br/><br/> <%-- spacer to separate the previous from the next section --%>
</div>

<section class="grid_24">
    <section class="grid_8 alpha">
        <h3 class="icon icon-functional" data-icon="4">
            Data Origin
        </h3>
        <p class="text-para">
            Proteomes base data are <b>peptiforms</b>. These are aggregations of peptide
            identifications (PSMs) reported in datasets submitted to <b>PRIDE Achive</b>.
            This aggregation also involves a quality control pipeline that attempts to
            filter out unreliable or inconclusive identifications. At the moment this
            relies on the spectra clustering and scoring approach (see
            <a href="/pride/cluster">PRIDE Cluster</a>) which applies rather restrictive
            criteria resulting in less, but more reliable data.<br/>
            These peptiforms are then mapped onto the reference proteomes of selected
            species from UniProt in order to maintain an up-to-date picture of the
            identified proteins and genes.
        </p>
    </section>
    <section class="grid_8">
        <h3 class="icon icon-functional" data-icon="4">
            Data Updates
        </h3>
        <p class="text-para">
            Proteomes is not updated continuously, but on a regular release basis roughly
            following new releases from UniProt.<br/>
            Currently only a few model <b>organisms</b> are supported, but plans exist
            to expand this list over time. Which species will be supported will depend on
            the available identification data, proteome datasets and the demand for it from
            the community. If you want a specific species to be added, please don't hesitate
            to send us your
            <a href="mailto:pride-support@ebi.ac.uk?Subject=PRIDE%20Proteomes%20species%20request">
                request
            </a>.
        </p>
    </section>
    <section class="grid_8 omega">
        <h3 class="icon icon-functional" data-icon="4">
            Data Access
        </h3>
        <p class="text-para">
            There are two main ways to access the data, this <b>web interface</b> and
            a <b>web service</b>.<br/>
            The web interface features search, browse and viewing functionalities and
            generates detailed links so search results and detailed views are bookmarkable
            and shareable between multiple parties.<br/>
            The <a href="/pride/ws/proteomes">RESTful web service</a> provides programmatic
            access and data retrieval services. It follows state of the art technologies and
            comes with an extensive interactive documentation.
        </p>
    </section>
</section>



