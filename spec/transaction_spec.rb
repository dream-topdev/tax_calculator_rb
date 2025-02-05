require 'rspec'
require_relative '../lib/transaction'

RSpec.describe Transaction do
  it 'validates positive amount' do
    expect {
      Transaction.new(
        types: ['good'],
        amount: -100,
        buyer_country: 'ES'
      )
    }.to raise_error(Errors::InvalidAmountError)
  end
end