
-- Some name corrections

--"Baltimore National Heritage Area" needs to be named "Baltimore"
UPDATE label_points SET name = 'Baltimore' WHERE name = 'Baltimore National Heritage Area';
--"congaree national park" needs to be changed to "congaree" for name
UPDATE label_points SET name = 'Congaree' WHERE name = 'Congaree National Park';

-- Illinois & Michigan Canal has a space after it for some reason
UPDATE label_points set name = 'Illinois & Michigan Canal' where name like 'Illinois & Michigan Canal%';

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

