module TripsHelper
  def bus_tag(bus)
    "#{bus.ac? ? 'AC' : 'Non-AC'} #{bus.sleeper? ? 'Sleeper' : 'Seater'}"
  end
end
