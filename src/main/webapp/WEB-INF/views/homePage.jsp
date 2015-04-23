<%--<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>--%>
<%--<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>--%>


<div id="top" class="grid_24 clearfix">
    <section id="introduction" class="grid_24">
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
</div>

<div id="mouse_part" class="grid_24">
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
</div>

<div class="grid_24">
    <br/><br/>
</div>

<div id="concept_part_archive" class="grid_24">
    <div class="grid_10 alpha">
        <p class="text-para">
            Many scientific projects are based on the same biological sample (for
            example: the mouse as model organism). Sample processing and preparation
            protocols as well as the mass spectrometer settings may vary, but are
            based on the same, well established techniques and principles and are
            not fundamentally different. Hence one would expect to see a good deal
            of repetition in the data produced by those projects. Those data are stored
            in <b>PRIDE Archive</b>.<br/>
            Due to many varying factors, the individual mass spectra of an analysis
            will slightly differ between analysis runs, even if the same sample,
            processing steps and machines are used. However, the underlying chemical
            entities, the peptides that is analysed are the same and therefore analysis
            pipelines are expected to agree in the results to a large degree.
        </p>
    </div>
    <div class="grid_14">
        <img src="resources/images/concept-part-archive-transparent.png"/>
    </div>
</div>
<div id="concept_braket1" class="grid_24">
    <div class="grid_14 push_10">
        <img src="resources/images/braket-transparent.png"/>
    </div>
</div>
<div id="concept_part_cluster" class="grid_24">
    <div class="grid_10 alpha">
        <p class="text-para">
            Aggregating the results from many projects across many labs and purposes,
            <b>PRIDE Cluster</b> believes that it can aggregate the vast data quantities
            held in PRIDE Archive into the essence of the underlying data. It builds on
            the principle that the same molecule will produce the same (or at least very
            similar) spectra across several analysis or projects. By clustering the
            spectra available in PRIDE Archive, PRIDE Cluster tries to distill out the
            real meaningful signals of the spectra and therefore arrive at the correct
            interpretation of the primary data.
        </p>
    </div>
    <div class="grid_14">
        <br/>
        <img src="resources/images/concept-part-cluster-transparent.png"/>
    </div>
</div>
<div id="concept_braket2" class="grid_24">
    <div class="grid_14 push_10">
        <img src="resources/images/braket-transparent.png"/>
    </div>
</div>
<div id="concept_part_proteomes" class="grid_24">
    <div class="grid_10 alpha">
        <p class="text-para">
            <b>PRIDE Proteomes</b> then continues from the results of aggregation resources
            like PRIDE Cluster. It accumulates a list of <b>PEPTIFORMS</b>, which it defines
            to be an amino sequence (traditionally called peptide), any modifications it may
            carry (including their positions) plus the species the data was generated from.
            Based on a that list of peptiforms it generates its own 'protein inference'
            mapping the unique peptide sequences onto an up-to-date version of the UniProt
            database as reference. This way it tries to eliminate identification errors due
            to changing protein definitions. At this stage peptides that are unique to
            a specific protein can be observed. This unique identification mapping can
            then be increased via protein groups and peptides that are unique to a group
            rather than an individual protein sequence (for example a peptide being unique
            to a UniProt entry or gene, but not unique to a specific isoform of that entry/gene).
            <br/>
        </p>
    </div>
    <div class="grid_14">
        <br/><br/>
        <img src="resources/images/concept-part-proteomes-transparent.png"/>
    </div>
</div>

<div id="data_links">

</div>


