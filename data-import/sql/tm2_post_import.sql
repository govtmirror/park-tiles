--https://github.com/mapbox/nps-tm2-demo/blob/master/post_import.sql

-- Derive area measurements for boundaries. Useful for label ordering.
ALTER TABLE npmap_all_parks ADD COLUMN area numeric;
UPDATE npmap_all_parks SET area = ST_AREA(poly_geom);

-- make sure all geometries are valid
UPDATE npmap_all_parks SET poly_geom = ST_MULTI(st_buffer(poly_geom,0));

-- add new geometry column to store points
ALTER TABLE npmap_all_parks ADD COLUMN label_point geometry(multipoint, 3857);

-- populate point geometry column
UPDATE npmap_all_parks SET label_point = Coalesce(ST_Multi(ST_POINTONSURFACE(poly_geom)), point_geom);

-- create geometry indexes for faster querying
CREATE INDEX npmap_all_parks_label_point ON npmap_all_parks USING gist (label_point);

-- Determine which region each park is in
ALTER TABLE npmap_all_parks ADD COLUMN nps_region varchar;
\echo 'Joining Regions to Polys'
UPDATE
  npmap_all_parks
SET
  nps_region = (
    SELECT
      nps_regions.nps_region
    FROM
      nps_regions
    WHERE
      nps_regions.wkb_geometry && ST_POINTONSURFACE(npmap_all_parks.poly_geom) AND
      ST_Intersects(nps_regions.wkb_geometry, ST_POINTONSURFACE(npmap_all_parks.poly_geom))
  )
WHERE
  npmap_all_parks.poly_geom IS NOT NULL;

\echo 'Joining Regions to Points'
UPDATE
  npmap_all_parks
SET
  nps_region = (
    SELECT
      nps_regions.nps_region
    FROM
      nps_regions
    WHERE
      nps_regions.wkb_geometry && npmap_all_parks.point_geom AND
      ST_Contains(nps_regions.wkb_geometry, npmap_all_parks.point_geom)
  )
WHERE
  npmap_all_parks.poly_geom IS NULL;

\echo 'Joining hard to match regions to polys'
 UPDATE
  npmap_all_parks
SET
  nps_region = (
    SELECT
      a.nps_region
    FROM (
      SELECT
        nps_regions.nps_region,
        row_number() OVER (partition by c.unit_code order by ST_DISTANCE(nps_regions.wkb_geometry, c.poly_geom)) as rank
      FROM
        nps_regions JOIN npmap_all_parks c ON
        nps_regions.wkb_geometry && ST_POINTONSURFACE(c.poly_geom)
      WHERE
        c.nps_region IS NULL and c.unit_code = npmap_all_parks.unit_code
    ) a WHERE a.RANK = 1
  )
WHERE
  npmap_all_parks.nps_region IS NULL AND
  npmap_all_parks.poly_geom IS NOT NULL;

\echo 'Joining hard to match regions to points'
 UPDATE
  npmap_all_parks
SET
  nps_region = (
    SELECT
      a.nps_region
    FROM (
      SELECT
        nps_regions.nps_region,
        row_number() OVER (partition by c.unit_code order by ST_DISTANCE(nps_regions.wkb_geometry, c.point_geom)) as rank
      FROM
        nps_regions JOIN npmap_all_parks c ON
        nps_regions.wkb_geometry && c.point_geom
      WHERE
        c.nps_region IS NULL and c.unit_code = npmap_all_parks.unit_code
    ) a WHERE a.RANK = 1
  )
WHERE
  npmap_all_parks.nps_region IS NULL AND
  npmap_all_parks.poly_geom IS NULL AND
  npmap_all_parks.point_geom IS NOT NULL;

--
-- Add a PostgreSQL function to calculate zoom level given a scale denominator.
-- This is used in the queries configured in the TM2 source project.
--
CREATE OR REPLACE FUNCTION public.z(scaledenominator numeric)
  RETURNS integer immutable
  LANGUAGE plpgsql as
$func$
BEGIN
  iF scaledenominator > 600000000 THEN
    RETURN NULL;
  END IF;
  RETURN ROUND(LOG(2,559082264.028/scaledenominator));
