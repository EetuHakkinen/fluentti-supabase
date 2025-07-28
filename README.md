# Supabase for Fluentti-app

## Db migrations

Get new migrations automatically from local db

```
npx supabase db diff -f migration_file_name
```

Apply new migrations

```
npx supabase migration up
```

## Running functions locally

```
sudo npx supabase functions serve --no-verify-jwt --env-file .env
```
