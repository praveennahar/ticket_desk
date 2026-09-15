class BookingsController < ApplicationController
  def index
    @bookings = current_user.bookings.includes(trip: { bus: :operator }).order(created_at: :desc)
  end

  def show
    @booking = current_user.bookings.find_by(pnr: params[:pnr])
    return redirect_to bookings_path unless @booking

    @trip_seats = @booking.trip_seats.includes(:seat)
  end

  def create
    hold = current_user.holds.find_by(token: params[:hold_token])
    return redirect_to trips_path unless hold

    booking = ConfirmBooking.run(current_user, hold)
    redirect_to booking_path(booking.pnr)
  rescue ConfirmBooking::Expired => e
    redirect_to trips_path, alert: e.message
  end

  def cancel
    booking = current_user.bookings.find_by(pnr: params[:pnr])
    return redirect_to bookings_path unless booking

    CancelBooking.run(current_user, booking)
    redirect_to booking_path(booking.pnr), notice: "refund Rs #{booking.reload.refund.to_i}"
  rescue CancelBooking::TooLate => e
    redirect_to booking_path(booking.pnr), alert: e.message
  end

  def reschedule_form
    @booking = current_user.bookings.find_by(pnr: params[:pnr])
    return redirect_to bookings_path unless @booking

    @trips = SearchTrips.run(
      from: @booking.trip.origin,
      to: @booking.trip.destination,
      on: (params[:on].present? ? Date.parse(params[:on]) : @booking.trip.depart_at.to_date)
    ).reject { |trip| trip.id == @booking.trip_id || trip.bus.operator_id != @booking.trip.bus.operator_id }
    @chosen_trip = Trip.find_by(id: params[:trip_id])
    @trip_seats = @chosen_trip.trip_seats.includes(:seat).order("seats.number") if @chosen_trip
  end

  def reschedule
    booking = current_user.bookings.find_by(pnr: params[:pnr])
    return redirect_to bookings_path unless booking

    new_trip = Trip.find_by(id: params[:trip_id])
    return redirect_to reschedule_booking_path(booking.pnr) unless new_trip

    new_booking = RescheduleBooking.run(current_user, booking, new_trip, params[:seat_ids])
    redirect_to booking_path(new_booking.pnr), notice: "rescheduled"
  rescue RescheduleBooking::NotAllowed, CreateHold::Unavailable => e
    redirect_to reschedule_booking_path(booking.pnr), alert: e.message
  end
end
