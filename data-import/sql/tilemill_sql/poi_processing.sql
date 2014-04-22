-- Create the table
CREATE TABLE places_points AS
SELECT nodes.id AS osm_id,
    nodes.tags -> 'nps:fcat'::text AS "FCategory",
    nodes.tags -> 'name'::text AS name,
    nodes.tags -> 'nps:alphacode'::text AS unit_code,
    nodes.tags,
    nps_node_o2p_calculate_zorder(nodes.tags) AS z_order,
    st_transform(nodes.geom, 900913) AS way,
    nodes.tags -> 'nps:alphacode' as unit_code
FROM
  nodes
where nodes.tags <> ''::hstore AND nodes.tags IS NOT NULL;

-- Pull in data from another database
CREATE EXTENSION postgres_fdw;
CREATE SERVER park_tiles FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host 'localhost', dbname 'data_import_3');
CREATE USER MAPPING FOR PUBLIC SERVER park_tiles OPTIONS (password '');
CREATE FOREIGN TABLE park_tiles_points (poly_geom geometry, unit_code character varying, minzoompoly numeric) SERVER park_tiles OPTIONS (table_name 'label_points');

-- Test the connection
SELECT * from park_tiles_points;

-- Spatial Join the unjoined records
UPDATE
  places_points
SET
  unit_code = park_tiles_points.unit_code
FROM
 park_tiles_points 
WHERE
  (st_transform(places_points.way, 3857) && park_tiles_points.poly_geom) AND ST_CONTAINS(park_tiles_points.poly_geom, st_transform(places_points.way, 3857))
/*AND
  places_points.unit_code IS NULL;*/ -- it appears that the included unit_codes are crap anyway

-- Minzoompoly
ALTER TABLE places_points ADD COLUMN minzoompoly integer;

UPDATE
  places_points
SET
  minzoompoly = park_tiles_points.minzoompoly
FROM
  park_tiles_points
WHERE
  places_points.unit_code = park_tiles_points.unit_code;
