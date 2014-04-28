--DROP TABLE label_points;

-- Create the label_points table
CREATE TABLE label_points as (
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
  wsd_appalachian.alphacode as unit_code,
  wsd_appalachian.unit_code as alphacode,
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
         GROUP BY wsd_polys.unit_code) AS wsd ON 
         irma.unit_code = wsd.unit_code) AS poly ON 
         point.unit_code = poly.unit_code) AS irma_wsd ON
        park_attributes.alpha = irma_wsd.unit_code
WHERE unit_code = 'APPA' OR display_designation is null OR (display_designation != 'National Historic Trail'
  AND display_designation != 'National Scenic Trail'
  AND unit_code != 'SEKI'));

ALTER TABLE label_points ADD COLUMN area numeric;
UPDATE label_points SET area = ST_AREA(poly_geom);

ALTER TABLE label_points ADD COLUMN area_bbox numeric;
UPDATE label_points SET area_bbox = ST_AREA(ST_Envelope(poly_geom));

ALTER TABLE label_points ADD COLUMN area_ratio numeric;
UPDATE label_points SET area_ratio = area/area_bbox;


-- Add a key for tm2
ALTER TABLE label_points ADD COLUMN tm2_key smallint;
UPDATE label_points SET tm2_key = (
  SELECT
    key
  FROM (
    SELECT
      row_number() over (ORDER BY lb2.unit_code) AS key,
      unit_code FROM label_points lb2
   ) a WHERE a.unit_code = label_points.unit_code
 );

-- 'Fixing geoms'
UPDATE label_points SET poly_geom = ST_MULTI(st_buffer(poly_geom,0));

-- add new geometry column to store points
--\echo 'Adding the label point'
ALTER TABLE label_points ADD COLUMN label_point geometry(multipoint, 3857);
UPDATE label_points SET label_point = Coalesce(ST_Multi(ST_POINTONSURFACE(poly_geom)), point_geom);

-- Fix missing points with the label_point
UPDATE label_points SET point_geom = label_point where point_geom is null;

--\echo 'Adding and index on the label point'
CREATE INDEX label_points_label_index ON label_points USING gist (label_point);

-- Find max zoom level where area is at least 8 pixels
-- round(log(2,(7.5/(area^(0.5) / (40075016.68/(256*2^1))))::numeric)+1.5)
--\echo 'Determining the minimum zoom level that each object should be a polygon'
ALTER TABLE label_points ADD COLUMN minZoomPoly numeric;
UPDATE
  label_points
SET
  minZoomPoly = round(log(2,(8/(label_points.area^(0.5) / (40075016.68/(256*2^1))))::numeric)+1.5);

-- Get names for things without names in park_attributes
UPDATE label_points a
set name = (select coalesce(c.wsd_poly_name, c.wsd_point_name, c.irma_name) from (
select b.unit_code, 
b.poly_source,
(select parkname from wsd_polys where wsd_polys.unit_code = b.unit_code limit 1) as wsd_poly_name, 
(select parkname from wsd_points where wsd_points.unit_code = b.unit_code limit 1) as wsd_point_name, 
(select unit_name from irma_nps_boundaries where irma_nps_boundaries.unit_code = b.unit_code limit 1) as irma_name
 from label_points b
where b.unit_code = a.unit_code) c )
Where name is null;

-- Clear up some of the null fields

update label_points set designation = display_designation where designation is null;
update label_points set designation = 'Park' where designation is null;
update label_points set designation = 'Park' where trim(designation) = '';
update label_points set display_name = name where display_name is null;
update label_points set display_designation = designation where display_designation is null;
update label_points set display_concatenated = display_name where display_concatenated is null;

update label_points set minzoompoly = 100 where poly_geom is null;
update label_points set designation = 'Park' where trim(designation) = '';


-- Determine which region each park is in
ALTER TABLE label_points ADD COLUMN nps_region varchar;
UPDATE
  label_points
SET
  nps_region = (
    SELECT
      nps_regions.nps_region
    FROM
      nps_regions
    WHERE
      nps_regions.wkb_geometry && ST_POINTONSURFACE(label_points.poly_geom) AND
      ST_Intersects(nps_regions.wkb_geometry, ST_POINTONSURFACE(label_points.poly_geom))
  )
WHERE
  label_points.poly_geom IS NOT NULL;

--\echo 'Joining Regions to Points'
UPDATE
  label_points
SET
  nps_region = (
    SELECT
      nps_regions.nps_region
    FROM
      nps_regions
    WHERE
      nps_regions.wkb_geometry && label_points.point_geom AND
      ST_Contains(nps_regions.wkb_geometry, label_points.point_geom)
  )
WHERE
  label_points.poly_geom IS NULL;

--\echo 'Joining hard to match regions to polys'
 UPDATE
  label_points
