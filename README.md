# Coachyard

Rails 8 bus tickets: search Pune → Mumbai, hold a seat for 5 minutes, then confirm.

Email signup/login (Devise). Postgres. Sidekiq drops holds that expire.

## Setup

Ruby 3.3.5, PostgreSQL, Redis.

Point `config/database.yml` at a local user. Databases are `bus_booking` and `bus_booking_test`.

```
bundle install
bin/rails db:create db:migrate db:seed
bin/rails s
```

Expiry job needs Redis + Sidekiq in another terminal:

```
bundle exec sidekiq
```

Seed data: a week of Pune ↔ Mumbai runs (Surya Travels and Malabar Line).

## How it works

Search is public. Holding a seat, confirm, cancel, and reschedule need a login.

- Hold is exclusive (`SELECT … FOR UPDATE` on trip seats). Second rider on the same seat gets an error.
- Confirm is idempotent: one hold → one booking. Fare is the sum of the chosen seats.
- Cancel only if departure is at least 1 hour away. Refund is fare minus Rs 50.
- Reschedule only onto another trip with the same origin, destination, and operator.

```
bundle exec rspec
```
