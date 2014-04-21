-- Some name corrections

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

-- Do the point calculations
CREATE TABLE label_point_calc AS (SELECT unit_code FROM label_points);

-- Directions
ALTER TABLE label_point_calc ADD COLUMN direction char(2);
UPDATE label_point_calc SET direction = 'NE' WHERE (SELECT name FROM label_points WHERE label_point_calc.unit_code = label_points.unit_code) = 'Klondike Gold Rush - Seattle Unit';
UPDATE label_point_calc SET direction = 'N' WHERE (SELECT name FROM label_points WHERE label_point_calc.unit_code = label_points.unit_code) = 'Santa Monica Mountains';
UPDATE label_point_calc SET direction = 'NW' WHERE (SELECT name FROM label_points WHERE label_point_calc.unit_code = label_points.unit_code) = 'Natural Bridges';
UPDATE label_point_calc SET direction = 'NW' WHERE (SELECT name FROM label_points WHERE label_point_calc.unit_code = label_points.unit_code) = 'Saguaro';
UPDATE label_point_calc SET direction = 'SE' WHERE (SELECT name FROM label_points WHERE label_point_calc.unit_code = label_points.unit_code) = 'Chamizal';
UPDATE label_point_calc SET direction = 'W' WHERE (SELECT name FROM label_points WHERE label_point_calc.unit_code = label_points.unit_code) = 'Fort Smith';
UPDATE label_point_calc SET direction = 'N' WHERE (SELECT name FROM label_points WHERE label_point_calc.unit_code = label_points.unit_code) = 'Central High School';
UPDATE label_point_calc SET direction = 'N' WHERE (SELECT name FROM label_points WHERE label_point_calc.unit_code = label_points.unit_code) = 'Great Smoky Mountains';
UPDATE label_point_calc SET direction = 'N' WHERE (SELECT name FROM label_points WHERE label_point_calc.unit_code = label_points.unit_code) = 'Ocmulgee';
UPDATE label_point_calc SET direction = 'S' WHERE (SELECT name FROM label_points WHERE label_point_calc.unit_code = label_points.unit_code) = 'Fort Sumter';
UPDATE label_point_calc SET direction = 'S' WHERE (SELECT name FROM label_points WHERE label_point_calc.unit_code = label_points.unit_code) = 'Congaree';
UPDATE label_point_calc SET direction = 'SE' WHERE (SELECT name FROM label_points WHERE label_point_calc.unit_code = label_points.unit_code) = 'Kings Mountain';
UPDATE label_point_calc SET direction = 'NW' WHERE (SELECT name FROM label_points WHERE label_point_calc.unit_code = label_points.unit_code) = 'William Howard Taft';
UPDATE label_point_calc SET direction = 'N' WHERE (SELECT name FROM label_points WHERE label_point_calc.unit_code = label_points.unit_code) = 'Delaware Water Gap';
UPDATE label_point_calc SET direction = 'SE' WHERE (SELECT name FROM label_points WHERE label_point_calc.unit_code = label_points.unit_code) = 'Great Egg Harbor River';
UPDATE label_point_calc SET direction = 'NW' WHERE (SELECT name FROM label_points WHERE label_point_calc.unit_code = label_points.unit_code) = 'Boston';
UPDATE label_point_calc SET direction = 'N' WHERE (SELECT name FROM label_points WHERE label_point_calc.unit_code = label_points.unit_code) = 'Perry''s Victory & International Peace';
UPDATE label_point_calc SET direction = 'N' WHERE (SELECT name FROM label_points WHERE label_point_calc.unit_code = label_points.unit_code) = 'Golden Gate';
UPDATE label_point_calc SET direction = 'NW' WHERE (SELECT name FROM label_points WHERE label_point_calc.unit_code = label_points.unit_code) = 'Whiskeytown';
UPDATE label_point_calc SET direction = 'NW' WHERE (SELECT name FROM label_points WHERE label_point_calc.unit_code = label_points.unit_code) = 'Salinas Pueblo Missions';
UPDATE label_point_calc SET direction = 'N' WHERE (SELECT name FROM label_points WHERE label_point_calc.unit_code = label_points.unit_code) = 'Roger Williams';
UPDATE label_point_calc SET direction = 'NW' WHERE (SELECT name FROM label_points WHERE label_point_calc.unit_code = label_points.unit_code) = 'William Howard Taft';
UPDATE label_point_calc SET direction = 'SE' WHERE (SELECT name FROM label_points WHERE label_point_calc.unit_code = label_points.unit_code) = 'San Antonio Missions';
UPDATE label_point_calc SET direction = 'NW' WHERE (SELECT name FROM label_points WHERE label_point_calc.unit_code = label_points.unit_code) = 'Appomattox Court House';
UPDATE label_point_calc SET direction = 'N' WHERE (SELECT name FROM label_points WHERE label_point_calc.unit_code = label_points.unit_code) = 'Fredericksburg & Spotsylvania';
UPDATE label_point_calc SET direction = 'S' WHERE (SELECT name FROM label_points WHERE label_point_calc.unit_code = label_points.unit_code) = 'Paterson Great Falls';
UPDATE label_point_calc SET direction = 'NE' WHERE (SELECT name FROM label_points WHERE label_point_calc.unit_code = label_points.unit_code) = 'Maggie L. Walker';
UPDATE label_point_calc SET direction = 'S' WHERE (SELECT name FROM label_points WHERE label_point_calc.unit_code = label_points.unit_code) = 'Fort Vancouver';
UPDATE label_point_calc SET direction = 'SE' WHERE (SELECT name FROM label_points WHERE label_point_calc.unit_code = label_points.unit_code) = 'Greenbelt Park';
UPDATE label_point_calc SET direction = 'SE' WHERE (SELECT name FROM label_points WHERE label_point_calc.unit_code = label_points.unit_code) = 'New Bedford Whaling';
UPDATE label_point_calc SET direction = 'SE' WHERE (SELECT name FROM label_points WHERE label_point_calc.unit_code = label_points.unit_code) = 'Colorado';
UPDATE label_point_calc SET direction = 'W' WHERE (SELECT name FROM label_points WHERE label_point_calc.unit_code = label_points.unit_code) = 'Capitol Reef';
UPDATE label_point_calc SET direction = 'NW' WHERE (SELECT name FROM label_points WHERE label_point_calc.unit_code = label_points.unit_code) = 'Guilford Courthouse';
UPDATE label_point_calc SET direction = 'SE' WHERE (SELECT name FROM label_points WHERE label_point_calc.unit_code = label_points.unit_code) = 'Kings Mountain';
UPDATE label_point_calc SET direction = 'SE' WHERE (SELECT name FROM label_points WHERE label_point_calc.unit_code = label_points.unit_code) = 'Stones River';

