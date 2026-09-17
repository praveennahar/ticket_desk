# 3. Seat selection and temporary hold

Pick seats, 5-minute hold, no two users on the same seat.

| Piece | Path | For |
|---|---|---|
| Route | `POST /trips/:trip_id/holds` | `{ seat_ids[] }` |
| Service | `CreateHold.run(user, trip, seat_ids)` | lock + hold |
| Models | `TripSeat`, `Hold` | `held` + `available_seats` |
| Job | `ExpireHoldJob` at `hold.expires_at` | [07](07-hold-expiry-jobs.md) |

```
POST /trips/:id/holds
  HoldsController#create
    CreateHold.run(current_user, trip, params[:seat_ids])
      SELECT trip_seats … ORDER BY id FOR UPDATE
      not all available? → Unavailable
      INSERT holds  expires_at = now+5.min  state=active
      trip_seats → held
      trip.decrement!(:available_seats)
      ExpireHoldJob.perform_at(expires_at)
```

Second rider waits on the lock, then sees `held`, gets `CreateHold::Unavailable`.

```
available --CreateHold--> held --ConfirmBooking--> booked
               |                      |
               +-- ExpireHold (5 min) +-- Cancel / Reschedule --> available
```

Spec: `spec/services/create_hold_spec.rb`

Next: [04-booking-confirmation.md](04-booking-confirmation.md)
