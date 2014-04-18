CREATE SERVER park_tiles FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host 'localhost', dbname 'data_import_3');
CREATE USER MAPPING FOR PUBLIC SERVER park_tiles OPTIONS (password '');
CREATE FOREIGN TABLE park_tiles_points (unit_code character varying, minzoompoly numeric) SERVER park_tiles OPTIONS (table_name 'label_points');
SELECT * from park_tiles_points;


-- unit_code join table
CREATE TABLE uc_points_mzp AS
SELECT nodes.id AS osm_id,
    nodes.tags -> 'nps:fcat'::text AS "FCategory",
    nodes.tags -> 'name'::text AS name,
    nodes.tags -> 'nps:alphacode'::text AS unit_code,
    nodes.tags,
    nps_node_o2p_calculate_zorder(nodes.tags) AS z_order,
    st_transform(nodes.geom, 900913) AS way,
    park_tiles_points.minzoompoly as minzoompoly
   FROM nodes JOIN park_tiles_points on 
   nodes.tags -> 'nps:alphacode' = park_tiles_points.unit_code
  WHERE nodes.tags <> ''::hstore AND nodes.tags IS NOT NULL AND exist(nodes.tags,'nps:alphacode');
  
-- more info for the mzp tables 
SELECT 
unit_code,
name as long_name,
display_concatenated as short_name,
minzoompoly,

CASE
  WHEN minzoompoly <= 6 THEN '10'
  WHEN minzoompoly <= 7 THEN '11'  
  WHEN minzoompoly <= 8 THEN '12'  
  WHEN minzoompoly <= 9 THEN '13'  
  WHEN minzoompoly <= 10 THEN '14'  
  WHEN minzoompoly <= 11 THEN '15'  
  WHEN minzoompoly <= 12 THEN '16'  
  ELSE '>16' END as display_long_name_at_zoom,	
(SELECT direction FROM label_point_calc WHERE label_points.unit_code = label_point_calc.unit_code) as ldir
FROM
label_points
WHERE
label_point IS NOT NULL
ORDER BY
visitors desc