--ALTER TABLE label_point_calc ADD COLUMN show_label_5 boolean;
--ALTER TABLE label_point_calc ADD COLUMN show_label_6 boolean;
--ALTER TABLE label_point_calc ADD COLUMN show_label_7 boolean;
--ALTER TABLE label_point_calc ADD COLUMN show_label_8 boolean;
--ALTER TABLE label_point_calc ADD COLUMN show_label_9 boolean;
--ALTER TABLE label_point_calc ADD COLUMN show_label_10 boolean;
--ALTER TABLE label_point_calc ADD COLUMN show_label_11 boolean;
--ALTER TABLE label_point_calc ADD COLUMN show_label_12 boolean;
--ALTER TABLE label_point_calc ADD COLUMN show_label_13 boolean;
--ALTER TABLE label_point_calc ADD COLUMN show_label_14 boolean;
--ALTER TABLE label_point_calc ADD COLUMN show_label_15 boolean;
--ALTER TABLE label_point_calc ADD COLUMN show_label_16 boolean;
--ALTER TABLE label_point_calc ADD COLUMN show_label_17 boolean;

/*UPDATE label_point_calc SET show_label_5 = (SELECT (
 minzoompoly<=5 AND visitors_dist>300000
) from label_points where label_points.unit_code = label_point_calc.unit_code)*/


-- Zoom level 5
ALTER TABLE label_point_calc ADD COLUMN show_label_5 boolean;
UPDATE label_point_calc SET show_label_5 =
--SELECT unit_code, 
(SELECT  ((
minzoompoly<=5 OR
visitors_dist>300000
  ) AND (
    has_label = 't'
)) FROM label_points where label_points.unit_code = label_point_calc.unit_code);
--FROM label_point_calc;

-- Zoom level 6
ALTER TABLE label_point_calc ADD COLUMN show_label_6 boolean;
UPDATE label_point_calc SET show_label_6 =
--SELECT unit_code, 
(SELECT  ((
minzoompoly<=6 OR
visitors_dist>150000
  ) AND (
    has_label = 't'
)) FROM label_points where label_points.unit_code = label_point_calc.unit_code);
--FROM label_point_calc;

-- Zoom level 7
ALTER TABLE label_point_calc ADD COLUMN show_label_7 boolean;
UPDATE label_point_calc SET show_label_7 =
--SELECT unit_code, 
(SELECT  ((
minzoompoly<=7 OR
visitors_dist>75000
  ) AND (
    has_label = 't'
)) FROM label_points where label_points.unit_code = label_point_calc.unit_code);
--FROM label_point_calc;

