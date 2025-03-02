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

  describe 'digital services' do
    it 'applies Spanish VAT for digital service in Spain' do
      transaction = Transaction.new(
        types: ['service', 'digital'],
        amount: 100,
        buyer_country: 'ES'
      )
      result = calculator.calculate_tax(transaction)
      expect(result.amount).to eq(21)
      expect(result.type).to eq('vat')
    end

    it 'applies local VAT for EU consumer buyers' do
      transaction = Transaction.new(
        types: ['service', 'digital'],
        amount: 100,
        buyer_country: 'FR'
      )
      result = calculator.calculate_tax(transaction)
      expect(result.amount).to eq(20) # French VAT rate
      expect(result.type).to eq('vat')
    end

    it 'applies reverse charge for EU company buyers' do
      transaction = Transaction.new(
        types: ['service', 'digital'],
        amount: 100,
        buyer_country: 'DE',
        buyer_is_company: true
      )
      result = calculator.calculate_tax(transaction)
      expect(result.amount).to eq(0)
      expect(result.type).to eq('reverse_charge')
    end

    it 'applies no tax for non-EU buyers' do
      transaction = Transaction.new(
        types: ['service', 'digital'],
        amount: 100,
        buyer_country: 'US'
      )
      result = calculator.calculate_tax(transaction)
      expect(result.amount).to eq(0)
      expect(result.type).to eq('no_tax')
    end
  end

  describe 'onsite services' do
    it 'applies Spanish VAT for onsite service in Spain' do
      transaction = Transaction.new(
        types: ['service', 'onsite'],
        amount: 100,
        buyer_country: 'FR',
        service_location: 'ES'
      )
      result = calculator.calculate_tax(transaction)
      expect(result.amount).to eq(21)
      expect(result.type).to eq('vat')
    end
  end

  describe 'validation and error handling' do
    it 'raises error for invalid amount' do
      expect {
        Transaction.new(
          types: ['good'],
          amount: -100,
          buyer_country: 'ES'
        )
      }.to raise_error(Errors::InvalidAmountError)
    end

    it 'raises error for invalid country code' do
      expect {
        Transaction.new(
          types: ['good'],
          amount: 100,
          buyer_country: 'ESP'
        )
      }.to raise_error(Errors::InvalidCountryError)
    end

    it 'raises error for invalid type combination' do
      expect {
        Transaction.new(
          types: ['good', 'digital'],
          amount: 100,
          buyer_country: 'ES'
        )
      }.to raise_error(ArgumentError)
    end

    it 'raises error for digital service without service type' do
      expect {
        Transaction.new(
          types: ['digital'],
          amount: 100,
          buyer_country: 'ES'
        )
      }.to raise_error(ArgumentError)
    end
  end
end 