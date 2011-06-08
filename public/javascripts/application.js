$(document).ready(function() {

    /* Date Picker */
    if (!jQuery.isEmptyObject($(".datepicker")[0]))
    {
       $(".datepicker").datepicker($.datepicker.regional['ca']);
       $(".datepicker").datepicker();
    }

    /* Elastic textarea */
    $("textarea").elastic();

    /* Tasks */
    $(".show_next_div").click(function() {
      if($(this).next().css("display") == "none")
      {
        $(this).next().show();
        $(this).html($(this).html().replace("+","-"));
      }
      else
      {
        $(this).next().hide();
        $(this).html($(this).html().replace("-","+"));
      }
    });

    /* Tasks :: Form */
    $(".show_detalls").click(function() {
      if($(this).next().css("display") == "none")
      {
        $(this).next().fadeIn();
        $(this).html("-Detalls");
        $(this).parent().parent().css("height", "515px");
      }
      else
      {
        $(this).next().fadeOut();
        $(this).html("+Detalls");
        $(this).parent().parent().css("height", "100px");
      }
    });

    /* Tasks :: Sortable */
      $(".task_list_items_uncompleted").bind( "sortupdate", function(event, ui) {
        $(ui.item).effect("highlight", {}, 1500);
        $(ui.item).parent().children().children(".position").each(function(index) {
          $(this).html(index + 1);
        });
      });


    /* Color Selectors */
    $(".colorbox").click(function() {
      colorbox = document.getElementById(this.id);
      var chosencolor = colorbox.getAttribute("data-color");
      document.getElementById("color_text_field").value = chosencolor;
      document.getElementById("color_text_field").background = chosencolor;
    });

    /* Milestones options in Calendars */
    $(".full-calendar td").hover(function() {
      $(this).find(".action-img").show();
    }, function() {
      $(this).find(".action-img").hide();
    });

    /* Purr flash notices */
    $(".notice").purr();
    $("#errorExplanation").purr();

    /* Activate Facebox */
    $('a[rel*=facebox]').facebox();

    /* Activate highlight */
    hljs.initHighlightingOnLoad();

    /* Activating Best In Place */
    $(".best_in_place").best_in_place();
});

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

/**
*Funció auxiliar per veure continguts de variables objecte. Del rollo .inspect() o print_r()
*/

  function inspect(obj, maxLevels, level)
  {
    var str = '', type, msg;

      // Start Input Validations
      // Don't touch, we start iterating at level zero
      if(level == null)  level = 0;

      // At least you want to show the first level
      if(maxLevels == null) maxLevels = 1;
      if(maxLevels < 1)
          return '<font color="red">Error: Levels number must be > 0</font>';

      // We start with a non null object
      if(obj == null)
      return '<font color="red">Error: Object <b>NULL</b></font>';
      // End Input Validations

      // Each Iteration must be indented
      str += '<ul>';

      // Start iterations for all objects in obj
      for(property in obj)
      {
        try
        {
            // Show "property" and "type property"
            type =  typeof(obj[property]);
            str += '<li>(' + type + ') ' + property +
                   ( (obj[property]==null)?(': <b>null</b>'):('')) + '</li>';

            // We keep iterating if this property is an Object, non null
            // and we are inside the required number of levels
            if((type == 'object') && (obj[property] != null) && (level+1 < maxLevels))
            str += inspect(obj[property], maxLevels, level+1);
        }
        catch(err)
        {
          // Is there some properties in obj we can't access? Print it red.
          if(typeof(err) == 'string') msg = err;
          else if(err.message)        msg = err.message;
          else if(err.description)    msg = err.description;
          else                        msg = 'Unknown';

          str += '<li><font color="red">(Error) ' + property + ': ' + msg +'</font></li>';
        }
      }

        // Close indent
        str += '</ul>';

      return str;
  }


/* Generic Hash/Object Merger Function */
Object.extend = function(destination, source) {
  for (var property in source) {
    if (source.hasOwnProperty(property)) {
      destination[property] = source[property];
    }
  }
  return destination;
};

