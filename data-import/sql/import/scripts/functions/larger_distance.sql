ALTER TABLE label_points ADD COLUMN visitors_dist numeric;
UPDATE
  label_points
SET
  visitors_dist = (SELECT 
    COALESCE(MIN(ST_Distance(a.point_geom, label_points.point_geom)),5000000) as visitors_dist
  FROM
    label_points a 
  WHERE
    a.visitors > coalesce(label_points.visitors, 0)
);

ALTER TABLE label_points ADD COLUMN area_dist numeric;
UPDATE
  label_points
SET
  area_dist = (SELECT 
    COALESCE(MIN(ST_Distance(a.point_geom, label_points.point_geom)),5000000) as area_dist
  FROM
    label_points a 
  WHERE
    a.area > label_points.area
);


ALTER TABLE label_points ADD COLUMN area_direction numeric;
UPDATE
  label_points d
SET
  area_direction = (
    SELECT dir from (
      SELECT
        b.unit_code,
        row_number() OVER (order by st_distance(a.point_geom, b.point_geom)) rank,
        st_distance(a.point_geom, b.point_geom) dist,
        degrees(st_azimuth(st_closestpoint(a.point_geom, b.point_geom), st_closestpoint(b.point_geom, a.point_geom))) dir
      FROM
        label_points a JOIN label_points b ON a.unit_code != b.unit_code
      WHERE
        a.unit_code = d.unit_code AND
        coalesce(d.area, 0 < coalesce(a.area, 1)
     ) c WHERE rank = 1);
     
ALTER TABLE label_points ADD COLUMN visitors_direction numeric;
UPDATE
  label_points d
SET
  visitors_direction = (
    SELECT dir from (
      SELECT
        b.unit_code,
        row_number() OVER (order by st_distance(a.point_geom, b.point_geom)) rank,
        st_distance(a.point_geom, b.point_geom) dist,
        degrees(st_azimuth(st_closestpoint(a.point_geom, b.point_geom), st_closestpoint(b.point_geom, a.point_geom))) dir
      FROM
        label_points a JOIN label_points b ON a.unit_code != b.unit_code
      WHERE
        a.unit_code = d.unit_code AND
        coalesce(d.visitors, 0) < coalesce(a.visitors, 1)
     ) c WHERE rank = 1);
