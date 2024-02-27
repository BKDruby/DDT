class PageSerializer
  def initialize(page, fields)
    @page = page
    @meta = fields[:meta]
    @fields = fields.except(:meta).to_h
  end

  def as_json
    scrape_fields.merge(scrape_meta)
  end

  private

  attr_reader :page, :fields, :meta

  def scrape_fields
    return {} if fields.blank?

    fields.each_with_object({}) do |(key, css_selector), data|
      data[key] = page.selector_text(css_selector)
    end
  end

  def scrape_meta
    return {} if meta.blank?

    meta.each_with_object({}) do |meta_tag, meta_data|
      meta_data[meta_tag] = page.meta_tag_content(meta_tag)
    end
  end
end