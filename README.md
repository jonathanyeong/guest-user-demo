# Learning Project: Anonymous Sign in

This project shows how we can leverage the built in authentication generator `bin/rails generate authentication`
and modify it to support Anonymous (aka Guest) sign in.

As a guest they can create an account to get full access to the application.

## Raw notes

How do we have an anonymous sign in?

User can go directly to demo with a full user object (that's anonoymous).
Then they can authenticate with credentials.

Everyone has read access
Inserts only for itself
Depending on some actions, we must have an authenticated user. The jwt has an `is_anonymous` field set to false.

Anonymous user that has provided credentials is not an anonymous user.

Supabase is what I'm basing it off.

Here's the anonymous user response from supabase

```json
{
  user: {
    id: '6e3e15d5-3f99-4382-93ed-cdbed200583b',
    aud: 'authenticated',
    role: 'authenticated',
    email: '',
    phone: '',
    last_sign_in_at: '2025-01-14T02:37:50.895707376Z',
    app_metadata: {},
    user_metadata: {},
    identities: [],
    created_at: '2025-01-14T02:37:50.893138Z',
    updated_at: '2025-01-14T02:37:50.897343Z',
    is_anonymous: true
  },
  session: {
    access_token: 'ACCESS_TOKEN',
    token_type: 'bearer',
    expires_in: 3600,
    expires_at: 1736825870,
    refresh_token: 'REFRESH_TOKEN',
    user: {
      id: '6e3e15d5-3f99-4382-93ed-cdbed200583b',
      aud: 'authenticated',
      role: 'authenticated',
      email: '',
      phone: '',
      last_sign_in_at: '2025-01-14T02:37:50.895707376Z',
      app_metadata: {},
      user_metadata: {},
      identities: [],
      created_at: '2025-01-14T02:37:50.893138Z',
      updated_at: '2025-01-14T02:37:50.897343Z',
      is_anonymous: true
    }
  }
}
```

Supabase User DB has:

```
uuid
disply name
email
phone
providers (Email)
Provider Type (Anonymous)
Created At
Last Sign In at
```