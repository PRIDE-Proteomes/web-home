package uk.ac.ebi.pride.proteomes.web.home.common;

import uk.ac.ebi.pride.proteomes.search.common.SearchField;

import java.util.LinkedList;
import java.util.List;

/**
 * @author Florian Reisinger
 *         Date: 14/02/14
 * @since $version
 */
public class SolrQueryBuilder {


    public static String buildQueryFields() {
        return  SearchField.PROTEIN_ACCESSION.getIndexFieldName() + " " +
                SearchField.PROTEIN_DESCRIPTION.getIndexFieldName() + " " +
                SearchField.PROTEIN_SPECIES_NAME.getIndexFieldName() + " " +
                SearchField.PROTEIN_TAXID.getIndexFieldName() + " " +
                SearchField.PROTEIN_SEQUENCE.getIndexFieldName() + " " +
                SearchField.PROTEIN_RATING.getIndexFieldName() + " ";
    }


    public static String buildQueryTerm(String term) {
        if (term == null || term.trim().isEmpty()) { return "*"; }
        else { return term; }
    }


    public static String[] buildQueryFilters(List<String> speciesFilterList) {

         LinkedList<String> queryFilterList = new LinkedList<String>();

         if (speciesFilterList != null) {
             for (String filter : speciesFilterList) {
                 // allow search terms to be searched against species names and taxIDs
                 // this is not needed for the filter values provided by the web front-end
                 // but allows a more flexible search (for example: via the URL directly)
                 queryFilterList.add(
                         SearchField.PROTEIN_SPECIES_NAME.getIndexFieldName() + ":\"" + filter + "\" OR " +
                         SearchField.PROTEIN_TAXID.getIndexFieldName() + ":\"" + filter + "\""
                 );
             }
         }

        return queryFilterList.toArray(new String[queryFilterList.size()]);
    }


}
