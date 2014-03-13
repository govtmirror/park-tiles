--https://github.com/mapbox/nps-tm2-demo/blob/master/post_import.sql

-- Derive area measurements for boundaries. Useful for label ordering.
\echo 'Adding Area Column'
ALTER TABLE npmap_all_parks ADD COLUMN area numeric;
UPDATE npmap_all_parks SET area = ST_AREA(poly_geom);

-- make sure all geometries are valid
\echo 'Fixing geoms'
UPDATE npmap_all_parks SET poly_geom = ST_MULTI(st_buffer(poly_geom,0));

-- add new geometry column to store points
\echo 'Adding the label point'
ALTER TABLE npmap_all_parks ADD COLUMN label_point geometry(multipoint, 3857);
UPDATE npmap_all_parks SET label_point = Coalesce(ST_Multi(ST_POINTONSURFACE(poly_geom)), point_geom);

-- create geometry indexes for faster querying
\echo 'Adding and index on the label point'
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


\echo 'Ranking the parks by size per region'
ALTER TABLE npmap_all_parks ADD COLUMN region_rank smallint;
UPDATE
  npmap_all_parks
SET
  region_rank = (
    SELECT
      b.rank
    FROM (
      SELECT
        unit_code,
        row_number() OVER (partition by a.nps_region order by coalesce(a.area, 0) desc) rank
      FROM
        npmap_all_parks a) b
    WHERE
      b.unit_code = npmap_all_parks.unit_code);


\echo 'Ranking the parks by size per buffer of 750km'
ALTER TABLE npmap_all_parks ADD COLUMN buffer_rank_750km smallint;
UPDATE
  npmap_all_parks
SET
  buffer_rank_750km = (
    SELECT
      rank
    FROM (
      SELECT
        b.unit_code,
        row_number() OVER (order by coalesce(b.area, 0) desc) rank
      FROM
        npmap_all_parks a JOIN npmap_all_parks b ON
          ST_DWithin(
            coalesce(a.poly_geom, a.point_geom),
            coalesce(b.poly_geom, b.point_geom),
            750000)
      WHERE
        a.unit_code = npmap_all_parks.unit_code
      ) c
      WHERE
        c.unit_code = npmap_all_parks.unit_code);

\echo 'Ranking the parks by size per buffer of 100km'
ALTER TABLE npmap_all_parks ADD COLUMN buffer_rank_100km smallint;
UPDATE
  npmap_all_parks
SET
  buffer_rank_100km = (
    SELECT
      rank
    FROM (
      SELECT
        b.unit_code,
        row_number() OVER (order by coalesce(b.area, 0) desc) rank
      FROM
        npmap_all_parks a JOIN npmap_all_parks b ON
          ST_DWithin(
            coalesce(a.poly_geom, a.point_geom),
            coalesce(b.poly_geom, b.point_geom),
            100000)
      WHERE
        a.unit_code = npmap_all_parks.unit_code
      ) c
      WHERE
        c.unit_code = npmap_all_parks.unit_code);

\echo 'Ranking the parks by size per buffer of 1000km'
ALTER TABLE npmap_all_parks ADD COLUMN buffer_rank_1000km smallint;
UPDATE
  npmap_all_parks
SET
  buffer_rank_1000km = (
    SELECT
      rank
    FROM (
      SELECT
        b.unit_code,
        row_number() OVER (order by coalesce(b.area, 0) desc) rank
      FROM
        npmap_all_parks a JOIN npmap_all_parks b ON
          ST_DWithin(
            coalesce(a.poly_geom, a.point_geom),
            coalesce(b.poly_geom, b.point_geom),
            1000000)
      WHERE
        a.unit_code = npmap_all_parks.unit_code
      ) c
      WHERE
        c.unit_code = npmap_all_parks.unit_code);



\echo 'Adding the z function'
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


