require_relative 'tax_rates'
require_relative 'config'
class TaxCalculator
  def calculate_tax(transaction)
    return calculate_good_tax(transaction) if transaction.good?
    return calculate_digital_service_tax(transaction) if transaction.digital?
    return calculate_onsite_service_tax(transaction) if transaction.onsite?
  end
  private

  def calculate_good_tax(transaction)
    if transaction.buyer_country == Config::BASE_COUNTRY
      return apply_base_country_vat(transaction)
    elsif eu_country?(transaction.buyer_country)
      return handle_eu_transaction(transaction)
    else
      return handle_non_eu_transaction(transaction)
    end
  end

  def calculate_digital_service_tax(transaction)
    if transaction.buyer_country == Config::BASE_COUNTRY
      return apply_base_country_vat(transaction)
    elsif eu_country?(transaction.buyer_country)
      return handle_eu_transaction(transaction)
    else
      return TaxResult.new(amount: 0, type: Config::TAX_TYPES[:NO_TAX])
    end
  end

  def calculate_onsite_service_tax(transaction)
    if transaction.service_location == Config::BASE_COUNTRY
      return apply_base_country_vat(transaction)
    else
      return TaxResult.new(amount: 0, type: Config::TAX_TYPES[:NO_TAX])
    end
  end

  def apply_base_country_vat(transaction)
    tax_amount = transaction.amount * TaxRates.get_rate(Config::BASE_COUNTRY)
    TaxResult.new(amount: tax_amount, type: Config::TAX_TYPES[:VAT])
  end
    
  def handle_eu_transaction(transaction)
    if transaction.buyer_is_company?
      TaxResult.new(amount: 0, type: Config::TAX_TYPES[:REVERSE_CHARGE])
    else
      rate = TaxRates.get_rate(transaction.buyer_country)
      tax_amount = transaction.amount * rate
      TaxResult.new(amount: tax_amount, type: Config::TAX_TYPES[:VAT])
    end
  end

  def handle_non_eu_transaction(transaction)
    TaxResult.new(amount: 0, type: Config::TAX_TYPES[:EXPORT])
  end

  def eu_country?(country_code)
    TaxRates::EU_RATES.key?(country_code.upcase)
  end
end
