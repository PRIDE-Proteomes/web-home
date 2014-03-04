$(document).ready(function() {

    // set the search box content
    $('[id="local-searchbox"]').val($('[id="query"]').html());

    // add class 'noresults' in case we have no search results
    // this is used by the EBI global search results widget
    if($('[id="noresults"]').size()){
        $('body').addClass('noresults');
    }

});