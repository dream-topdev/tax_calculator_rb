require_relative 'config'
require_relative 'errors'

class Transaction  
  attr_reader :types, :amount, :buyer_country, :buyer_is_company, :service_location

  def initialize(types:, amount:, buyer_country:, buyer_is_company: false, service_location: nil)
    @types = Array(types)
    @amount = amount
    @buyer_country = buyer_country.upcase
    @buyer_is_company = buyer_is_company
    @service_location = service_location&.upcase

    validate_amount!
  end

  private

  def validate_amount!
    raise Errors::InvalidAmountError, "Amount must be positive" unless amount.positive?
  end

end 