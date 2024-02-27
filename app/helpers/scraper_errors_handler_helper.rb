module ScraperErrorsHandlerHelper
  def handle_error(e)
    send(e.class.to_s.tr('::', '').underscore, e)
  end

  def selenium_web_driver_error_unknown_error(error)
    if error.message.include?('ERR_NAME_NOT_RESOLVED')
      raise 'Invalid URL'
    end
  end
end
