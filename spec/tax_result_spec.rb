require 'rspec'
require_relative '../lib/tax_result'

RSpec.describe TaxResult do
  it 'stores amount and type' do
    result = TaxResult.new(amount: 21, type: 'vat')
    expect(result.amount).to eq(21)
    expect(result.type).to eq('vat')
  end
end