SET
  nps_region = (
    SELECT
      a.nps_region
    FROM (
      SELECT
        nps_regions.nps_region,
        row_number() OVER (partition by c.unit_code order by ST_DISTANCE(nps_regions.wkb_geometry, c.poly_geom)) as rank
      FROM
        nps_regions JOIN label_points c ON
        nps_regions.wkb_geometry && ST_POINTONSURFACE(c.poly_geom)
      WHERE
        c.nps_region IS NULL and c.unit_code = label_points.unit_code
    ) a WHERE a.RANK = 1
  )
WHERE
  label_points.nps_region IS NULL AND
  label_points.poly_geom IS NOT NULL;

--\echo 'Joining hard to match regions to points'
 UPDATE
  label_points
SET
  nps_region = (
    SELECT
      a.nps_region
    FROM (
      SELECT
        nps_regions.nps_region,
        row_number() OVER (partition by c.unit_code order by ST_DISTANCE(nps_regions.wkb_geometry, c.point_geom)) as rank
      FROM
        nps_regions JOIN label_points c ON
        nps_regions.wkb_geometry && c.point_geom
      WHERE
        c.nps_region IS NULL and c.unit_code = label_points.unit_code
    ) a WHERE a.RANK = 1
  )
WHERE
  label_points.nps_region IS NULL AND
  label_points.poly_geom IS NULL AND
  label_points.point_geom IS NOT NULL; 
  
-- Some name corrections

-- Move some points around

-- Grand Canyon - 36.35476/-112.69024
UPDATE
  label_points
SET
  point_geom = ST_Multi(ST_Transform(ST_GeomFromText('POINT(-112.69024 36.35476)', 4326), 3857)),
  label_point = ST_Multi(ST_Transform(ST_GeomFromText('POINT(-112.69024 36.35476)', 4326), 3857))
WHERE
  unit_code = 'GRCA';
  
  
-- Boston- 42.37261/-71.05548
UPDATE
  label_points
SET
  point_geom = ST_Multi(ST_Transform(ST_GeomFromText('POINT(-71.05548 42.37261)', 4326), 3857)),
  label_point = ST_Multi(ST_Transform(ST_GeomFromText('POINT(-71.05548 42.37261)', 4326), 3857))
WHERE
  unit_code = 'BOST';
  
-- Balitmore- 39.33031/-76.61872
UPDATE
  label_points
SET
  point_geom = ST_Multi(ST_Transform(ST_GeomFromText('POINT(-76.61872 39.33031)', 4326), 3857)),
  label_point = ST_Multi(ST_Transform(ST_GeomFromText('POINT(-76.61872 39.33031)', 4326), 3857))
WHERE
  unit_code = 'BALT';

--"Baltimore National Heritage Area" needs to be named "Baltimore"
UPDATE label_points SET name = 'Baltimore' WHERE name = 'Baltimore National Heritage Area';
--"congaree national park" needs to be changed to "congaree" for name
UPDATE label_points SET name = 'Congaree' WHERE name = 'Congaree National Park';

-- Illinois & Michigan Canal has a space after it for some reason
UPDATE label_points set name = 'Illinois & Michigan Canal' where name like 'Illinois & Michigan Canal%';

-- And some others
UPDATE label_points set name = 'Lake Mead' where name like 'Lake Mead%';
UPDATE label_points set name = 'Rock Creek' where name like 'Rock Creek%';
UPDATE label_points set name = 'Tupelo' where name like 'Tupelo%';

-- catch all
UPDATE label_points set name = 
regexp_replace(replace(trim(name), '  ', ' '), '\r|\n', '', 'g');


-- disp concatencated has issues too!
UPDATE label_points set display_concatenated = 
regexp_replace(replace(trim(display_concatenated), '  ', ' '), '\r|\n', '', 'g');


-- Duplicates
ALTER TABLE label_points ADD COLUMN has_label boolean;

--We don't need National Mall and Memorial Parks and National Mall
-- "The National Mall" is duplicated
UPDATE label_points SET has_label = 'f' WHERE unit_code = 'NACC';
UPDATE label_points SET has_label = 'f' WHERE unit_code = 'MALL';
UPDATE label_points SET has_label = 'f' WHERE unit_code = 'NACE';
UPDATE label_points SET has_label = 'f' WHERE unit_code = 'NACP';

-- "Thomas Jefferson Memorial" are duplicated
UPDATE label_points SET has_label = 'f' WHERE unit_code = 'JEFM';

-- "The National World War II Memorial" & "World War II Memorial"
UPDATE label_points SET has_label = 'f' WHERE unit_code = 'WWII';

-- Fredericksburg
UPDATE label_points SET has_label = 'f' WHERE unit_code = 'FRED';

-- Virgin Islands
UPDATE label_points SET has_label = 'f' WHERE unit_code = 'VICR';

--
UPDATE label_points SET has_label = 'f' WHERE unit_code = 'GOGA';

-- The rest
UPDATE label_points set has_label = 't' where has_label is null;


-- Has Poly
ALTER TABLE label_points ADD COLUMN has_poly boolean;
UPDATE label_points SET has_poly = false
WHERE unit_code in ('PRSF', 'NACC', 'MALL');
UPDATE label_points set has_poly = true where has_poly is null;
