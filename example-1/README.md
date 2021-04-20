# PgBouncer

## Example 1

```bash
docker compose up -d --build
docker compose down --remove-orphans
```

Utilize PostgreSQL instance

```bash
# get MD5 hashes of passwords to put in `/pgbouncer/conf/users.txt`
PGPASSWORD=example psql -h localhost -p 6543 -U postgres postgres \
  -c "SELECT concat('\"', usename, '\" \"', passwd, '\"') FROM pg_shadow"
```

Connect to PgBouncer

```bash
PGPASSWORD=example psql -h localhost -p 6543 -U postgres pgbouncer
psql (13.2, server 1.15.0/bouncer)
Type "help" for help.

pgbouncer=# \x
Expanded display is on.
```

Listing server connections

```bash
pgbouncer=# SHOW SERVERS;
-[ RECORD 1 ]+------------------------
type         | S
user         | postgres
database     | postgres
state        | idle
addr         | 172.31.0.3
port         | 5432
local_addr   | 172.31.0.2
local_port   | 52556
connect_time | 2021-04-20 07:06:56 UTC
request_time | 2021-04-20 07:06:56 UTC
wait         | 0
wait_us      | 0
close_needed | 0
ptr          | 0x7fd5b89cb160
link         |
remote_pid   | 83
tls          |
```

Listing client connections

```bash
pgbouncer=# SHOW CLIENTS;
-[ RECORD 1 ]+------------------------
type         | C
user         | postgres
database     | pgbouncer
state        | active
addr         | 172.31.0.1
port         | 62288
local_addr   | 172.31.0.2
local_port   | 6543
connect_time | 2021-04-20 07:06:33 UTC
request_time | 2021-04-20 07:08:04 UTC
wait         | 84
wait_us      | 371947
close_needed | 0
ptr          | 0x7fd5b89d2130
link         |
remote_pid   | 0
tls          |
```

Evaluating pool health

```bash
pgbouncer=# SHOW POOLS;
-[ RECORD 1 ]---------
database   | pgbouncer
user       | pgbouncer
cl_active  | 1
cl_waiting | 0
sv_active  | 0
sv_idle    | 0
sv_used    | 0
sv_tested  | 0
sv_login   | 0
maxwait    | 0
maxwait_us | 0
pool_mode  | statement
-[ RECORD 2 ]---------
database   | postgres
user       | postgres
cl_active  | 0
cl_waiting | 0
sv_active  | 0
sv_idle    | 0
sv_used    | 1
sv_tested  | 0
sv_login   | 0
maxwait    | 0
maxwait_us | 0
pool_mode  | session
```

Show stats

```bash
pgbouncer=# SHOW STATS;
-[ RECORD 1 ]-----+----------
database          | pgbouncer
total_xact_count  | 1
total_query_count | 1
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
total_xact_count  | 1
total_query_count | 1
total_received    | 68
total_sent        | 316
total_xact_time   | 1974
total_query_time  | 1974
total_wait_time   | 7490
avg_xact_count    | 0
avg_query_count   | 0
avg_recv          | 0
avg_sent          | 0
avg_xact_time     | 0
avg_query_time    | 0
avg_wait_time     | 0
```
