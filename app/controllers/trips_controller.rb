class TripsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @cities = (Trip.scheduled.distinct.pluck(:origin) + Trip.scheduled.distinct.pluck(:destination)).uniq.sort
    @from = params[:from].presence
    @to = params[:to].presence
    @on = params[:on].present? ? Date.parse(params[:on]) : Time.zone.today + 1

    if @from && @to && @on
      @trips = SearchTrips.run(
        from: @from,
        to: @to,
        on: @on,
        min_rating: params[:min_rating].presence,
        min_price: params[:min_price].presence,
        max_price: params[:max_price].presence,
        ac_type: params[:ac_type].presence,
        layout_type: params[:layout_type].presence,
        amenity: params[:amenity].presence
      )
    else
      @trips = []
    end
  rescue Date::Error
    @trips = []
    flash.now[:alert] = "that date looks off"
  end

  def show
    @trip = Trip.includes(bus: :operator, trip_seats: :seat).find_by(id: params[:id])
    return redirect_to trips_path unless @trip
    @trip_seats = @trip.trip_seats.sort_by { |trip_seat| trip_seat.seat.number }
  end
end
