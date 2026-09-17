# Ticket desk

A Rails 8 bus ticket booking app. A rider searches a city pair and date, holds seats for five minutes, then confirms a booking. Confirmed tickets can be cancelled or rescheduled.

Holds are exclusive, confirm is idempotent, cancel takes a flat Rs 50 fee, and Sidekiq releases seats when a hold expires.

For more detail on models, request flow, and each feature, check [docs/README.md](docs/README.md).

## What a rider can do

1. **Search** (no login) — from, to, date, then optional filters: operator rating, price, AC / Non-AC, seater / sleeper, amenity (wifi, charging, blanket).
2. **Sign up / log in** with email and password (Devise).
3. **Hold seats** for 5 minutes. Two people cannot hold the same seat at once.
4. **Confirm** the hold into a booking (PNR). Confirming twice does not create a second booking.
5. **Cancel** if departure is at least 1 hour away. Refund is fare minus a flat Rs 50 fee.
6. **Reschedule** onto another trip with the same origin, destination, and operator.

To exercise all of that, search **Pune → Mumbai** on a date in the next week. Surya Travels has several times on that route, so reschedule has another trip to pick. Other city pairs work for search, hold, and confirm.

## Stack

- Ruby 3.3.5, Rails 8.1
- PostgreSQL (`ticket_desk` / `ticket_desk_test`)
- Redis + Sidekiq (hold expiry)
- Devise (email auth)
- RSpec + FactoryBot

Time zone is Mumbai.

## Setup

Need Ruby 3.3.5, PostgreSQL, and Redis.

Database names in `config/database.yml`:

- development: `ticket_desk`
- test: `ticket_desk_test`

If `bin/rails db:create` fails to connect, add your local Postgres user under development and test. Do not commit that password.

```
development:
  <<: *default
  database: ticket_desk
  username: your_pg_user
  password: your_pg_password
```

```
bundle install
bin/rails db:create db:migrate db:seed
```

Start Redis, then the app:

```
bin/rails s
```

Hold expiry needs Sidekiq in a second terminal:

```
bundle exec sidekiq
```

After login as an **admin**, `/sidekiq` (header: **jobs**) shows the queue and scheduled `ExpireHoldJob`s. Seeded admin: `admin@ticket.desk` / `password`. A normal signup is not an admin.

Without Sidekiq, holds still expire in the UI timer, but seats stay locked until something runs `ExpireHold`.

## Seed data

`db/seeds.rb` loads about a week of trips. Cities in the search dropdowns:

Pune, Mumbai, Nashik, Bangalore, Hyderabad, Chennai, Goa.

Operators: Surya Travels, Malabar Line, Greenline, Konkan Express.

## How the code is organised

Business rules live in service objects, not fat controllers. Check [docs/README.md](docs/README.md) for the longer notes.

| Action | Service |
|---|---|
| Search | `SearchTrips` |
| Hold seats | `CreateHold` |
| Confirm | `ConfirmBooking` |
| Cancel | `CancelBooking` |
| Reschedule | `RescheduleBooking` |
| Expire hold | `ExpireHold` (`ExpireHoldJob`) |

`Seat` is the bus catalog (number, kind, list price). `TripSeat` is inventory for one trip (fare snapshot, available / held / booked).

**Concurrency.** `CreateHold` locks `trip_seats` with `SELECT … FOR UPDATE` in seat-id order, then marks them held. A second rider waits on the lock and gets an error if the seat is gone.

**Idempotent confirm.** `bookings.hold_id` is unique. A double submit returns the same booking.

**Hold expiry.** After a hold is saved, `ExpireHoldJob.perform_at(hold.expires_at, hold.id)` is stored in Redis. Sidekiq runs it at that time and frees seats unless the hold was already confirmed.

**Search cache.** `SearchTrips` caches result lists for 2 minutes. Hold / confirm / cancel / expire bump a version key so the next search is not stale.

## Tests

```
bundle exec rspec
```

Covers hold exclusivity, expiry, confirm-once, cancel fee / too-late, and reschedule on the same operator.
