class TaxResult
  attr_reader :amount, :type

  def initialize(amount:, type:)
    @amount = amount
    @type = type
  end
end 