-- Zoom level 8
ALTER TABLE label_point_calc ADD COLUMN show_label_8 boolean;
UPDATE label_point_calc SET show_label_8 =
--SELECT unit_code, 
(SELECT  ((
minzoompoly<=8 OR
visitors_dist>35000
  ) AND (
    has_label = 't'
)) FROM label_points where label_points.unit_code = label_point_calc.unit_code);
--FROM label_point_calc;

-- Zoom level 9
ALTER TABLE label_point_calc ADD COLUMN show_label_9 boolean;
UPDATE label_point_calc SET show_label_9 =
--SELECT unit_code, 
(SELECT  ((
minzoompoly<=8 OR
visitors_dist>20000
  ) AND (
    has_label = 't'
)) FROM label_points where label_points.unit_code = label_point_calc.unit_code);
--FROM label_point_calc;

-- Zoom level 10
ALTER TABLE label_point_calc ADD COLUMN show_label_10 boolean;
UPDATE label_point_calc SET show_label_10 =
--SELECT unit_code, 
(SELECT  ((
minzoompoly<=9 OR
visitors_dist>15000
  ) AND (
    has_label = 't'
)) FROM label_points where label_points.unit_code = label_point_calc.unit_code);
--FROM label_point_calc;

-- Zoom level 11
ALTER TABLE label_point_calc ADD COLUMN show_label_11 boolean;
UPDATE label_point_calc SET show_label_11 =
--SELECT unit_code, 
(SELECT  ((
minzoompoly<=10 OR
visitors_dist>5000
  ) AND (
    has_label = 't' AND
    urban_area > 8
)) FROM label_points where label_points.unit_code = label_point_calc.unit_code);
--FROM label_point_calc;

-- Zoom level 12
ALTER TABLE label_point_calc ADD COLUMN show_label_12 boolean;
UPDATE label_point_calc SET show_label_12 =
--SELECT unit_code, 
(SELECT  ((
minzoompoly<=11 OR
visitors_dist>2500
  ) AND (
    has_label = 't' AND
    urban_area > 8
)) FROM label_points where label_points.unit_code = label_point_calc.unit_code);
--FROM label_point_calc;

-- Zoom level 13
ALTER TABLE label_point_calc ADD COLUMN show_label_13 boolean;
UPDATE label_point_calc SET show_label_13 =
--SELECT unit_code, 
(SELECT  ((
minzoompoly<=12 OR
visitors_dist>1500
  ) AND (
    has_label = 't' AND
    urban_area > 8
)) FROM label_points where label_points.unit_code = label_point_calc.unit_code);
--FROM label_point_calc;

-- Zoom level 14
ALTER TABLE label_point_calc ADD COLUMN show_label_14 boolean;
UPDATE label_point_calc SET show_label_14 =
--SELECT unit_code, 
(SELECT  ((
minzoompoly<=13 OR
visitors_dist>1500
  ) AND (
    has_label = 't' AND
    urban_area > 8
)) FROM label_points where label_points.unit_code = label_point_calc.unit_code);
--FROM label_point_calc;

-- Zoom level 15
ALTER TABLE label_point_calc ADD COLUMN show_label_15 boolean;
UPDATE label_point_calc SET show_label_15 =
--SELECT unit_code, 
(SELECT  ((
minzoompoly<=14 OR
visitors_dist>800
  ) AND (
    has_label = 't' AND
    urban_area > 8
)) FROM label_points where label_points.unit_code = label_point_calc.unit_code);
--FROM label_point_calc;

-- Zoom level 16
ALTER TABLE label_point_calc ADD COLUMN show_label_16 boolean;
UPDATE label_point_calc SET show_label_16 =
--SELECT unit_code, 
(SELECT  ((
minzoompoly<=14 OR
visitors_dist>800
  ) AND (
    has_label = 't'
)) FROM label_points where label_points.unit_code = label_point_calc.unit_code);
--FROM label_point_calc;

