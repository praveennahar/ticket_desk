# Hold expiry (Sidekiq)

| Piece | Path | For |
|---|---|---|
| Enqueue | `CreateHold` | `ExpireHoldJob.perform_at(hold.expires_at, hold.id)` |
| Job | `ExpireHoldJob` (`Sidekiq::Job`) | thin |
| Service | `ExpireHold.run(hold)` | actual release |

```
CreateHold commits → Sidekiq waits 5 minutes
ExpireHoldJob#perform(hold_id)
  ExpireHold
    not active or not past expires_at? → return
    trip_seats → available, hold → expired
    available_seats up
```

If confirm won first, hold is `converted` and the job does nothing.

Spec: `spec/jobs/expire_hold_job_spec.rb`

Next: [08-search-cache.md](08-search-cache.md)
