package uk.ac.ebi.pride.proteomes.web.home.common;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * @author Antonio Fabregat <fabregat@ebi.ac.uk>
 * @author Florian Reisinger
 * @since 0.1
 */
public abstract class ProteomesController {

    // NOTE: these have to be the same as in the custom JSP tags 'inputDefaultParams.tag' and 'hrefSearch.tag'
    protected static final int PAGE_SIZE = 10;
    protected static final int PAGE_NUMBER = 0;


    /**
     * Generic Exception Handler that catches an exception that is not explicitly handled otherwise.
     * NOTE: Response Status will be set to: INTERNAL_SERVER_ERROR(500, "Internal Server Error")
     *
     * @param e the Exception to handle.
     * @return The exception's message.
     */
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    @ResponseBody
    @ExceptionHandler(Exception.class)
    public String handleException(Exception e) {
        return e.getMessage();
    }

    // ToDo: handle other exceptions

}
