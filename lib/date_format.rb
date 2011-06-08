module Intranet
  module DateFormat
    private

    def format_input_date(value)
      value.is_a?(String) ? value.gsub("/", "-") : value
    end
  end
end
