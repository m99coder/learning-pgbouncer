# PgBouncer

## Example 3

```bash
docker compose up -d --build
docker compose down --remove-orphans
```

The important changes to `./pgbouncer/conf/pgbouncer.ini` are:

```
auth_user = pgbouncer
auth_query = SELECT * FROM pgbouncer.get_auth($1)
```

Make sure that every database that should be utilized by PgBouncer does have the `pgbouncer.get_auth` function (see [./postgres/init.sql](./postgres/init.sql)).

Check server address

```bash
PGPASSWORD=example psql -h localhost -p 6543 -U postgres postgres \
  -c "SELECT inet_server_addr();"
 inet_server_addr
------------------
 192.168.160.3
(1 row)
```
