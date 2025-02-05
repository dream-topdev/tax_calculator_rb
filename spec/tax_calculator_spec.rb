require 'rspec'
require_relative '../lib/tax_calculator'
require_relative '../lib/transaction'
require_relative '../lib/tax_result'
require_relative '../lib/errors'

RSpec.describe TaxCalculator do
  let(:calculator) { TaxCalculator.new }

  describe 'physical goods' do
    it 'applies Spanish VAT for buyers in Spain' do
      transaction = Transaction.new(
        types: ['good'],
        amount: 100,
        buyer_country: 'ES'
      )
      result = calculator.calculate_tax(transaction)
      expect(result.amount).to eq(21)
      expect(result.type).to eq('vat')
    end

    it 'applies reverse charge for EU company buyers' do
      transaction = Transaction.new(
        types: ['good'],
        amount: 100,
        buyer_country: 'FR',
        buyer_is_company: true
      )
      result = calculator.calculate_tax(transaction)
      expect(result.amount).to eq(0)
      expect(result.type).to eq('reverse_charge')
    end

    it 'marks as export for non-EU buyers' do
      transaction = Transaction.new(
        types: ['good'],
        amount: 100,
        buyer_country: 'US'
      )
      result = calculator.calculate_tax(transaction)
      expect(result.amount).to eq(0)
      expect(result.type).to eq('export')
    end
  end
end
