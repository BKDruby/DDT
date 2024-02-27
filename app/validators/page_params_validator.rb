class PageParamsValidator
  FORMATS = {
    'fields' => Hash,
    'fields.meta' => Array
  }

  def initialize(params)
    @params = params.as_json
    @errors = []
  end

  def call
    FORMATS.each do |key, format|
      value = dig_value(key)
      next if value.blank? || value.is_a?(format)

      @errors << "#{key} should be a #{format}"
    end

    @errors
  end

  private

  attr_reader :params

  def dig_value(key)
    params.dig(*key.split('.'))
  rescue TypeError
    nil
  end
end
