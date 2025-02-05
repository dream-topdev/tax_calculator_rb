module Errors
  class TaxCalculationError < StandardError; end
  class InvalidCountryError < TaxCalculationError; end
  class InvalidAmountError < TaxCalculationError; end
  class MissingTaxRateError < TaxCalculationError; end
  class InvalidServiceLocationError < TaxCalculationError; end
end 