# Call flows — one page

```
Browser
  routes.rb
    Devise current_user (except GET /trips)
      Controller
        Service.run(...)
          models
          ExpireHoldJob / Rails.cache
      redirect / render
```

## 1. Auth

```
GET|POST /users/sign_up  → Devise → User
GET|POST /users/sign_in
DELETE  /users/sign_out
    redirect trips_path
```

## 2. Search

```
GET /trips?from=&to=&on=&min_rating=&min_price=&max_price=&ac_type=&layout_type=&amenity=
    TripsController#index
      SearchTrips.run
        Rails.cache.fetch + Trip/Bus/Operator/Amenity
GET /trips/:id
    TripsController#show   (live trip seats, not cached)
```

## 3. Hold

```
POST /trips/:id/holds  { seat_ids[] }
    authenticate_user!
    HoldsController#create
      CreateHold.run
        TripSeat.order(:id).lock
        Hold active, expires_at +5min
        ExpireHoldJob.perform_at
        bump_search_cache
          GET /holds/:token
```

## 4. Confirm

```
POST /holds/:token/bookings
    BookingsController#create
      ConfirmBooking.run
        existing Booking by hold_id? return it
        hold.lock! + trip_seats.lock
        Booking confirmed, unique hold_id
        trip seats booked, hold converted
          GET /bookings/:pnr
```

## 5. Reschedule

```
GET  /bookings/:pnr/reschedule
    SearchTrips, keep same operator
POST /bookings/:pnr/reschedule  { trip_id, seat_ids[] }
    RescheduleBooking.run
      CreateHold on new trip first
      old booking rescheduled, new booking confirmed
```

## 6. Cancel

```
POST /bookings/:pnr/cancel
    CancelBooking.run
      depart_at >= 1.hour
      refund = total - 50
      trip seats available
```

## Job

```
clock → ExpireHoldJob → ExpireHold
    hold expired, seats available   (no-op if already converted)
```

Controllers do not call each other. Helpers do not write.
