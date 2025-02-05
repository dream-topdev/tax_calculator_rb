require_relative 'config'
require_relative 'errors'

class Transaction
  VALID_TYPES = [
    Config::TRANSACTION_TYPES[:GOOD],
    Config::TRANSACTION_TYPES[:SERVICE],
    Config::TRANSACTION_TYPES[:DIGITAL],
    Config::TRANSACTION_TYPES[:ONSITE]
  ].freeze
  
  attr_reader :types, :amount, :buyer_country, :buyer_is_company, :service_location

  def initialize(types:, amount:, buyer_country:, buyer_is_company: false, service_location: nil)
    @types = Array(types)
    @amount = amount
    @buyer_country = buyer_country.upcase
    @buyer_is_company = buyer_is_company
    @service_location = service_location&.upcase

    validate_types!
    validate_amount!
    validate_buyer_country!
    validate_service_location! if onsite?
  end

  def buyer_is_company?
    @buyer_is_company
  end

  def good?
    types.include?(Config::TRANSACTION_TYPES[:GOOD])
  end

  def service?
    types.include?(Config::TRANSACTION_TYPES[:SERVICE])
  end

  def digital?
    types.include?(Config::TRANSACTION_TYPES[:DIGITAL])
  end

  def onsite?
    types.include?(Config::TRANSACTION_TYPES[:ONSITE])
  end

  private

  def validate_amount!
    raise Errors::InvalidAmountError, "Amount must be positive" unless amount.positive?
  end

  def validate_buyer_country!
    raise Errors::InvalidCountryError, "Buyer country code cannot be empty" if buyer_country.nil? || buyer_country.empty?
    raise Errors::InvalidCountryError, "Invalid country code format" unless buyer_country.match?(/^[A-Z]{2}$/)
  end

  def validate_service_location!
    return unless service_location
    raise Errors::InvalidServiceLocationError, "Invalid service location format" unless service_location.match?(/^[A-Z]{2}$/)
  end

  def validate_types!
    invalid_types = types - VALID_TYPES
    raise ArgumentError, "Invalid types: #{invalid_types.join(', ')}" if invalid_types.any?
    
    if good? && (digital? || onsite?)
      raise ArgumentError, "A transaction cannot be both a good and a service"
    end
    
    if digital? && !service?
      raise ArgumentError, "Digital transactions must be marked as service"
    end
    
    if onsite? && !service?
      raise ArgumentError, "Onsite transactions must be marked as service"
    end
  end
end 