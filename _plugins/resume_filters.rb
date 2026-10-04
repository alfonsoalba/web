# Liquid filters used to render the resumes in _data/resumes/.
#
# The resume data files come from a separate repository and are copied here
# unchanged, so these filters adapt to the data's conventions:
# - translatable text is a map keyed by language ({ "en" => "...", ... })
# - text fields may contain inline Markdown
# - dates are "YYYY" or "YYYY-MM" strings, and a nil end date means "present"
module ResumeFilters
  DEFAULT_LANGUAGE = "en".freeze
  MONTHS = %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec].freeze

  # Returns the text for +lang+ from a translatable map, falling back to the
  # default language. Plain strings and nil are returned unchanged.
  def t(input, lang = DEFAULT_LANGUAGE)
    return input unless input.is_a?(Hash)

    lang = DEFAULT_LANGUAGE if lang.nil? || lang.to_s.empty?
    input[lang.to_s] || input[DEFAULT_LANGUAGE]
  end

  # Renders inline Markdown. A single wrapping paragraph is removed so the
  # result can be placed inside list items, spans or headings.
  def inline_md(input)
    return input if input.nil?

    site = @context.registers[:site]
    converter = site.find_converter_instance(Jekyll::Converters::Markdown)
    html = converter.convert(input.to_s).strip
    single_paragraph = html.start_with?("<p>") && html.end_with?("</p>") && html.scan("<p>").length == 1
    single_paragraph ? html[3...-4] : html
  end

  # Formats a "YYYY" / "YYYY-MM" date range, e.g. "Dec 2012 – Present".
  # A nil end date means the entry is ongoing; without a start date there is
  # nothing to show.
  def date_range(start_date, end_date = nil)
    from = format_resume_date(start_date)
    return nil if from.nil?

    to = end_date.nil? ? "Present" : format_resume_date(end_date)
    return from if from == to

    "#{from} – #{to}"
  end

  private

  def format_resume_date(value)
    return nil if value.nil? || value.to_s.empty?

    year, month = value.to_s.split("-")
    month.nil? ? year : "#{MONTHS[month.to_i - 1]} #{year}"
  end
end

Liquid::Template.register_filter(ResumeFilters)
