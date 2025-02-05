module Config
  # Company's base country
  BASE_COUNTRY = 'ES'.freeze

  # Tax types
  TAX_TYPES = {
    VAT: 'vat',
    REVERSE_CHARGE: 'reverse_charge',
    EXPORT: 'export',
    NO_TAX: 'no_tax'
  }.freeze

  # Transaction types
  TRANSACTION_TYPES = {
    GOOD: 'good',
    SERVICE: 'service',
    DIGITAL: 'digital',
    ONSITE: 'onsite'
  }.freeze
end 