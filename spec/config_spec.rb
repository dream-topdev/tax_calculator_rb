require 'rspec'
require_relative '../lib/config'

RSpec.describe Config do
  it 'has base country defined' do
    expect(Config::BASE_COUNTRY).to eq('ES')
  end

  it 'has valid tax types' do
    expect(Config::TAX_TYPES[:VAT]).to eq('vat')
    expect(Config::TAX_TYPES[:REVERSE_CHARGE]).to eq('reverse_charge')
  end

  it 'has valid transaction types' do
    expect(Config::TRANSACTION_TYPES[:GOOD]).to eq('good')
    expect(Config::TRANSACTION_TYPES[:SERVICE]).to eq('service')
  end
end