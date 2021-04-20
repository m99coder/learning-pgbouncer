CREATE USER pgbouncer WITH PASSWORD 'whatever';

CREATE TABLE IF NOT EXISTS test (key VARCHAR(256), value TEXT);
INSERT INTO test (key, value) VALUES ('dbname', 'pgha1');
