CREATE USER pgbouncer WITH PASSWORD 'whatever';

CREATE SCHEMA pgbouncer AUTHORIZATION pgbouncer;

CREATE OR REPLACE FUNCTION pgbouncer.get_auth(p_usename TEXT)
RETURNS TABLE(username TEXT, password TEXT) AS
$$
BEGIN
  RAISE NOTICE 'PgBouncer auth request: %', p_usename;
  RETURN QUERY
  SELECT usename::TEXT, passwd::TEXT
    FROM pg_catalog.pg_shadow
   WHERE usename = p_usename;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename TEXT) FROM public;
GRANT EXECUTE ON FUNCTION pgbouncer.get_auth(p_usename TEXT) TO pgbouncer;
