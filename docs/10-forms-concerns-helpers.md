# Where the code lives (and tests)

No form objects. Controllers pass params into services.

| Action | Service |
|---|---|
| `TripsController#index` | `SearchTrips` |
| `HoldsController#create` | `CreateHold` |
| `BookingsController#create` | `ConfirmBooking` |
| `BookingsController#cancel` | `CancelBooking` |
| `BookingsController#reschedule` | `RescheduleBooking` (calls `CreateHold`) |
| `ExpireHoldJob` | `ExpireHold` |

Helpers: `rupees`, `bus_tag` — views only.

| PDF ask | Spec |
|---|---|
| Seat hold / no oversell | `spec/services/create_hold_spec.rb` |
| Expiry | `spec/jobs/expire_hold_job_spec.rb` |
| Double booking | `spec/services/confirm_booking_spec.rb` |
| Cancellation | `spec/services/cancel_booking_spec.rb` |

```
bundle exec rspec
```
