SELECT irma_wsd.poly_geom AS poly_geom,
       irma_wsd.point_geom AS point_geom,
       Coalesce(irma_wsd.poly_source, 'None') AS poly_source,
       Coalesce(irma_wsd.unit_code, park_attributes.alpha) AS unit_code,
       park_attributes.pointtopol,
       park_attributes.designation,
       park_attributes.name,
       park_attributes.display_name,
       park_attributes.display_designation,
       park_attributes.display_concatenated,
       park_attributes.display_state,
       park_attributes.display_blurb,
       park_attributes.display_url,
       park_attributes.display_address,
       park_attributes.display_phone,
       park_attributes.display_climate FROM park_attributes
FULL OUTER JOIN
  (SELECT Coalesce(poly.unit_code, point.unit_code) AS unit_code,
          poly.source AS poly_source,
          poly.geom AS poly_geom,
          point.wkb_geometry AS point_geom
   FROM wsd_points AS point
   FULL OUTER JOIN
     (SELECT Coalesce(wsd.unit_code, irma.unit_code) AS unit_code,
             CASE
               WHEN (wsd.wkb_geometry IS NOT NULL) THEN 'WSD_Parks'
               WHEN (irma.wkb_geometry IS NOT NULL) THEN 'IRMA'
               ELSE 'Unknown'
             END AS SOURCE,
             Coalesce(wsd.wkb_geometry, irma.wkb_geometry) AS geom
      FROM
        (SELECT irma_nps_boundaries.unit_code,
                St_collect(Array_agg(irma_nps_boundaries.wkb_geometry)) AS wkb_geometry
         FROM irma_nps_boundaries
         GROUP BY irma_nps_boundaries.unit_code) AS irma
      FULL OUTER JOIN
        (SELECT wsd_polys.unit_code,
                St_collect(Array_agg(wsd_polys.wkb_geometry)) AS wkb_geometry
         FROM 
(SELECT
  wsd_appalachian.ogc_fid,
  wsd_appalachian.wkb_geometry,
  wsd_appalachian.blurb,
  wsd_appalachian.alphacode,
  wsd_appalachian.unit_code,
  wsd_appalachian.parkname,
  wsd_appalachian.primary_designation,
  wsd_appalachian.casualdesignation,
  wsd_appalachian.fullparkurl,
  wsd_appalachian.shape_length, 
  wsd_appalachian.shape_area,
  wsd_appalachian.shape_length as shape_length_1,
  wsd_appalachian.shape_area as shape_area_1
FROM
  wsd_appalachian
UNION
  SELECT * FROM wsd_polys) as
        wsd_polys
         GROUP BY wsd_polys.unit_code) AS wsd ON irma.unit_code = wsd.unit_code) AS poly ON point.unit_code = poly.unit_code) AS irma_wsd ON park_attributes.alpha = irma_wsd.unit_code
WHERE unit_code = 'APPA' OR (display_designation != 'National Historic Trail'
  AND display_designation != 'National Scenic Trail'
  AND unit_code != 'SEKI');
