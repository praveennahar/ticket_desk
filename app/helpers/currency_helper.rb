module CurrencyHelper
  def rupees(amount)
    amount ? "Rs #{amount.to_i}" : "-"
  end
end
