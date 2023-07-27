CREATE EXTENSION IF NOT EXISTS hstore;
CREATE EXTENSION IF NOT EXISTS ltree;

CREATE TYPE mood AS ENUM ('sad', 'ok', 'happy');

CREATE TABLE mock_data_types (
    id serial PRIMARY KEY,
    col_bytea bytea,
    col_oid oid,
    col_array integer[],
    col_hstore hstore,
    col_uuid uuid,
    col_composite point,
    col_date date,
    col_timestamp timestamp,
    col_timestamptz timestamptz,
    col_interval interval,
    col_geometric_circle circle,
    col_inet inet,
    col_cidr cidr,
    col_bit bit(3),
    col_bit_varying bit varying(3),
    col_tsvector tsvector,
    col_tsquery tsquery,
    col_json json,
    col_jsonb jsonb,
    col_enum mood,
    col_ltree ltree,
    col_range int4range
);

DO $$ 
DECLARE
    i INTEGER := 0;
BEGIN
    WHILE i < 100 LOOP
        INSERT INTO mock_data_types (
            col_bytea, col_oid, col_array, col_hstore, col_uuid, col_composite,
            col_date, col_timestamp, col_timestamptz, col_interval, 
            col_geometric_circle, col_inet, col_cidr, col_bit, col_bit_varying, 
            col_tsvector, col_tsquery, col_json, col_jsonb, col_enum, col_ltree,
            col_range
        ) VALUES (
            E'\\xDEADBEEF'::bytea, 
            i::oid,
            ARRAY[1, 2, 3],
            hstore(ARRAY['key', 'value']),
            md5(random()::text)::uuid,
            point(10, 10),
            current_date,
            current_timestamp,
            current_timestamp AT TIME ZONE 'UTC',
            '1 day'::interval,
            circle(point(1,1), 2),
            '192.168.1.1',
            '192.168.1/24',
            B'101',
            B'101',
            to_tsvector('simple', 'hello world'),
            plainto_tsquery('hello'),
            '{"key": "value"}',
            '{"key": "value"}'::jsonb,
            'ok',
            'Top.Middle.Bottom',
            '[1,3)'::int4range
        );
        i := i + 1;
    END LOOP;
END $$;