END;
$func$;

--
-- Create inset geometries for all NPS boundaries to allow for tint bands.
-- (Note: this increases import time significantly.)
--
-- prepare a new table; the data will by dynamically joined in the final query
CREATE TABLE npmap_all_parks_inset (
    unit_code char(4), zoomlevel integer, geom geometry(multipolygon,3857)
);
/*
-- insert inset poly_geometries to new table from main boundary table
INSERT INTO npmap_all_parks_inset (SELECT unit_code, 8,  st_multi(st_difference(poly_geom,st_buffer(poly_geom,40075016.68/(256*2^8)  * -2))) from npmap_all_parks where poly_geom IS NOT NULL AND log(area)/log(10) > 6);
INSERT INTO npmap_all_parks_inset (SELECT unit_code, 9,  st_multi(st_difference(poly_geom,st_buffer(poly_geom,40075016.68/(256*2^9)  * -3))) from npmap_all_parks where poly_geom IS NOT NULL AND log(area)/log(10) > 6);
INSERT INTO npmap_all_parks_inset (SELECT unit_code, 10, st_multi(st_difference(poly_geom,st_buffer(poly_geom,40075016.68/(256*2^10) * -3))) from npmap_all_parks where poly_geom IS NOT NULL AND log(area)/log(10) > 6);
INSERT INTO npmap_all_parks_inset (SELECT unit_code, 11, st_multi(st_difference(poly_geom,st_buffer(poly_geom,40075016.68/(256*2^11) * -4))) from npmap_all_parks where poly_geom IS NOT NULL AND log(area)/log(10) > 6);
INSERT INTO npmap_all_parks_inset (SELECT unit_code, 12, st_multi(st_difference(poly_geom,st_buffer(poly_geom,40075016.68/(256*2^12) * -4))) from npmap_all_parks where poly_geom IS NOT NULL AND log(area)/log(10) > 6);
INSERT INTO npmap_all_parks_inset (SELECT unit_code, 13, st_multi(st_difference(poly_geom,st_buffer(poly_geom,40075016.68/(256*2^13) * -4))) from npmap_all_parks where poly_geom IS NOT NULL AND log(area)/log(10) > 6);
INSERT INTO npmap_all_parks_inset (SELECT unit_code, 14, st_multi(st_difference(poly_geom,st_buffer(poly_geom,40075016.68/(256*2^14) * -4))) from npmap_all_parks where poly_geom IS NOT NULL AND log(area)/log(10) > 6);
INSERT INTO npmap_all_parks_inset (SELECT unit_code, 15, st_multi(st_difference(poly_geom,st_buffer(poly_geom,40075016.68/(256*2^15) * -4))) from npmap_all_parks where poly_geom IS NOT NULL AND log(area)/log(10) > 6);

INSERT INTO npmap_all_parks_inset (SELECT unit_code, 13, st_multi(st_difference(poly_geom,st_buffer(poly_geom,40075016.68/(256*2^13) * -2))) from npmap_all_parks where poly_geom IS NOT NULL AND log(area)/log(10) < 6);
INSERT INTO npmap_all_parks_inset (SELECT unit_code, 14, st_multi(st_difference(poly_geom,st_buffer(poly_geom,40075016.68/(256*2^14) * -3))) from npmap_all_parks where poly_geom IS NOT NULL AND log(area)/log(10) < 6);
INSERT INTO npmap_all_parks_inset (SELECT unit_code, 15, st_multi(st_difference(poly_geom,st_buffer(poly_geom,40075016.68/(256*2^15) * -4))) from npmap_all_parks where poly_geom IS NOT NULL AND log(area)/log(10) < 6);

-- add indexes to new table
#ALTER TABLE npmap_all_parks_inset ADD CONSTRAINT npmap_all_parks_inset_pk PRIMARY KEY (unit_code, zoomlevel);"
CREATE INDEX npmap_all_parks_inset_join_gis ON npmap_all_parks_inset (unit_code);
CREATE INDEX npmap_all_parks_inset_zoomlevel ON npmap_all_parks_inset (zoomlevel);
*/
