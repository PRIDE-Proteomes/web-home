package uk.ac.ebi.pride.proteomes.web.home.search.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import uk.ac.ebi.pride.proteomes.search.protein.ProteinSearchResult;
import uk.ac.ebi.pride.proteomes.search.protein.dao.solr.ProteinSearchDaoSolr;
import uk.ac.ebi.pride.proteomes.web.home.common.ProteomesController;
import uk.ac.ebi.pride.proteomes.web.home.common.SolrQueryBuilder;

import java.util.*;

/**
 * @author Florian Reisinger
 * @since 0.1
 */
@Controller
public class SearchController extends ProteomesController {



    @Autowired
    private ProteinSearchDaoSolr proteinSearchDao;

    @RequestMapping(value = {"/search"}, method = RequestMethod.GET)
    @ResponseStatus(HttpStatus.OK)
    public String search(@RequestParam(value = "q", defaultValue = "") String term,
                         @RequestParam(value = "show", defaultValue = "10") int showResults,
                         @RequestParam(value = "page", defaultValue = "1") int page,
                         @RequestParam(value = "sort", defaultValue = "") String sortBy,
                         @RequestParam(value = "order", defaultValue = "") String order,

                         @RequestParam(value = "newSpeciesFilter", defaultValue = "") String newSpeciesFilter,
                         @RequestParam(value = "speciesFilters", defaultValue = "") String[] speciesFilters,

                         Model model) {

        Collection<? extends ProteinSearchResult> proteins = Collections.emptyList();

        // add species filter to list of existing filters (if any)
        ArrayList<String> speciesFilterList = new ArrayList<String>();
        if (speciesFilters != null && speciesFilters.length > 0) {
            speciesFilterList.addAll(Arrays.asList(speciesFilters));
        }
        if (!"".equals(newSpeciesFilter)) {
            speciesFilterList.add(newSpeciesFilter);
        }


        Map<String, Long> availableSpecies = proteinSearchDao.getSpeciesCount(
                                SolrQueryBuilder.buildQueryTerm(term),
                                SolrQueryBuilder.buildQueryFields(),
                                SolrQueryBuilder.buildQueryFilters(speciesFilterList)
                                );



        // process search term, fields and filters
        String queryTerm = SolrQueryBuilder.buildQueryTerm(term);
        String queryFields = SolrQueryBuilder.buildQueryFields();
        String queryFilters[] = SolrQueryBuilder.buildQueryFilters(speciesFilterList);

        // calculate the total number of results we would receive with the current query parameters
        long numResults = proteinSearchDao.numDocuments(queryTerm, queryFields, queryFilters);

        // if we have results, calculate the number of pages for the current page size,
        // and the offset from there we have to start showing/retrieving results
        int numPages = 0;
        if (numResults > 0) {
            numPages = roundUp(numResults, showResults);
            page = (page > numPages) ? numPages : page;
            int start = showResults * (page - 1);

            // then execute the query
            proteins = proteinSearchDao.searchProteins(queryTerm, queryFields, queryFilters,
                                                       start, showResults, sortBy, order);
        }


        // push the results into the model
        model.addAttribute("proteinList", proteins);
        model.addAttribute("q", term);
        model.addAttribute("show", showResults);
        model.addAttribute("page", page);
        model.addAttribute("numPages", numPages);
        model.addAttribute("numResults", numResults);
        model.addAttribute("sort", sortBy);
        model.addAttribute("order", order);
        // return species filters
        model.addAttribute("speciesFilters", speciesFilterList);
        model.addAttribute("availableSpeciesList", availableSpecies);

        return "searchResults";
    }

    private static int roundUp(long num, long divisor) {
        if (divisor == 0) return 0;
        else return (int)((num + divisor - 1) / divisor);
    }

}
