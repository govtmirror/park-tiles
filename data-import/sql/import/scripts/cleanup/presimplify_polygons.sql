--presimplify

-- Add a function that will take a scale and return a resolution
CREATE OR REPLACE FUNCTION zres(z float)
    RETURNS float
    LANGUAGE PLPGSQL IMMUTABLE
AS $func$
BEGIN
    RETURN (40075016.6855785/(256*2^z));
END;
$func$;

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

-- Simplify the polygons
ALTER TABLE label_points ADD COLUMN poly_geom_5 geometry;
UPDATE label_points SET poly_geom_5 = ST_SIMPLIFY(poly_geom, zres(5)) WHERE unit_code NOT IN ('APPA', 'CHOH');

ALTER TABLE label_points ADD COLUMN poly_geom_6 geometry;
UPDATE label_points SET poly_geom_6 = ST_SIMPLIFY(poly_geom, zres(6)) WHERE unit_code NOT IN ('APPA', 'CHOH');

ALTER TABLE label_points ADD COLUMN poly_geom_7 geometry;
UPDATE label_points SET poly_geom_7 = ST_SIMPLIFY(poly_geom, zres(7)) WHERE unit_code NOT IN ('APPA', 'CHOH');

ALTER TABLE label_points ADD COLUMN poly_geom_8 geometry;
UPDATE label_points SET poly_geom_8 = ST_SIMPLIFY(poly_geom, zres(8)) WHERE unit_code NOT IN ('APPA', 'CHOH');

ALTER TABLE label_points ADD COLUMN poly_geom_9 geometry;
UPDATE label_points SET poly_geom_9 = ST_SIMPLIFY(poly_geom, zres(9));

ALTER TABLE label_points ADD COLUMN poly_geom_10 geometry;
UPDATE label_points SET poly_geom_10 = ST_SIMPLIFY(poly_geom, zres(10));

ALTER TABLE label_points ADD COLUMN poly_geom_11 geometry;
UPDATE label_points SET poly_geom_11 = ST_SIMPLIFY(poly_geom, zres(11));

ALTER TABLE label_points ADD COLUMN poly_geom_12 geometry;
UPDATE label_points SET poly_geom_12 = ST_SIMPLIFY(poly_geom, zres(12));

-- Query for TM2
(SELECT
    CASE
      WHEN z(!scale_denominator!) = 5 THEN poly_geom_5
      WHEN z(!scale_denominator!) = 6 THEN poly_geom_6
      WHEN z(!scale_denominator!) = 7 THEN poly_geom_7
      WHEN z(!scale_denominator!) = 8 THEN poly_geom_8
      WHEN z(!scale_denominator!) = 9 THEN poly_geom_9
      WHEN z(!scale_denominator!) = 10 THEN poly_geom_10
      WHEN z(!scale_denominator!) = 11 THEN poly_geom_11
      WHEN z(!scale_denominator!) = 11 THEN poly_geom_12
      ELSE poly_geom end as poly_geom,
minzoompoly,
name
FROM label_points WHERE poly_geom IS NOT NULL ORDER BY area DESC)
AS data
