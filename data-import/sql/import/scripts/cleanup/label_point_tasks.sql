-- Fix some data problems

-- 'Theodore Roosevelt Birthplace' is named wrong in the database 

UPDATE
  label_points
SET
  name = 'Theodore Roosevelt Birthplace',
  display_name = 'Theodore Roosevelt Birthplace NHS',
  display_concatenated = 'Theodore Roosevelt Birthplace National Historic Site',
  display_state = 'New York'
WHERE
  unit_code = 'THRB';
  

-- Shorten the Denali National Park description
UPDATE
  label_points
SET
  name = 'Denali'
WHERE
  name = 'Denali National Park'

-- Shorten the Sequoia National Park description
UPDATE
  label_points
SET
  name = 'Sequoia'
WHERE
  name = 'Sequoia National Park'
 
-- move the label for WW II Valor in the PAcific to the hawaii location? (21.36,-157.95)
UPDATE
  label_points
SET
  point_geom = ST_Multi(ST_Transform(ST_GeomFromText('POINT(-157.95 21.36)', 4326), 3857)),
  label_point = ST_Multi(ST_Transform(ST_GeomFromText('POINT(-157.95 21.36)', 4326), 3857))
WHERE
  unit_code = 'VALR';
  
  
--- Shorten More Names
--"Charles Young Buffalo Soldiers National Monument"
UPDATE
  label_points
SET
  name = 'Charles Young Buffalo Soldiers'
WHERE
  name = 'Charles Young Buffalo Soldiers National Monument';
--"C&O Canal National Historical Park"
UPDATE
  label_points
SET
  name = 'C&O Canal'
WHERE
  name = 'C&O Canal National Historical Park';
--"Mary McLeod Bethune Council House National Historic Site"
UPDATE
  label_points
SET
  name = 'Mary McLeod Bethune Council House'
WHERE
  name = 'Mary McLeod Bethune Council House National Historic Site';
--"Lower Saint Croix National Scenic Riverway"
UPDATE
  label_points
SET
  name = 'Lower Saint Croix'
WHERE
  name = 'Lower Saint Croix National Scenic Riverway';
  
--select * from label_points;

-- remove some extra polygons from Lake Mead
UPDATE label_points
SET poly_geom = COALESCE(
  (SELECT geom
   FROM
     (SELECT (st_dump(poly_geom)).path, ((st_dump(poly_geom)).geom), (st_dump(poly_geom)).path @> ARRAY[5] AS path5
      FROM label_points
      WHERE unit_code = 'LAKE') a
   WHERE path5), poly_geom)
WHERE unit_code = 'LAKE';

-- A lot more changes:

---- Memorial%Memorial
--"LINC","Lincoln Memorial Memorial"
UPDATE label_points
SET display_concatenated = 'Lincoln Memorial'
WHERE UNIT_CODE = 'LINC';

--"NWWM","The National World War II Memorial Memorial"
UPDATE label_points
SET display_concatenated = 'The National World War II Memorial'
WHERE UNIT_CODE = 'NWWM';

--"THJE","Thomas Jefferson Memorial Memorial"
UPDATE label_points
SET display_concatenated = 'Thomas Jefferson Memorial'
WHERE UNIT_CODE = 'THJE';

--"VIVE","Vietnam Veterans Memorial Memorial"
UPDATE label_points
SET display_concatenated = 'Vietnam Veterans Memorial'
WHERE UNIT_CODE = 'VIVE';

--"KOWA","Korean War Veterans Memorial Memorial"
UPDATE label_points
SET display_concatenated = 'Vietnam Veterans Memorial'
WHERE UNIT_CODE = 'KOWA';

--"FRDE","Franklin Delano Roosevelt Memorial Memorial"
UPDATE label_points
SET display_concatenated = 'Franklin Delano Roosevelt Memorial'
WHERE UNIT_CODE = 'FRDE';

--
---- Monument%Monument
--"WAMO", "Washington Monument National Monument"
UPDATE label_points
SET display_concatenated = 'Washington Monument'
WHERE UNIT_CODE = 'WAMO';
--
--
--
--"CHOH";"C&O Canal";"C&O Canal National Historical Park National Historical Park"
UPDATE label_points
SET display_concatenated = 'C&O Canal National Historical Park'
WHERE UNIT_CODE = 'CHOH';

--"National Historic Site" should be "Boston African American National Historic Site" ("BOAF")
UPDATE label_points
SET display_concatenated = 'Boston African American National Historic Site'
WHERE UNIT_CODE = 'BOAF';

--"National Historic Site" should be "John F Kennedy National Historic Site" ("JOFI")
UPDATE label_points
SET display_concatenated = 'John F Kennedy National Historic Site'
WHERE UNIT_CODE = 'JOFI';


--
---- Park%Park
--"PISC";"Piscataway Park";"Piscataway Park Park"
UPDATE label_points
SET display_concatenated = 'Piscataway Park'
WHERE UNIT_CODE = 'PISC';

--"GREE";"Greenbelt Park";"Greenbelt Park Park"
UPDATE label_points
SET display_concatenated = 'Greenbelt Park'
WHERE UNIT_CODE = 'GREE';

--"CONG";"Congaree";"Congaree National Park National Park"
UPDATE label_points
SET display_concatenated = 'Congaree National Park'
WHERE UNIT_CODE = 'CONG';

--"MEHI";"Meridian Hill Park";"Meridian Hill Park Park"
UPDATE label_points
SET display_concatenated = 'Meridian Hill Park'
WHERE UNIT_CODE = 'MEHI';

--
--
---- Other Stuff
--"Martin Luther King, Jr. Memorial" ("MLKM")
UPDATE label_points
SET display_concatenated = 'Martin Luther King Jr. Memorial'
WHERE UNIT_CODE = 'MLKM';

--MABE and MAMC need to be merged
UPDATE label_points
SET has_label = false 
WHERE UNIT_CODE = 'MAMC';

--no display on "OBRI"
UPDATE label_points
SET has_label = false 
WHERE UNIT_CODE = 'OBRI';
