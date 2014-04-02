-- nps_park_polygon

username: npmap db: data_import host: localhost port: 5432

geom_table: poly_geom table: npmap_all_parks

buffer: 8

min zoom: 5 max zoom: 19 (both)

(select
minzoompoly, 
case when z(!scale_denominator!) <= 12
      then st_simplify(poly_geom,!pixel_width!)
      else poly_geom end as poly_geom, 
name from npmap_all_parks order by area desc) 
as data

--nps_park_polygons without simplification

(select
poly_geom, 
minzoompoly,
name
from npmap_all_parks order by area desc)
as data

-- nps_places_poi

(select way, "FCategory", name, z_order from planet_osm_point order by z_order desc) as data

-- nps_park_points

(select point_geom, 
minzoompoly, 
buffer_rank_750km,
name, 
display_name, 
display_concatenated, 
display_designation 
from npmap_all_parks) as data

-- nps__park_label

(select 
label_point,
name, 
display_name, 
display_concatenated,
visitor_area_rank_100km,
visitor_area_rank_250km,
visitor_area_rank_500km,
visitor_area_rank_750km,
region_rank,
minzoompoly from npmap_all_parks order by minzoompoly, visitor_area_rank_250km)
as data


-- labels

(SELECT 
 (SELECT 
label_point,
designation,
name,
display_name,
display_designation,
display_concatenated,
area,
visitors,
area_buffer_1000km,
area_buffer_25km,
area_buffer_750km,
area_buffer_500km,
area_buffer_250km,
area_buffer_125km,
area_buffer_50km,
visitors_buffer_1000km,
visitors_buffer_750km,
visitors_buffer_500km,
visitors_buffer_250km,
visitors_buffer_125km,
visitors_buffer_50km,
visitors_buffer_25km
FROM
label_points
ORDER BY
area desc, visitors desc) as data
