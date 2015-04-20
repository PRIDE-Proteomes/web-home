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


    @Autowired
    private ProteomesSearchService proteomesSearchService;


    @RequestMapping(value = {"/search"}, method = RequestMethod.GET)
    @ResponseStatus(HttpStatus.OK)
    public String search(@RequestParam(value = "query", defaultValue = "")
                             String query,
                         @PageableDefault(page = PAGE_NUMBER, value = PAGE_SIZE)
                         Pageable page,
                         @RequestParam(value = "speciesFilter", defaultValue = "")
                         int[] taxidFilter,
                         Model model) {

        return doSearch(query, page, taxidFilter, model);
    }

    // Note: the search functionality is currently limited and is re-used in the
    // peptiform browse option (BrowseController), hence the public method
    public String doSearch(String query, Pageable page, int[] taxidFilter, Model model) {
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

}
