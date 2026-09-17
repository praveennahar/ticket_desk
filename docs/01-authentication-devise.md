# 1. Authentication (email only)

Devise. No username, OAuth, or phone.

| Piece | Path | For |
|---|---|---|
| Model | `app/models/user.rb` | email + encrypted password |
| Routes | `devise_for :users` | sign up / sign in / sign out |
| Gate | `ApplicationController` | `authenticate_user!` unless Devise |
| Skip | `TripsController` | search + seat map stay public |
| After login | `after_sign_in_path_for` | `trips_path` |

```
POST /users/sign_up   → INSERT users → session → trips_path
POST /users/sign_in   → check password → session → trips_path
POST /trips/:id/holds (no cookie) → redirect /users/sign_in
```

Services never take `params[:user_id]`. Actor is `current_user`.

Spec: `spec/requests/signup_spec.rb`

Next: [02-trip-search-and-filters.md](02-trip-search-and-filters.md)
