SELECT irma_wsd.geom                                  AS the_geom,
       Coalesce(irma_wsd.unit_code, park_attrs.alpha) AS unit_code,
       park_attrs.pointtopol,
       park_attrs.designation,
       park_attrs.name,
       park_attrs.display_name,
       park_attrs.display_designation,
       park_attrs.display_concatenated,
       park_attrs.display_state,
       park_attrs.display_blurb,
       park_attrs.display_url,
       park_attrs.display_address,
       park_attrs.display_phone,
       park_attrs.display_climate
FROM   (SELECT alpha,
               pointtopol,
               designation,
               name,
               display_name,
               display_designation,
               display_concatenated,
               display_state,
               display_blurb,
               display_url,
               display_address,
               display_phone,
               display_climate
        FROM   park_attributes
        GROUP  BY alpha,
                  pointtopol,
                  designation,
                  name,
                  display_name,
                  display_designation,
                  display_concatenated,
                  display_state,
                  display_blurb,
                  display_url,
                  display_address,
                  display_phone,
                  display_climate) AS park_attrs
       full outer join (SELECT
                       --irma.unit_code,
                       --wsd.unit_code,
                       --irma.wkb_geometry as irma_geom,
                       --wsd.wkb_geometry as wsd_geom,
                       Coalesce(wsd.unit_code, irma.unit_code)       AS
                       unit_code,
                       Coalesce(wsd.wkb_geometry, irma.wkb_geometry) AS geom
                        FROM   (SELECT irma_nps_boundaries.unit_code,
       St_collect(Array_agg(irma_nps_boundaries.wkb_geometry)) AS
       wkb_geometry
       FROM   irma_nps_boundaries
       GROUP  BY irma_nps_boundaries.unit_code) AS irma
       full outer join (SELECT wsd_polys.unit_code,
                       St_collect(Array_agg(wsd_polys.wkb_geometry)) AS
       wkb_geometry
                FROM   wsd_polys
                GROUP  BY wsd_polys.unit_code) AS wsd
            ON irma.unit_code = wsd.unit_code) AS irma_wsd
                    ON park_attrs.alpha = irma_wsd.unit_code;
