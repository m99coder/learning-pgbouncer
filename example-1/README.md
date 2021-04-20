# PgBouncer

## Example 1

```bash
docker compose up -d --build
docker compose down --remove-orphans
```

```bash
# get MD5 hashes of passwords to put in `/pgbouncer/conf/users.txt`
PGPASSWORD=example psql -h localhost -p 6543 -U postgres postgres \
  -c "SELECT concat('\"', usename, '\" \"', passwd, '\"') FROM pg_shadow"
```

```bash
PGPASSWORD=example psql -h localhost -p 6543 -U postgres pgbouncer
psql (13.2, server 1.15.0/bouncer)
Type "help" for help.

pgbouncer=# \x
Expanded display is on.
pgbouncer=# SHOW STATS;
-[ RECORD 1 ]-----+----------
database          | pgbouncer
total_xact_count  | 2
total_query_count | 2
total_received    | 0
total_sent        | 0
total_xact_time   | 0
total_query_time  | 0
total_wait_time   | 0
avg_xact_count    | 0
avg_query_count   | 0
avg_recv          | 0
avg_sent          | 0
avg_xact_time     | 0
avg_query_time    | 0
avg_wait_time     | 0
-[ RECORD 2 ]-----+----------
database          | postgres
total_xact_count  | 6
total_query_count | 6
total_received    | 742
total_sent        | 2353
total_xact_time   | 8463
total_query_time  | 8463
total_wait_time   | 8315
avg_xact_count    | 0
avg_query_count   | 0
avg_recv          | 3
avg_sent          | 17
avg_xact_time     | 829
avg_query_time    | 829
avg_wait_time     | 6
```
