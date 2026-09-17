# 5. Booking modification (reschedule)

Same route and operator, new date/time.

| Piece | Path | For |
|---|---|---|
| Routes | `GET/POST /bookings/:pnr/reschedule` | pick trip + seats |
| Service | `RescheduleBooking.run` | swap |
| Inside | `CreateHold` on the **new** trip first | same lock as hold |

```
POST /bookings/:pnr/reschedule  trip_id, seat_ids[]
  RescheduleBooking
    same origin + destination + operator
    can_cancel? (still ≥ 1 hour away)
    CreateHold on new trip   # if this fails, old booking stays
    old seats → available, old booking → rescheduled
    new seats → booked, new booking confirmed
```

Spec: `spec/services/reschedule_booking_spec.rb`

Next: [06-cancellation.md](06-cancellation.md)
