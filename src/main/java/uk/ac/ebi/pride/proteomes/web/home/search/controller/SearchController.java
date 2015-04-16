package uk.ac.ebi.pride.proteomes.web.home.search.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.solr.core.query.result.FacetFieldEntry;
import org.springframework.data.solr.core.query.result.SolrResultPage;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import uk.ac.ebi.pride.proteomes.index.model.PeptiForm;
import uk.ac.ebi.pride.proteomes.index.model.SolrPeptiForm;
import uk.ac.ebi.pride.proteomes.index.service.ProteomesSearchService;
import uk.ac.ebi.pride.proteomes.web.home.common.ProteomesController;

import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * @author Florian Reisinger
 * @since 0.1
 */
@Controller
public class SearchController extends ProteomesController {

    // NOTE: these have to be the same as in the custom JSP tags 'inputDefaultParams.tag' and 'hrefSearch.tag'
    private static final int PAGE_SIZE = 10;
    private static final int PAGE_NUMBER = 0;

    @Autowired
    private ProteomesSearchService proteomesSearchService;


    @RequestMapping(value = {"/search"}, method = RequestMethod.GET)
    @ResponseStatus(HttpStatus.OK)
    public String search2(@RequestParam(value = "query", defaultValue = "")
                          String query,
                          @PageableDefault(page = PAGE_NUMBER, value = PAGE_SIZE)
                          Pageable page,
                          @RequestParam(value = "speciesFilter", defaultValue = "")
                          int[] taxidFilter,
                          Model model) {

        Set<Integer> selectedSpeciesFilters = null;
        Map<Integer, Long> availableSpeciesFilters = proteomesSearchService.getTaxidFacetsByQuery(query);

        if (taxidFilter != null && taxidFilter.length > 0) {
            selectedSpeciesFilters = new HashSet<Integer>(taxidFilter.length);
            for (int speciesTaxId : taxidFilter) {
                selectedSpeciesFilters.add(speciesTaxId);
                // we remove the already selected option from the available filters
                // since it is already selected, it does not make sense to present it as an option
                availableSpeciesFilters.remove(speciesTaxId);
            }
        }

        // for now: hard coded sort order...
        Pageable page2 = new PageRequest(page.getPageNumber(), page.getPageSize(), Sort.Direction.ASC, SolrPeptiForm.PEPTIFORM_SEQUENCE);

        Page<PeptiForm> resultPage = proteomesSearchService.findByQueryAndFilterTaxid(query, selectedSpeciesFilters, page2);

        // push the results into the model
        model.addAttribute("peptiformPage", resultPage);
        model.addAttribute("query", query);
        // return species filters
        model.addAttribute("speciesFilters", selectedSpeciesFilters);
        model.addAttribute("availableSpeciesList", availableSpeciesFilters);

        return "searchResults";
    }


    @RequestMapping(value = {"/proteins"}, method = RequestMethod.GET)
    @ResponseStatus(HttpStatus.OK)
    public String proteinBrowser(@PageableDefault(page = PAGE_NUMBER, value = PAGE_SIZE)
                                 Pageable page,
                                 @RequestParam(value = "speciesFilter", defaultValue = "")
                                 int[] taxidFilter,
                                 Model model) {


        Set<Integer> selectedSpeciesFilters = null;
        Map<Integer, Long> availableSpeciesFilters = proteomesSearchService.getTaxidFacets();

        if (taxidFilter != null && taxidFilter.length > 0) {
            selectedSpeciesFilters = new HashSet<Integer>(taxidFilter.length);
            for (int speciesTaxId : taxidFilter) {
                selectedSpeciesFilters.add(speciesTaxId);
                // we remove the already selected option from the available filters, because if
                // it's already selected, it doesn't make sense to present it again as an option
                availableSpeciesFilters.remove(speciesTaxId);
            }
        }

        Sort tempSort = null;
        boolean sortByIndex = false;
        // if the sort should be based on the index, we create a Sort accordingly,
        // otherwise we stick with the default
        if (page.getSort() != null && page.getSort().getOrderFor("index") != null) {
            sortByIndex = true;
            tempSort = new Sort(new Sort.Order(Sort.Direction.DESC, "index"));
        }

        Page<FacetFieldEntry> facetPage = proteomesSearchService.getProteinCountsBySpecies(selectedSpeciesFilters, page.getPageNumber(), page.getPageSize(), sortByIndex);


        PageRequest pageRequest = new PageRequest(page.getPageNumber(), page.getPageSize(), tempSort);
        SolrResultPage<FacetFieldEntry> resultPage = new SolrResultPage<FacetFieldEntry>(facetPage.getContent(), pageRequest, facetPage.getTotalElements(), 0.0f);

        model.addAttribute("facetPage", resultPage);
        model.addAttribute("speciesFilters", selectedSpeciesFilters);
        model.addAttribute("availableSpeciesList", availableSpeciesFilters);

        return "proteinListing";
    }


