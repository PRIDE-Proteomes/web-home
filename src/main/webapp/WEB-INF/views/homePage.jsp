<%--<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>--%>
<%--<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>--%>


<div id="top" class="grid_24 clearfix">
    <section id="introduction" class="grid_22 prefix_1 suffix_2">
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
    <div id="mouse_img_div" class="grid_10 prefix_1">
        <img id="mouse_img" src="resources/images/mouse-group.png"/>
    </div>
    <div id="mouse_spacer" class="grid_2">
        <p><br/></p>
    </div>
    <div id="mouse_desc" class="grid_10">
        <p class="text-para">
            In PRIDE Proteomes we try to benefit from repeated observations of the same
            data that is available from PRIDE Archive. The Archive hosts datasets from
            experiments done on the same sample, but in different labs, with different
            focus or different points in time.
        </p>
        <p class="text-para">
            The principle behind Proteomes is that the same sample should lead to the
            same identifications, regardless of when, where or by whom the experiments
            are conducted and that by aggregating those data we can establish a good,
            with enough data perhaps even better image of the original sample than an
            individual dataset can.
        </p>
    </div>
</div>

<div class="grid_24">
    <div class="grid_22 prefix_1">
        <p class="text-para">
            <br/>
            Many scientific projects are based on the same biological sample (for
            example: the mouse as model organism). Sample processing and preparation
            protocols as well as the mass spectrometer settings may vary, but are
            based on the same, well established techniques and principles and are
            not fundamentally different. Hence one would expect to see a good deal
            of repetition in the data produced by those projects.
            <br/>
        </p>
    </div>
</div>

<div id="concept" class="grid_24">
    <div id="concept_desc" class="grid_10 prefix_1">
        <p class="text-para">
            Due to many varying factors, the individual mass spectra of an analysis
            will slightly differ between analysis runs, even if the same sample,
            processing steps and machines are used. However, the underlying chemical
            entities, the peptides that is analysed are the same and therefore analysis
            pipelines are expected to agree in the results to a large degree.
        </p>
        <p class="text-para">
            Combining the results from many projects across many labs and purposes,
            PRIDE Proteomes believes that it can distill the vast data quantities held
            in PRIDE Archive into the essence of the underlying data, a list of verified
            <b>PEPTIFORMS</b>. We define this term to be a peptide sequence plus any
            modifications it may carry (including their positions), that could lead to
            a change in its mass spectrum fingerprint and therefore its identification.
        </p>
        <p class="text-para">
            Based on that list of peptiforms Proteomes generates its own 'protein inference'
            mapping the unique peptide sequences onto an up-to-date version of the UniProt
            database as reference. This way we try to eliminate identification errors due
            to changing protein definitions. At this stage peptides that are unique to
            a specific protein can be observed. This unique identification mapping can
            then be increased via protein groups and peptides that are unique to a group
            rather than an individual protein sequence (for example a peptide being unique
            to a UniProt entry or gene, but not unique to a specific isoform of that group).
            <br/>
        </p>
    </div>
    <div id="concept_img_div" class="grid_12">
        <br/>
        <img id="concept_img" src="resources/images/concept-complete-transparent.png"/>
    </div>
</div>

<div id="data_links">

</div>


