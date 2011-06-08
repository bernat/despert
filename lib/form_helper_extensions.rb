class ActionView::Helpers::FormBuilder
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::FormOptionsHelper
  include ActionView::Helpers::CaptureHelper
  include ActionView::Helpers::AssetTagHelper
  include ActionView::Helpers::RawOutputHelper

  # Accepts an int and displays a smiley based on >, <, or = 0
  def smile_tag(method, options = {})
    value = @object.nil? ? 0 : @object.send(method).to_i
    options[:id] = field_id(method,options[:index])
    smiley = ":-|"
    if value > 0
      smiley = ":-)"
    elsif value < 0
       smiley = ":-("
    end
    return text_field_tag(field_name(method,options[:index]),options) + smiley
  end

  def field_name(label,index=nil)
    output = index ? "[#{index}]" : ''
    return @object_name + output + "[#{label}]"
  end

  def field_id(label,index=nil)
    output = index ? "_#{index}" : ''
    return @object_name + output + "_#{label}"
  end
  
  def wmd_tag(method, options = {})
    out = %{<div class="group" id="wmd">
    	<div id="info">}
    if options[:editor_title] 
      out << @template.label(@object_name, method, options[:editor_title])
    else
      out << @template.label(@object_name, method)
    end
  	out << %{<div id="wmd-container" class="resizable-textarea">
  				<div id="wmd-button-bar"></div>}
  	out << @template.text_area(@object_name, method, :cols => 40, :id => "wmd-input")
  	out <<	%{</div></div><br /><div id="prev">}
    if options[:prev_title]
      out << @template.label(@object_name, method, options[:prev_title])
    else
      out << @template.label(@object_name, method, I18n.t(:preview))
    end
    out << %{<div class="wmd-preview"></div></div></div>}
    return raw(out)
  end

end
