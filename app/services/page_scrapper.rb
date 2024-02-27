class PageScrapper
  include ScraperErrorsHandlerHelper
  EXPIRATION_TIME = 24.hours

  def initialize(url)
    @url = url
    load_html
    @page = Nokogiri::HTML(html)
  end

  def selector_text(css_selector)
    page.css(css_selector).text
  end

  def meta_tag_content(meta_tag)
    page.at("meta[name=\"#{meta_tag}\"]")&.attr('content')
  end

  private

  attr_reader :url, :html, :page

  def save_page!
    Page.create_from_html!(url:, html:)
  end

  def load_html
    actual_cached_html || (scrape_html && save_page!)
  end

  def actual_cached_html
    return unless page = Page.where(url:)
                             .find_by("created_at > ?", EXPIRATION_TIME.ago)

    @html = page.html_file.download
  end

  def scrape_html
    client = Watir::Browser.new
    client.goto(url)
    Watir::Wait.until { client.execute_script('return document.readyState') == 'complete' }
    @html = client.html
    client.close
  rescue Selenium::WebDriver::Error::UnknownError => e
    handle_error(e)
  end
end