\echo 'Adding the inset tables'
--
-- Create inset geometries for all NPS boundaries to allow for tint bands.
-- (Note: this increases import time significantly.)
--
-- prepare a new table; the data will by dynamically joined in the final query
CREATE TABLE npmap_all_parks_inset (
    unit_code char(4), zoomlevel integer, geom geometry(multipolygon,3857)
);
-- insert inset poly_geometries to new table from main boundary table
\echo 'Adding Zoom Level 8'
INSERT INTO npmap_all_parks_inset (SELECT unit_code, 8,  st_multi(st_difference(poly_geom,st_buffer(poly_geom,40075016.68/(256*2^8)  * -2))) from npmap_all_parks where poly_geom IS NOT NULL AND log(area)/log(10) > 6);
\echo 'Adding Zoom Level 9'
INSERT INTO npmap_all_parks_inset (SELECT unit_code, 9,  st_multi(st_difference(poly_geom,st_buffer(poly_geom,40075016.68/(256*2^9)  * -3))) from npmap_all_parks where poly_geom IS NOT NULL AND log(area)/log(10) > 6);
\echo 'Adding Zoom Level 10'
INSERT INTO npmap_all_parks_inset (SELECT unit_code, 10, st_multi(st_difference(poly_geom,st_buffer(poly_geom,40075016.68/(256*2^10) * -3))) from npmap_all_parks where poly_geom IS NOT NULL AND log(area)/log(10) > 6);
\echo 'Adding Zoom Level 11'
INSERT INTO npmap_all_parks_inset (SELECT unit_code, 11, st_multi(st_difference(poly_geom,st_buffer(poly_geom,40075016.68/(256*2^11) * -4))) from npmap_all_parks where poly_geom IS NOT NULL AND log(area)/log(10) > 6);
\echo 'Adding Zoom Level 12'
INSERT INTO npmap_all_parks_inset (SELECT unit_code, 12, st_multi(st_difference(poly_geom,st_buffer(poly_geom,40075016.68/(256*2^12) * -4))) from npmap_all_parks where poly_geom IS NOT NULL AND log(area)/log(10) > 6);
\echo 'Adding Zoom Level 13'
INSERT INTO npmap_all_parks_inset (SELECT unit_code, 13, st_multi(st_difference(poly_geom,st_buffer(poly_geom,40075016.68/(256*2^13) * -4))) from npmap_all_parks where poly_geom IS NOT NULL AND log(area)/log(10) > 6);
\echo 'Adding Zoom Level 14'
INSERT INTO npmap_all_parks_inset (SELECT unit_code, 14, st_multi(st_difference(poly_geom,st_buffer(poly_geom,40075016.68/(256*2^14) * -4))) from npmap_all_parks where poly_geom IS NOT NULL AND log(area)/log(10) > 6);
\echo 'Adding Zoom Level 15'
INSERT INTO npmap_all_parks_inset (SELECT unit_code, 15, st_multi(st_difference(poly_geom,st_buffer(poly_geom,40075016.68/(256*2^15) * -4))) from npmap_all_parks where poly_geom IS NOT NULL AND log(area)/log(10) > 6);

\echo 'Adding Zoom Level 13 Inset 2'
INSERT INTO npmap_all_parks_inset (SELECT unit_code, 13, st_multi(st_difference(poly_geom,st_buffer(poly_geom,40075016.68/(256*2^13) * -2))) from npmap_all_parks where poly_geom IS NOT NULL AND log(area)/log(10) < 6);
\echo 'Adding Zoom Level 14 Inset 2'
INSERT INTO npmap_all_parks_inset (SELECT unit_code, 14, st_multi(st_difference(poly_geom,st_buffer(poly_geom,40075016.68/(256*2^14) * -3))) from npmap_all_parks where poly_geom IS NOT NULL AND log(area)/log(10) < 6);
\echo 'Adding Zoom Level 16 Inset 2'
INSERT INTO npmap_all_parks_inset (SELECT unit_code, 15, st_multi(st_difference(poly_geom,st_buffer(poly_geom,40075016.68/(256*2^15) * -4))) from npmap_all_parks where poly_geom IS NOT NULL AND log(area)/log(10) < 6);

-- add indexes to new table
\echo 'Creating the primary key and adding indexes'
ALTER TABLE npmap_all_parks_inset ADD CONSTRAINT npmap_all_parks_inset_pk PRIMARY KEY (unit_code, zoomlevel);
CREATE INDEX npmap_all_parks_inset_join_gis ON npmap_all_parks_inset (unit_code);
CREATE INDEX npmap_all_parks_inset_zoomlevel ON npmap_all_parks_inset (zoomlevel);