--- More Custom directions

 UPDATE label_point_calc SET direction = 'NW'
  WHERE unit_code in (SELECT UNIT_CODE FROM label_points where name = 'Fort Larned');

  UPDATE label_point_calc SET direction = 'NW'
  WHERE unit_code in (SELECT UNIT_CODE FROM label_points where name = 'Joshua Tree');

  UPDATE label_point_calc SET direction = 'S'
  WHERE unit_code in (SELECT UNIT_CODE FROM label_points where name = 'Channel Islands');
  
  --[name='Sequoia']{text-placements:"W";}
  UPDATE label_point_calc SET direction = 'W'
  WHERE unit_code in (SELECT UNIT_CODE FROM label_points where name = 'Sequoia');

  --[name='Lake Mead']{text-placements:"SW";}
  UPDATE label_point_calc SET direction = 'SW'
  WHERE unit_code in (SELECT UNIT_CODE FROM label_points where name = 'Lake Mead ');

   --[name='Lake Mead']{text-placements:"SW";}
  UPDATE label_point_calc SET direction = 'SW'
  WHERE unit_code in (SELECT UNIT_CODE FROM label_points where name = 'Lake Mead');
  
  --[name='Mount Rushmore']{text-placements:"NW";} 
  UPDATE label_point_calc SET direction = 'NW'
  WHERE unit_code in (SELECT UNIT_CODE FROM label_points where name = 'Mount Rushmore');
  
  --[name='Cuyahoga Valley']{text-placements:"S";} 
  UPDATE label_point_calc SET direction = 'S'
  WHERE unit_code in (SELECT UNIT_CODE FROM label_points where name = 'Cuyahoga Valley');
  
  --[name='Sleeping Bear Dunes']{text-placements:"SE";} 
  UPDATE label_point_calc SET direction = 'SE'
  WHERE unit_code in (SELECT UNIT_CODE FROM label_points where name = 'Sleeping Bear Dunes');
  
  --[name='Isle Royale']{text-placements:"S";} 
  UPDATE label_point_calc SET direction = 'S'
  WHERE unit_code in (SELECT UNIT_CODE FROM label_points where name = 'Isle Royale');
  
  --[name='Everglades']{text-placements:"SW";}
  UPDATE label_point_calc SET direction = 'SW'
  WHERE unit_code in (SELECT UNIT_CODE FROM label_points where name = 'Everglades');
  
  --[zoom<=8][name='Whiskeytown']{text-placements:"NE";}
  UPDATE label_point_calc SET direction = 'NE'
  WHERE unit_code in (SELECT UNIT_CODE FROM label_points where name = 'Whiskeytown');
  
  --[name='Saguaro']{text-placements:"SW";}
  UPDATE label_point_calc SET direction = 'SW'
  WHERE unit_code in (SELECT UNIT_CODE FROM label_points where name = 'Saguaro');
  
  --[name='Chamizal']{text-placements:"NW";}
  UPDATE label_point_calc SET direction = 'NW'
  WHERE unit_code in (SELECT UNIT_CODE FROM label_points where name = 'Chamizal');
  
  --[name='Central High School']{text-placements:"S";}
  UPDATE label_point_calc SET direction = 'S'
  WHERE unit_code in (SELECT UNIT_CODE FROM label_points where name = 'Central High School');
  
  --[name='Fort Vancouver']{text-placements:"NE";}
  UPDATE label_point_calc SET direction = 'NE'
  WHERE unit_code in (SELECT UNIT_CODE FROM label_points where name = 'Fort Vancouver');
  
  --[name='Stones River']{text-placements:"NE";}
  UPDATE label_point_calc SET direction = 'NE'
  WHERE unit_code in (SELECT UNIT_CODE FROM label_points where name = 'Stones River');
  
  --[name='Ocmulgee']{text-placements:"SW";}
  UPDATE label_point_calc SET direction = 'SW'
  WHERE unit_code in (SELECT UNIT_CODE FROM label_points where name = 'Ocmulgee');
  
  --[name='Vanderbilt Mansion']{text-placements:"NW";}
  UPDATE label_point_calc SET direction = 'NW'
  WHERE unit_code in (SELECT UNIT_CODE FROM label_points where name = 'Vanderbilt Mansion');
  
  --[name='Harpers Ferry']{text-placements:"W";}
  UPDATE label_point_calc SET direction = 'W'
  WHERE unit_code in (SELECT UNIT_CODE FROM label_points where name = 'Harpers Ferry');
  
  --[name='Knife River Indian Villages']{text-placements:"E";}
  UPDATE label_point_calc SET direction = 'E'
  WHERE unit_code in (SELECT UNIT_CODE FROM label_points where name = 'Knife River Indian Villages');
  
  --[name='Guilford Courthouse']{text-placements:"N";}
  UPDATE label_point_calc SET direction = 'N'
  WHERE unit_code in (SELECT UNIT_CODE FROM label_points where name = 'Guilford Courthouse');

  --[name='Black Canyon of the Gunnison']{text-placements:"N";}
  UPDATE label_point_calc SET direction = 'N'
  WHERE unit_code in (SELECT UNIT_CODE FROM label_points where name = 'Black Canyon Of The Gunnison');

  --[name='Curecanti']{text-placements:"E";}
  UPDATE label_point_calc SET direction = 'E'
  WHERE unit_code in (SELECT UNIT_CODE FROM label_points where name = 'Curecanti');