    @RequestMapping(value = {"/upgroups"}, method = RequestMethod.GET)
    @ResponseStatus(HttpStatus.OK)
    public String upGroupBrowser(@PageableDefault(page = PAGE_NUMBER, value = PAGE_SIZE)
                                 Pageable page,
                                 @RequestParam(value = "speciesFilter", defaultValue = "")
                                 int[] taxidFilter,
                                 Model model) {


        Set<Integer> selectedSpeciesFilters = null;
        Map<Integer, Long> availableSpeciesFilters = proteomesSearchService.getTaxidFacets();

        if (taxidFilter != null && taxidFilter.length > 0) {
            selectedSpeciesFilters = new HashSet<Integer>(taxidFilter.length);
            for (int speciesTaxId : taxidFilter) {
                selectedSpeciesFilters.add(speciesTaxId);
                // we remove the already selected option from the available filters, because if
                // it's already selected, it doesn't make sense to present it again as an option
                availableSpeciesFilters.remove(speciesTaxId);
            }
        }

        Sort tempSort = null;
        boolean sortByIndex = false;
        // if the sort should be based on the index, we create a Sort accordingly,
        // otherwise we stick with the default
        if (page.getSort() != null && page.getSort().getOrderFor("index") != null) {
            sortByIndex = true;
            tempSort = new Sort(new Sort.Order(Sort.Direction.DESC, "index"));
        }

        Page<FacetFieldEntry> facetPage = proteomesSearchService.getUPGroupCountsBySpecies(selectedSpeciesFilters, page.getPageNumber(), page.getPageSize(), sortByIndex);


        PageRequest pageRequest = new PageRequest(page.getPageNumber(), page.getPageSize(), tempSort);
        SolrResultPage<FacetFieldEntry> resultPage = new SolrResultPage<FacetFieldEntry>(facetPage.getContent(), pageRequest, facetPage.getTotalElements(), 0.0f);

        model.addAttribute("facetPage", resultPage);
        model.addAttribute("speciesFilters", selectedSpeciesFilters);
        model.addAttribute("availableSpeciesList", availableSpeciesFilters);

        return "upgroupListing";
    }


    @RequestMapping(value = {"/genes"}, method = RequestMethod.GET)
    @ResponseStatus(HttpStatus.OK)
    public String geneBrowser(@PageableDefault(page = PAGE_NUMBER, value = PAGE_SIZE)
                                 Pageable page,
                                 @RequestParam(value = "speciesFilter", defaultValue = "")
                                 int[] taxidFilter,
                                 Model model) {


        Set<Integer> selectedSpeciesFilters = null;
        Map<Integer, Long> availableSpeciesFilters = proteomesSearchService.getTaxidFacets();

        if (taxidFilter != null && taxidFilter.length > 0) {
            selectedSpeciesFilters = new HashSet<Integer>(taxidFilter.length);
            for (int speciesTaxId : taxidFilter) {
                selectedSpeciesFilters.add(speciesTaxId);
                // we remove the already selected option from the available filters, because if
                // it's already selected, it doesn't make sense to present it again as an option
                availableSpeciesFilters.remove(speciesTaxId);
            }
        }

        Sort tempSort = null;
        boolean sortByIndex = false;
        // if the sort should be based on the index, we create a Sort accordingly,
        // otherwise we stick with the default
        if (page.getSort() != null && page.getSort().getOrderFor("index") != null) {
            sortByIndex = true;
            tempSort = new Sort(new Sort.Order(Sort.Direction.DESC, "index"));
        }

        Page<FacetFieldEntry> facetPage = proteomesSearchService.getGeneGroupCountsBySpecies(selectedSpeciesFilters, page.getPageNumber(), page.getPageSize(), sortByIndex);


        PageRequest pageRequest = new PageRequest(page.getPageNumber(), page.getPageSize(), tempSort);
        SolrResultPage<FacetFieldEntry> resultPage = new SolrResultPage<FacetFieldEntry>(facetPage.getContent(), pageRequest, facetPage.getTotalElements(), 0.0f);

        model.addAttribute("facetPage", resultPage);
        model.addAttribute("speciesFilters", selectedSpeciesFilters);
        model.addAttribute("availableSpeciesList", availableSpeciesFilters);

        return "geneListing";
    }

}
