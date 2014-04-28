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

CREATE TABLE label_point_simplified AS
SELECT
  unit_code,
  poly_geom,
  ST_SIMPLIFY(poly_geom, zres(5)) as poly_geom_5,
  ST_SIMPLIFY(poly_geom, zres(5)) as poly_geom_6,
  ST_SIMPLIFY(poly_geom, zres(5)) as poly_geom_7,
  ST_SIMPLIFY(poly_geom, zres(5)) as poly_geom_8,
  ST_SIMPLIFY(poly_geom, zres(5)) as poly_geom_9,
  ST_SIMPLIFY(poly_geom, zres(5)) as poly_geom_10,
  ST_SIMPLIFY(poly_geom, zres(5)) as poly_geom_11,
  ST_SIMPLIFY(poly_geom, zres(5)) as poly_geom_12
FROM
  label_points
WHERE
  poly_geom is not null;
