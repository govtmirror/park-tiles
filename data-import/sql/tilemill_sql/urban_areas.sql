-- Urban points
-- First 25 from: http://en.wikipedia.org/wiki/List_of_United_States_urban_areas
/*
New York: 40.7127, -74.0059
Los Angeles: 34.05, -118.25
Chicago: 41.881944, -87.627778
Miami: 25.787676, -80.224145
Philadelphia: 39.95, -75.166667
Dallas: 32.775833, -96.796667
Houston, TX: 29.762778, -95.383056
Washington, DC: 38.895111, -77.036667
Atlanta, GA: 33.755, -84.39
Boston, MA: 42.358056, -71.063611	
Detroit, MI: 42.331389, -83.045833
Phoenix: 33.45, -112.066667
San Francisco: 37.783333, -122.416667
Seattle, WA: 47.609722, -122.333056
San Diego, CA: 32.715, -117.1625
Minneapolis, MN: 44.95, -93.2
Tampa, FL: 27.971, -82.465
Denver, CO: 39.739167, -104.984722
Baltimore, MD: 39.283333, -76.616667
St. Louis, MO: 38.627222, -90.197778
San Juan, PR: 18.45, -66.066667
Riverside, CA: 33.948056, -117.396111
Las Vegas, NV: 36.175, -115.136389
Portland, OR: 45.52, -122.681944
Cleveland, OH: 41.482222, -81.669722
*/

ALTER TABLE label_points ADD COLUMN urban_area smallint; --(within 25k)
-- Default all to 0
UPDATE
  label_points
SET
  urban_area = 0;
  
-- Go through the cities!
--New York: 40.7127, -74.0059
UPDATE label_points SET urban_area = 1 WHERE ST_DWithin(
  label_points.point_geom,
  ST_Multi(ST_Transform(ST_GeomFromText('POINT(-74.0059 40.7127)', 4326), 3857)),
  (25 * 1000)
 );
--Los Angeles: 34.05, -118.25
UPDATE label_points SET urban_area = 2 WHERE ST_DWithin(
  label_points.point_geom,
  ST_Multi(ST_Transform(ST_GeomFromText('POINT(-118.25 34.05)', 4326), 3857)),
  (25 * 1000)
 );
--Chicago: 41.881944, -87.627778
UPDATE label_points SET urban_area = 3 WHERE ST_DWithin(
  label_points.point_geom,
  ST_Multi(ST_Transform(ST_GeomFromText('POINT(-87.627778 41.881944)', 4326), 3857)),
  (25 * 1000)
 );
--Miami: 25.787676, -80.224145
UPDATE label_points SET urban_area = 4 WHERE ST_DWithin(
  label_points.point_geom,
  ST_Multi(ST_Transform(ST_GeomFromText('POINT(-80.224145 25.787676)', 4326), 3857)),
  (25 * 1000)
 );
--Philadelphia: 39.95, -75.166667
UPDATE label_points SET urban_area = 5 WHERE ST_DWithin(
  label_points.point_geom,
  ST_Multi(ST_Transform(ST_GeomFromText('POINT(-75.166667 39.95)', 4326), 3857)),
  (25 * 1000)
 );
--Dallas: 32.775833, -96.796667
UPDATE label_points SET urban_area = 6 WHERE ST_DWithin(
  label_points.point_geom,
  ST_Multi(ST_Transform(ST_GeomFromText('POINT(-96.796667 32.775833)', 4326), 3857)),
  (25 * 1000)
 );
--Houston, TX: 29.762778, -95.383056
UPDATE label_points SET urban_area = 7 WHERE ST_DWithin(
  label_points.point_geom,
  ST_Multi(ST_Transform(ST_GeomFromText('POINT(-95.383056 29.762778)', 4326), 3857)),
  (25 * 1000)
 );
--Washington, DC: 38.895111, -77.036667
UPDATE label_points SET urban_area = 8 WHERE ST_DWithin(
  label_points.point_geom,
  ST_Multi(ST_Transform(ST_GeomFromText('POINT(-77.036667 38.895111)', 4326), 3857)),
  (25 * 1000)
 );
--Atlanta, GA: 33.755, -84.39
UPDATE label_points SET urban_area = 9 WHERE ST_DWithin(
  label_points.point_geom,
  ST_Multi(ST_Transform(ST_GeomFromText('POINT(-84.39 33.755)', 4326), 3857)),
  (25 * 1000)
 );
--Boston, MA: 42.358056, -71.063611
UPDATE label_points SET urban_area = 10 WHERE ST_DWithin(
  label_points.point_geom,
  ST_Multi(ST_Transform(ST_GeomFromText('POINT(-71.063611 42.358056)', 4326), 3857)),
  (25 * 1000)
 );
