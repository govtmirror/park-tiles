--https://github.com/mapbox/nps-tm2-demo/blob/master/post_import.sql

-- update npmap_all_parks set point_geom = label_point where point_geom is null;
-- update npmap_all_parks set minzoompoly = 100 where poly_geom is null;
-- update npmap_all_parks set minzoompoly is null label_point where poly_geom is null;

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

-- Determine the visitors in the parks
ALTER TABLE npmap_all_parks ADD COLUMN visitors numeric;
\echo 'Joining Parks to Visitor Counts'
UPDATE
  npmap_all_parks
SET
  visitors = (
    SELECT
      park_visitors.visitors
    FROM
      park_visitors
    WHERE
      park_visitors.name = npmap_all_parks.display_name OR
      park_visitors.name = npmap_all_parks.name
    LIMIT
      1
  );

-- Find max zoom level where area is at least 8 pixels
-- round(log(2,(7.5/(area^(0.5) / (40075016.68/(256*2^1))))::numeric)+1.5)
ALTER TABLE npmap_all_parks ADD COLUMN minZoomPoly numeric;
\echo 'Determining the minimum zoom level in which each object should be a polygon'
UPDATE
  npmap_all_parks
SET
  minZoomPoly = round(log(2,(8/(npmap_all_parks.area^(0.5) / (40075016.68/(256*2^1))))::numeric)+1.5);

-- Visitor/Area Rank
-- log(coalesce(visitors,1))/log(10)+1 * log(area/log(10))
ALTER TABLE npmap_all_parks ADD COLUMN visitorAreaRank numeric;
\echo 'Determining the rank based on visitors and the area'
UPDATE
  npmap_all_parks
SET
  visitorAreaRank = log(coalesce(npmap_all_parks.visitors,1))/log(10)+1 * log(area/log(10));

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

-- add indexes to new table
\echo 'Creating the primary key and adding indexes'
ALTER TABLE npmap_all_parks_inset ADD CONSTRAINT npmap_all_parks_inset_pk PRIMARY KEY (unit_code, zoomlevel);
CREATE INDEX npmap_all_parks_inset_join_gis ON npmap_all_parks_inset (unit_code);
CREATE INDEX npmap_all_parks_inset_zoomlevel ON npmap_all_parks_inset (zoomlevel);
