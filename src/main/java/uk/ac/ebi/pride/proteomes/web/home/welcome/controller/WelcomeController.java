package uk.ac.ebi.pride.proteomes.web.home.welcome.controller;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseStatus;
import uk.ac.ebi.pride.proteomes.web.home.common.ProteomesController;

/**
 * @author Florian Reisinger
 * @since 0.1
 */
@Controller
public class WelcomeController extends ProteomesController {

        @RequestMapping(value = {"/"}, method = RequestMethod.GET)
        @ResponseStatus(HttpStatus.OK)
        @SuppressWarnings("unused")
        public String homePage(Model model) {
            return "homePage";
        }

}
