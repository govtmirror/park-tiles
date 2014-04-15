CREATE SERVER park_tiles FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host 'localhost', dbname 'data_import_3');
CREATE USER MAPPING FOR PUBLIC SERVER park_tiles OPTIONS (password '');
CREATE FOREIGN TABLE park_tiles_points (unit_code character varying, minzoompoly numeric) SERVER park_tiles OPTIONS (table_name 'label_points');
SELECT * from park_tiles_points;
