-- NPS Boundary (Polygon)

( select unit_type, state, region, unit_code, unit_name, parkname,
  log(area)/log(10) as size,
    -- Geometries are simplified with a tolerence of 1 pixel at the
    -- given zoom level until z13 where the full geometry is used.
    case when z(!scale_denominator!) <= 12
      then st_simplify(geom,!pixel_width!)
      else geom end as geom
  from nps_boundary
) as data

-- NPS Boundary Label (point)

( select unit_name as name, parkname, geom_point,
    log(area)/log(10) as size,
    count(gid) over (partition by region order by area desc) as regionrank
  from nps_boundary
  order by area desc
) as data

-- NPS POI (point)

( select geom, name, fcategory from nps_poi where case
  when z(!scale_denominator!) >= 8 and fcategory in (
      'Campground', 'Picnic Area', 'Overlook', 'Visitor Center',
      'Ranger Station', 'Park Headquarters', 'Headquarters'
    ) then true
  when z(!scale_denominator!) >= 9 and fcategory in (
       'Entrance Station', 'Nature Center', 'Food Service', 'Information',
       'Train Station', 'Metro Station'
    ) then true
  when z(!scale_denominator!) >= 13 then true
  end
  order by gid
) as data

-- NPS Boundary Inset (polygon)

( select b.unit_type, b.state, b.region, b.unit_code, b.unit_name, b.parkname,
    log(b.area)/log(10) as size, i.zoomlevel, st_simplify(i.geom,!pixel_width!) as geom
  from nps_boundary b
  join nps_boundary_inset i on (b.gid = i.join_gid)
  where i.zoomlevel = z(!scale_denominator!)
  and z(!scale_denominator!) <= 12
  and case
    when z(!scale_denominator!) = 8
      and log(area)/log(10) >= 9 then true
    when z(!scale_denominator!) = 9
      and log(area)/log(10) >= 8 then true
    when z(!scale_denominator!) = 10
      and log(area)/log(10) >= 7 then true
    when z(!scale_denominator!) = 11
      and log(area)/log(10) >= 6 then true
    when z(!scale_denominator!) = 12
      and log(area)/log(10) >= 5 then true
  end

  union all 
 
  select b.unit_type, b.state, b.region, b.unit_code, b.unit_name, b.parkname,
    log(b.area)/log(10) as size, i.zoomlevel, i.geom
  from nps_boundary b
  join nps_boundary_inset i on (b.gid = i.join_gid)
  where z(!scale_denominator!) >= 13
  and i.zoomlevel >= 13
) as data
