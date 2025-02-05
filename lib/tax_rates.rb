require_relative 'errors'

class TaxRates
  EU_RATES = {
    'ES' => 0.21,  # Spain
    'FR' => 0.20,  # France
    'DE' => 0.19,  # Germany
    'IT' => 0.22   # Italy
  }.freeze

  def self.get_rate(country_code)
    rate = EU_RATES[country_code.upcase]
    raise Errors::MissingTaxRateError, "No tax rate found for country: #{country_code}" if rate.nil?
    rate
  end
end 