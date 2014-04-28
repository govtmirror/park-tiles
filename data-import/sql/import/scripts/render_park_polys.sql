-- nps_park_polys

DROP TABLE render_park_polys;
CREATE TABLE render_park_polys AS
SELECT
  CASE WHEN minzoompoly <= 5 THEN true else false END AS display_poly_5,
  CASE WHEN minzoompoly <= 6 THEN true else false END AS display_poly_6,
  CASE WHEN minzoompoly <= 7 THEN true else false END AS display_poly_7,
  CASE WHEN minzoompoly <= 8 THEN true else false END AS display_poly_8,
  CASE WHEN minzoompoly <= 9 THEN true else false END AS display_poly_9,
  CASE WHEN minzoompoly <= 10 THEN true else false END AS display_poly_10,
  CASE WHEN minzoompoly <= 11 THEN true else false END AS display_poly_11,
  CASE WHEN minzoompoly <= 12 THEN true else false END AS display_poly_12,
  CASE WHEN minzoompoly <= 13 THEN true else false END AS display_poly_13,
  CASE WHEN minzoompoly <= 14 THEN true else false END AS display_poly_14,
  CASE WHEN minzoompoly <= 15 THEN true else false END AS display_poly_15,
  CASE WHEN minzoompoly <= 16 THEN true else false END AS display_poly_16,

  CASE WHEN minzoompoly <= 2 THEN true else false END AS display_inset_7,
  CASE WHEN minzoompoly <= 3 THEN true else false END AS display_inset_8,
  CASE WHEN minzoompoly <= 4 THEN true else false END AS display_inset_9,
  CASE WHEN minzoompoly <= 5 THEN true else false END AS display_inset_10,
  CASE WHEN minzoompoly <= 6 THEN true else false END AS display_inset_11,
  CASE WHEN minzoompoly <= 7 THEN true else false END AS display_inset_12,
  CASE WHEN minzoompoly <= 8 THEN true else false END AS display_inset_13,
  CASE WHEN minzoompoly <= 9 THEN true else false END AS display_inset_14,
  CASE WHEN minzoompoly <= 10 THEN true else false END AS display_inset_15,
  CASE WHEN minzoompoly <= 11 THEN true else false END AS display_inset_16,

  CASE WHEN minzoompoly > 3 THEN true else false END AS display_border_8,
  CASE WHEN minzoompoly > 4 THEN true else false END AS display_border_9,
  CASE WHEN minzoompoly > 5 THEN true else false END AS display_border_10,
  CASE WHEN minzoompoly > 6 THEN true else false END AS display_border_11,
  CASE WHEN minzoompoly > 7 THEN true else false END AS display_border_12,
  CASE WHEN minzoompoly > 8 THEN true else false END AS display_border_13,
  CASE WHEN minzoompoly > 9 THEN true else false END AS display_border_14,
  CASE WHEN minzoompoly > 10 THEN true else false END AS display_border_15,
  CASE WHEN minzoompoly > 11 THEN true else false END AS display_border_16,

  label_point_simplified.poly_geom_5,
  label_point_simplified.poly_geom_6,
  label_point_simplified.poly_geom_7,
  label_point_simplified.poly_geom_8,
  label_point_simplified.poly_geom_9,
  label_point_simplified.poly_geom_10,
  label_point_simplified.poly_geom_11,
  label_point_simplified.poly_geom_12,

  label_points.poly_geom,
  label_points.minzoompoly,
  label_points.name,
  label_points.tm2_key,
  label_points.area
FROM
  label_points JOIN
    label_point_simplified ON
    label_points.unit_code = label_point_simplified.unit_code
WHERE
  label_points.has_poly = true AND
  label_points.poly_geom IS NOT NULL;
