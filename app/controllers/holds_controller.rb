class HoldsController < ApplicationController
  def create
    trip = Trip.find_by(id: params[:trip_id])
    return redirect_to trips_path unless trip

    hold = CreateHold.run(current_user, trip, params[:seat_ids])
    redirect_to hold_path(hold.token)
  rescue CreateHold::Unavailable => e
    redirect_to trip_path(trip), alert: e.message
  end

  def show
    @hold = current_user.holds.find_by(token: params[:token])
    return redirect_to trips_path unless @hold

    @trip_seats = @hold.trip_seats.includes(:seat)
  end
end
