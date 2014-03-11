--https://github.com/mapbox/nps-tm2-demo/blob/master/post_import.sql

-- Derive area measurements for boundaries. Useful for label ordering.
ALTER TABLE npmap_all_parks ADD COLUMN area numeric;
UPDATE npmap_all_parks SET area = ST_AREA(geom);

-- make sure all geometries are valid
UPDATE npmap_all_parks SET poly_geom = ST_MULTI(st_buffer(poly_geom,0));

-- add new geometry column to store points
ALTER TABLE npmap_all_parks ADD COLUMN label_point geometry(point, 3857);

-- populate point geometry column
UPDATE npmap_all_parks SET label_point = Coalesce(st_pointonsurface(poly_geom), point_geom);

-- create geometry indexes for faster querying
CREATE INDEX npmap_all_parks_label_point ON npmap_all_parks USING gist (label_point);

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
    join_gid integer, zoomlevel integer, geom geometry(multipolygon,3857)
);

-- insert inset poly_geometries to new table from main boundary table
insert into npmap_all_parks_inset (select gid, 8,  st_multi(st_difference(poly_geom,st_buffer(poly_geom,40075016.68/(256*2^8)  * -2))) from npmap_all_parks where poly_geom IS NOT NULL AND log(area)/log(10) > 6);
insert into npmap_all_parks_inset (select gid, 9,  st_multi(st_difference(poly_geom,st_buffer(poly_geom,40075016.68/(256*2^9)  * -3))) from npmap_all_parks where poly_geom IS NOT NULL AND log(area)/log(10) > 6);
insert into npmap_all_parks_inset (select gid, 10, st_multi(st_difference(poly_geom,st_buffer(poly_geom,40075016.68/(256*2^10) * -3))) from npmap_all_parks where poly_geom IS NOT NULL AND log(area)/log(10) > 6);
insert into npmap_all_parks_inset (select gid, 11, st_multi(st_difference(poly_geom,st_buffer(poly_geom,40075016.68/(256*2^11) * -4))) from npmap_all_parks where poly_geom IS NOT NULL AND log(area)/log(10) > 6);
insert into npmap_all_parks_inset (select gid, 12, st_multi(st_difference(poly_geom,st_buffer(poly_geom,40075016.68/(256*2^12) * -4))) from npmap_all_parks where poly_geom IS NOT NULL AND log(area)/log(10) > 6);
insert into npmap_all_parks_inset (select gid, 13, st_multi(st_difference(poly_geom,st_buffer(poly_geom,40075016.68/(256*2^13) * -4))) from npmap_all_parks where poly_geom IS NOT NULL AND log(area)/log(10) > 6);
insert into npmap_all_parks_inset (select gid, 14, st_multi(st_difference(poly_geom,st_buffer(poly_geom,40075016.68/(256*2^14) * -4))) from npmap_all_parks where poly_geom IS NOT NULL AND log(area)/log(10) > 6);
insert into npmap_all_parks_inset (select gid, 15, st_multi(st_difference(poly_geom,st_buffer(poly_geom,40075016.68/(256*2^15) * -4))) from npmap_all_parks where poly_geom IS NOT NULL AND log(area)/log(10) > 6);

insert into npmap_all_parks_inset (select gid, 13, st_multi(st_difference(poly_geom,st_buffer(poly_geom,40075016.68/(256*2^13) * -2))) from npmap_all_parks where poly_geom IS NOT NULL AND log(area)/log(10) < 6);
insert into npmap_all_parks_inset (select gid, 14, st_multi(st_difference(poly_geom,st_buffer(poly_geom,40075016.68/(256*2^14) * -3))) from npmap_all_parks where poly_geom IS NOT NULL AND log(area)/log(10) < 6);
insert into npmap_all_parks_inset (select gid, 15, st_multi(st_difference(poly_geom,st_buffer(poly_geom,40075016.68/(256*2^15) * -4))) from npmap_all_parks where poly_geom IS NOT NULL AND log(area)/log(10) < 6);

-- add indexes to new table
create index npmap_all_parks_inset_join_gis on npmap_all_parks_inset (join_gid);
create index npmap_all_parks_inset_zoomlevel on npmap_all_parks_inset (zoomlevel);
