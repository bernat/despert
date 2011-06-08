# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  def title(page_title)
    content_for :title do
      page_title
    end
  end
  
  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end
  
  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end

  def maybe(value)
    value.blank? ? raw("<i>No introduït</i>") : value
  end
  
  def b_sem(bol)
    bol ? "Sí" : "No"
  end
end
