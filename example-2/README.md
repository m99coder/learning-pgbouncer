# PgBouncer

## Example 2

```bash
docker compose up -d --build
docker compose down --remove-orphans
```

We set `server_fast_close` to `1` so that once the session has finished its transaction, PgBouncer will use the new database server to connect to. To actually trigger the switch, `RECONNECT` and `RELOAD` can be used. In case you want to wait until all connections are closed you can use this line:

```bash
PGPASSWORD=example psql -h localhost -p 6543 -U postgres pgbouncer \
  -c "WAIT_CLOSE;"
```

Check server identity

```bash
PGPASSWORD=example psql -h localhost -p 6543 -U postgres postgres \
  -c "SELECT * FROM test;"
  key   | value
--------+-------
 dbname | pgha1
(1 row)
```

Check server address

```bash
PGPASSWORD=example psql -h localhost -p 6543 -U postgres postgres \
  -c "SELECT inet_server_addr();"
 inet_server_addr
------------------
 192.168.128.4
(1 row)
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
addr         | 192.168.128.4
port         | 5432
local_addr   | 192.168.128.2
local_port   | 46606
connect_time | 2021-04-20 13:13:03 UTC
request_time | 2021-04-20 13:13:09 UTC
wait         | 0
wait_us      | 0
close_needed | 0
ptr          | 0x7f91364f2150
link         |
remote_pid   | 82
tls          |
```

Edit `./pgbouncer/conf/pgbouncer.ini` to switch from `pgha1` to `pgha2`

```diff
diff --git a/example-2/pgbouncer/conf/pgbouncer.ini b/example-2/pgbouncer/conf/pgbouncer.ini
index d40541e..92a79cb 100644
--- a/example-2/pgbouncer/conf/pgbouncer.ini
+++ b/example-2/pgbouncer/conf/pgbouncer.ini
@@ -1,5 +1,5 @@
 [databases]
-* = host=pgha1
+* = host=pgha2

 [pgbouncer]
 pool_mode = session
```

Reload PgBouncer configuration

```bash
PGPASSWORD=example psql -h localhost -p 6543 -U postgres pgbouncer \
  -c "RELOAD;"
```

```
pgbouncer_1  | 2021-04-20 13:13:46.168 UTC [1] LOG RELOAD command issued
pgbouncer_1  | 2021-04-20 13:13:46.342 UTC [1] LOG S-0x7f91364f2150: postgres/postgres@192.168.128.4:5432 closing because: database configuration changed (age=42s)
```

Check server identity

```bash
PGPASSWORD=example psql -h localhost -p 6543 -U postgres postgres \
  -c "SELECT * FROM test;"
  key   | value
--------+-------
 dbname | pgha2
(1 row)
```

Check server address

```bash
PGPASSWORD=example psql -h localhost -p 6543 -U postgres postgres \
  -c "SELECT inet_server_addr();"
 inet_server_addr
------------------
 192.168.128.3
(1 row)
```

Listing server connections

```bash
pgbouncer=# SHOW SERVERS;
-[ RECORD 1 ]+------------------------
type         | S
user         | postgres
database     | postgres
state        | idle
addr         | 192.168.128.3
port         | 5432
local_addr   | 192.168.128.2
local_port   | 50280
connect_time | 2021-04-20 13:14:04 UTC
request_time | 2021-04-20 13:14:09 UTC
wait         | 0
wait_us      | 0
close_needed | 0
ptr          | 0x7f91364f2150
link         |
remote_pid   | 83
tls          |
```
