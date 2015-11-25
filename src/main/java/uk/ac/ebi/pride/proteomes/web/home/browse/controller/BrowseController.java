package uk.ac.ebi.pride.proteomes.web.home.browse.controller;

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
import uk.ac.ebi.pride.proteomes.index.service.ProteomesSearchService;
import uk.ac.ebi.pride.proteomes.web.home.common.ProteomesController;
import uk.ac.ebi.pride.proteomes.web.home.search.controller.SearchController;

import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * @author Florian Reisinger
 * @since 1.1.0
 */
@Controller
public class BrowseController extends ProteomesController {

    @Autowired
    private ProteomesSearchService proteomesSearchService;
    @Autowired
    private SearchController searchController;


    @RequestMapping(value = {"/browse"}, method = RequestMethod.GET)
    @ResponseStatus(HttpStatus.OK)
    public String browse(Model model) {
        return "browsePage";
    }


    @RequestMapping(value = {"/browse/peptiforms"}, method = RequestMethod.GET)
    @ResponseStatus(HttpStatus.OK)
    public String search(@RequestParam(value = "query", defaultValue = "")
                         String query,
                         @PageableDefault(page = PAGE_NUMBER, value = PAGE_SIZE)
                         Pageable page,
                         @RequestParam(value = "speciesFilter", defaultValue = "")
                         int[] taxidFilter,
                         Model model) {

        // do the same as the search (which is based on peptiforms)
        return searchController.doSearch(query, page, taxidFilter, model);
    }

    @RequestMapping(value = {"/browse/proteins"}, method = RequestMethod.GET)
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


    @RequestMapping(value = {"/browse/genes"}, method = RequestMethod.GET)
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