--Detroit, MI: 42.331389, -83.045833
UPDATE label_points SET urban_area = 11 WHERE ST_DWithin(
  label_points.point_geom,
  ST_Multi(ST_Transform(ST_GeomFromText('POINT(-83.045833 42.331389)', 4326), 3857)),
  (25 * 1000)
 );
--Phoenix: 33.45, -112.066667
UPDATE label_points SET urban_area = 12 WHERE ST_DWithin(
  label_points.point_geom,
  ST_Multi(ST_Transform(ST_GeomFromText('POINT(-112.066667 33.45)', 4326), 3857)),
  (25 * 1000)
);
--San Francisco: 37.783333, -122.416667
UPDATE label_points SET urban_area = 13 WHERE ST_DWithin(
  label_points.point_geom,
  ST_Multi(ST_Transform(ST_GeomFromText('POINT(-122.416667 37.783333)', 4326), 3857)),
  (25 * 1000)
 );
--Seattle, WA: 47.609722, -122.333056
UPDATE label_points SET urban_area = 14 WHERE ST_DWithin(
  label_points.point_geom,
  ST_Multi(ST_Transform(ST_GeomFromText('POINT(-122.333056 47.609722)', 4326), 3857)),
  (25 * 1000)
 );
--San Diego, CA: 32.715, -117.1625
UPDATE label_points SET urban_area = 15 WHERE ST_DWithin(
  label_points.point_geom,
  ST_Multi(ST_Transform(ST_GeomFromText('POINT(-117.1625 32.715)', 4326), 3857)),
  (25 * 1000)
 );
--Minneapolis, MN: 44.95, -93.2
UPDATE label_points SET urban_area = 16 WHERE ST_DWithin(
  label_points.point_geom,
  ST_Multi(ST_Transform(ST_GeomFromText('POINT(-93.2 44.95)', 4326), 3857)),
  (25 * 1000)
 );
--Tampa, FL: 27.971, -82.465
UPDATE label_points SET urban_area = 17 WHERE ST_DWithin(
  label_points.point_geom,
  ST_Multi(ST_Transform(ST_GeomFromText('POINT(-82.465 27.971)', 4326), 3857)),
  (25 * 1000)
 );
--Denver, CO: 39.739167, -104.984722
UPDATE label_points SET urban_area = 18 WHERE ST_DWithin(
  label_points.point_geom,
  ST_Multi(ST_Transform(ST_GeomFromText('POINT(-104.984722 39.739167)', 4326), 3857)),
  (25 * 1000)
 );
--Baltimore, MD: 39.283333, -76.616667
UPDATE label_points SET urban_area = 19 WHERE ST_DWithin(
  label_points.point_geom,
  ST_Multi(ST_Transform(ST_GeomFromText('POINT(-76.616667 39.283333)', 4326), 3857)),
  (25 * 1000)
 );
--St. Louis, MO: 38.627222, -90.197778
UPDATE label_points SET urban_area = 20 WHERE ST_DWithin(
  label_points.point_geom,
  ST_Multi(ST_Transform(ST_GeomFromText('POINT(-90.197778 38.627222)', 4326), 3857)),
  (25 * 1000)
 );
--San Juan, PR: 18.45, -66.066667
UPDATE label_points SET urban_area = 21 WHERE ST_DWithin(
  label_points.point_geom,
  ST_Multi(ST_Transform(ST_GeomFromText('POINT(-66.066667 18.45)', 4326), 3857)),
  (25 * 1000)
 );
--Riverside, CA: 33.948056, -117.396111
UPDATE label_points SET urban_area = 22 WHERE ST_DWithin(
  label_points.point_geom,
  ST_Multi(ST_Transform(ST_GeomFromText('POINT(-117.396111 33.948056)', 4326), 3857)),
  (25 * 1000)
 );
--Las Vegas, NV: 36.175, -115.136389
UPDATE label_points SET urban_area = 23 WHERE ST_DWithin(
  label_points.point_geom,
  ST_Multi(ST_Transform(ST_GeomFromText('POINT(-115.136389 36.175)', 4326), 3857)),
  (25 * 1000)
 );
--Portland, OR: 45.52, -122.681944
UPDATE label_points SET urban_area = 24 WHERE ST_DWithin(
  label_points.point_geom,
  ST_Multi(ST_Transform(ST_GeomFromText('POINT(-122.681944 45.52)', 4326), 3857)),
  (25 * 1000)
 );
--Cleveland, OH: 41.482222, -81.669722
UPDATE label_points SET urban_area = 25 WHERE ST_DWithin(
  label_points.point_geom,
  ST_Multi(ST_Transform(ST_GeomFromText('POINT(-81.669722 41.482222)', 4326), 3857)),
  (25 * 1000)
 );
