package uk.ac.ebi.pride.proteomes.web.home.release.controller;


import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseStatus;
import uk.ac.ebi.pride.proteomes.web.ApiException;
import uk.ac.ebi.pride.proteomes.web.ReleasecontrollerApi;
import uk.ac.ebi.pride.proteomes.web.client.ReleaseSummary;
import uk.ac.ebi.pride.proteomes.web.client.ReleaseSummaryList;
import uk.ac.ebi.pride.proteomes.web.home.common.ProteomesController;

/**
 * @author ntoro
 * @since 13/04/2016 18:09
 */
@Controller
public class ReleaseController extends ProteomesController {

    @RequestMapping(value = {"/release"}, method = RequestMethod.GET)
    @ResponseStatus(HttpStatus.OK)
    @SuppressWarnings("unused")
    public String releasePage(Model model) {

        ReleasecontrollerApi apiInstance = new ReleasecontrollerApi();
        try {
            ReleaseSummaryList result = apiInstance.getReleaseSummaryUsingGET();

            model.addAttribute("releaseSummaries", result.getReleaseSummaryList());

        } catch (ApiException e) {
            System.err.println("Exception when calling ReleasecontrollerApi#getReleaseSummaryUsingGET");
            e.printStackTrace();
        }


        return "releasePage";
    }

    @RequestMapping(value = "release/{species}", method = RequestMethod.GET)
    public String getProjectSummary(@PathVariable String species, Model model) {

        ReleasecontrollerApi apiInstance = new ReleasecontrollerApi();
        try {
            ReleaseSummary result = apiInstance.getReleaseSummaryForSpeciesUsingGET1(species);

            model.addAttribute("releaseSummary", result);

        } catch (ApiException e) {
            System.err.println("Exception when calling ReleasecontrollerApi#getReleaseSummaryForSpeciesUsingGET1");
            e.printStackTrace();
        }

        return "releaseSpeciesPage";
    }


}
