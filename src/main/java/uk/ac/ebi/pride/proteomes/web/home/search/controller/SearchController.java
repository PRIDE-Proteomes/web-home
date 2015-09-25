package uk.ac.ebi.pride.proteomes.web.home.search.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import uk.ac.ebi.pride.proteomes.index.model.SolrPeptiform;
import uk.ac.ebi.pride.proteomes.index.service.ProteomesSearchService;
import uk.ac.ebi.pride.proteomes.web.home.common.ProteomesController;

import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @author Florian Reisinger
 * @since 0.1
 */
@Controller
public class SearchController extends ProteomesController {


    @Autowired
    private ProteomesSearchService proteomesSearchService;

    private Pattern upPattern = Pattern.compile("[OPQ][0-9][A-Z0-9]{3}[0-9]|[A-NR-Z][0-9]([A-Z][A-Z0-9]{2}[0-9]){1,2}");


    @RequestMapping(value = {"/search"}, method = RequestMethod.GET)
    @ResponseStatus(HttpStatus.OK)
    public String search(@RequestParam(value = "query", defaultValue = "")
                             String query,
                         @PageableDefault(page = PAGE_NUMBER, value = PAGE_SIZE)
                         Pageable page,
                         @RequestParam(value = "speciesFilter", defaultValue = "")
                         int[] taxidFilter,
                         Model model) {

        // ToDo: one possibility to redirect if we detect a UP accession
        //       problem: not possibility to decide on which data to see (peptiforms, proteins, protein groups)
        // better: split search results into categories (e.g. peptiforms, proteins, up groups, genes)
        //         and use a refactored result page with sections for hits in each category
        query = query.trim();
        Matcher m = upPattern.matcher(query);
        if (m.matches()) {
            // looks like we have a UP accession as search term, now check if we have actual data for it
            long numPeptiforms = proteomesSearchService.countByProtein(query);
            if (numPeptiforms > 0) {
                // we have a record for this UP accession, so we can redirect to the detailed view
                return "redirect:/viewer/#protein="+query;
            }
        }


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
        Pageable page2 = new PageRequest(page.getPageNumber(), page.getPageSize(), Sort.Direction.ASC, SolrPeptiform.PEPTIFORM_SEQUENCE);

        Page<SolrPeptiform> resultPage = proteomesSearchService.findByQueryAndFilterTaxid(query, selectedSpeciesFilters, page2);

        // push the results into the model
        model.addAttribute("peptiformPage", resultPage);
        model.addAttribute("query", query);
        // return species filters
        model.addAttribute("speciesFilters", selectedSpeciesFilters);
        model.addAttribute("availableSpeciesList", availableSpeciesFilters);

        return "searchResults";
    }

}
