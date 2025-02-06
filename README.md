# Tax Calculator

Ruby library for international VAT and sales tax calculations.

## Features
- EU VAT calculations
- B2B reverse charge mechanism
- Digital services, physical goods, and onsite services
- Country code and transaction validation

## Usage
```ruby
require 'tax_calculator'

transaction = TaxCalculator::Transaction.new(
  types: ['good', 'onsite'],
  amount: 100,
  buyer_country: 'ES'
)

tax = transaction.calculate_tax
```

## Development
```bash
bundle install
rspec
```
