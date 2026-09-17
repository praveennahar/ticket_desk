# Search cache

Seat map is **not** cached.

`SearchTrips` reads `Rails.cache.fetch` for 2 minutes. The key includes a version stamp:

```
search:Pune:Mumbai:2026-09-20:v
```

After hold / expire / confirm / cancel / reschedule, `Trip#bump_search_cache` increments that stamp. Next search misses and hits Postgres with a fresh `available_seats`.

Next: [09-call-flows.md](09-call-flows.md)
