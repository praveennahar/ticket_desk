module ApplicationHelper
  def rupees(amount)
    amount ? "Rs #{amount.to_i}" : "-"
  end

  def bus_tag(bus)
    "#{bus.ac? ? 'AC' : 'Non-AC'} #{bus.sleeper? ? 'Sleeper' : 'Seater'}"
  end
end
