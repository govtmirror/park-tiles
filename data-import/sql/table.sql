--SELECT unit_code FROM irma_nps_boundaries;
--SELECT alpha FROM park_attributes;
--SELECT unit_code FROM wsd_polys;

SELECT
irma_wsd.geom as the_geom,
park_attrs.*
FROM
(SELECT 
  alpha, pointtopol, designation, name, display_name, display_designation, display_concatenated, display_state, display_blurb, display_url, display_address, display_phone, display_climate 
  from park_attributes
  group by alpha, pointtopol, designation, name, display_name, display_designation, display_concatenated, display_state, display_blurb, display_url, display_address, display_phone, display_climate
  ) AS park_attrs FULL OUTER JOIN (
  SELECT
  --irma.unit_code,
  --wsd.unit_code,
  --irma.wkb_geometry as irma_geom,
  --wsd.wkb_geometry as wsd_geom,
  coalesce(wsd.unit_code, irma.unit_code) as unit_code,
  coalesce(wsd.wkb_geometry, irma.wkb_geometry) as geom
  FROM
  (SELECT
    irma_nps_boundaries.unit_code,
    ST_Collect(array_agg(irma_nps_boundaries.wkb_geometry)) AS wkb_geometry
    FROM
    irma_nps_boundaries
    GROUP BY
    irma_nps_boundaries.unit_code) AS irma FULL OUTER JOIN 
  (SELECT
    wsd_polys.unit_code,
    ST_Collect(array_agg(wsd_polys.wkb_geometry)) AS wkb_geometry
    FROM
    wsd_polys
    GROUP BY
    wsd_polys.unit_code) AS wsd
  ON irma.unit_code = wsd.unit_code) AS irma_wsd ON park_attrs.alpha = irma_wsd.unit_code;
