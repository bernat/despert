# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def StripHtml(str, preserveTags = ['a','i','strong','u'])
       str = str.strip || ''
       preserveArr = preserveTags.join('|') << '|\/'
       str.gsub(/<(\/|\s)*[^(#{preserveArr})][^>]*>/,'')
  end


  def mark_required(object, attribute)
    "*" if object.class.validators_on(attribute).map(&:class).include? ActiveModel::Validations::PresenceValidator
  end

  def pretty_date(date)
    aux = date.to_time < Time.now ? t("date_ago") : t("date_future")
    return "#{aux} #{time_ago_in_words(date.to_time)}"
  end


  # The following fields are required:
  # :first  # The day where the calendar starts.
  # :last   # The day where the calendar finishes. Optional if :weeks is defined
  # :info   # A hash with pairs date -> string containing the info to show for each date
  #
  # The following are optional, available for customizing the default behaviour:
  # :table_class    => "Cal"    # The class for the <table> tag.
  # :weeks          =>  nil     # Number of weeks to show
  def calendar(first, last, info, options = {})
      defaults = {
        :table_class => 'Cal'
      }
      options = defaults.merge options

      cal_ini = first.beginning_of_week
      if last.blank?
        if options[:weeks]
          last = cal_ini + options[:weeks]*7 - 1
        else
          raise ArgumentError, "A weeks argument is mandatory if you don't provide a last date"
        end
      end

      cal_end = last.end_of_week

      days_count = (cal_end - cal_ini).to_i + 1
      @dies = ["Dilluns", "Dimarts", "Dimecres", "Dijous", "Divendres", "Dissabte", "Diumenge"]
      out = "<table cellspacing=\"1\" class=\"#{options[:table_class]}\"><tbody><tr>"
      for dia in @dies do
        out << "<th>#{raw dia}</th>"
      end
      out << "</tr><tr>"

      days_count.times do |i|
        with = false
        ms = ""
        d = cal_ini + i
        if info.has_key?(d)
          with = true
          ms << "<ul>"
          info[d].each do |sd|
            ms << "<li class='milestone-event'>#{sd}</li>"
          end
          ms << "</ul>"
        end
        clases = []
        clases << "with" if with
        clases << "today" if d.today?
        clases << "blank" unless first.month==d.month
        out << "<td id='#{d.strftime("%d-%m-%Y")}' class='#{clases.join(" ")}'>"
        out << "<span class=\"date\">"
        out << raw(d.today? ? "AVUI" : (I18n.l d, :format => :short))
        out << "</span>"
        out << ms
        out << "</td>"
        out << raw(i%7 == 6 ? "</tr><tr>" : "")
      end
      raw out << "</tr></tbody></table>"
  end

  def soft_color(color)
    color.gsub("00", "EE");
  end

  def markdown(text)
    Markdown.new(text).to_html.html_safe
  end

  def show_iva(iva = IVA)
    "#{( iva * 100 ).to_i} %"
  end

  def parent_layout(layout)
    @_content_for[:layout] = self.output_buffer
    self.output_buffer = render(:file => "layouts/#{layout}")
  end

  def resume_text(text, characters=50, ending='...')
    if text.length > characters
      text[1..characters] + ending
    else
      text
    end
  end
end
