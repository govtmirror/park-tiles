-- nps_test_poly

(select poly_geom, 
minzoompoly, 
buffer_rank_750km, 
name from npmap_all_parks) 
as data

-- nps_test_poi

(select way, "fcategory", name, z_order from planet_osm_point order by z_order desc) as data

-- nps_test_points

(select point_geom, 
minzoompoly, 
buffer_rank_750km,
name, 
display_name, 
display_concatenated, 
display_designation 
from npmap_all_parks) as data
