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
