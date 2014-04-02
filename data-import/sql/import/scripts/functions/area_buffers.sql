ALTER TABLE label_points ADD COLUMN area_buffer_1000km smallint;
UPDATE
  label_points
SET
  area_buffer_1000km = (
    SELECT
      rank
    FROM (
      SELECT
        b.unit_code,
        row_number() OVER (order by coalesce(b.area, 0) desc) rank
      FROM
      label_points a JOIN label_points b ON
        ST_DWithin(
        a.point_geom,
        b.point_geom,
        (1000 * 1000))
      WHERE
        a.unit_code = label_points.unit_code
      ) c
      WHERE
        c.unit_code = label_points.unit_code);
        
ALTER TABLE label_points ADD COLUMN area_buffer_750km smallint;
UPDATE
  label_points
SET
  area_buffer_750km = (
    SELECT
      rank
    FROM (
      SELECT
        b.unit_code,
        row_number() OVER (order by coalesce(b.area, 0) desc) rank
      FROM
        label_points a JOIN label_points b ON
          ST_DWithin(
          a.point_geom,
          b.point_geom,
        (750 * 1000))
      WHERE
        a.unit_code = label_points.unit_code
      ) c
      WHERE
        c.unit_code = label_points.unit_code);
        
ALTER TABLE label_points ADD COLUMN area_buffer_500km smallint;
UPDATE
  label_points
SET
  area_buffer_500km = (
    SELECT
      rank
    FROM (
      SELECT
        b.unit_code,
        row_number() OVER (order by coalesce(b.area, 0) desc) rank
      FROM
        label_points a JOIN label_points b ON
          ST_DWithin(
          a.point_geom,
          b.point_geom,
        (500 * 1000))
      WHERE
        a.unit_code = label_points.unit_code
      ) c
      WHERE
        c.unit_code = label_points.unit_code);
        
ALTER TABLE label_points ADD COLUMN area_buffer_250km smallint;
UPDATE
  label_points
SET
  area_buffer_250km = (
    SELECT
      rank
    FROM (
      SELECT
        b.unit_code,
        row_number() OVER (order by coalesce(b.area, 0) desc) rank
      FROM
        label_points a JOIN label_points b ON
          ST_DWithin(
          a.point_geom,
          b.point_geom,
          (250 * 1000))
      WHERE
        a.unit_code = label_points.unit_code
      ) c
      WHERE
        c.unit_code = label_points.unit_code);
        
ALTER TABLE label_points ADD COLUMN area_buffer_125km smallint;
UPDATE
  label_points
SET
  area_buffer_125km = (
    SELECT
      rank
    FROM (
      SELECT
        b.unit_code,
        row_number() OVER (order by coalesce(b.area, 0) desc) rank
      FROM
        label_points a JOIN label_points b ON
          ST_DWithin(
          a.point_geom,
          b.point_geom,
          (125 * 1000))
      WHERE
        a.unit_code = label_points.unit_code
      ) c
      WHERE
        c.unit_code = label_points.unit_code);
        
ALTER TABLE label_points ADD COLUMN area_buffer_50km smallint;
UPDATE
  label_points
SET
  area_buffer_50km = (
    SELECT
      rank
    FROM (
      SELECT
        b.unit_code,
        row_number() OVER (order by coalesce(b.area, 0) desc) rank
      FROM
        label_points a JOIN label_points b ON
          ST_DWithin(
          a.point_geom,
          b.point_geom,
          (50 * 1000))
      WHERE
        a.unit_code = label_points.unit_code
      ) c
      WHERE
        c.unit_code = label_points.unit_code);

ALTER TABLE label_points ADD COLUMN area_buffer_25km smallint;
UPDATE
  label_points
SET
  area_buffer_25km = (
    SELECT
      rank
    FROM (
      SELECT
        b.unit_code,
        row_number() OVER (order by coalesce(b.area, 0) desc) rank
      FROM
        label_points a JOIN label_points b ON
          ST_DWithin(
          a.point_geom,
          b.point_geom,
          (25 * 1000))
      WHERE
        a.unit_code = label_points.unit_code
      ) c
      WHERE
        c.unit_code = label_points.unit_code);
