$(document).ready(function() {
  /* Purr flash notices */
  $(".notice").purr();
  $("#errorExplanation").purr();

  /* Activate Facebox */
  $('a[rel*=facebox]').facebox();

  /* Activate highlight */
  hljs.initHighlightingOnLoad();
})


/* Will_paginate */

function formatLinkForPaginationURL() {
  $("div.pagination").find("a").each(function() {
        var linkElement = $( this );
        var paginationURL = linkElement.attr("href");
        linkElement.attr({
             "url": paginationURL,
             "href": "#"
        });

        linkElement.click(function() {
              $("#pagination_display_section").load( $(this).attr('url') );
              return false;
        });
   });
}
