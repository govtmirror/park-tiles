--ALTER TABLE label_point_calc ADD COLUMN show_label_zoom integer;

/*UPDATE
  label_point_calc
SET
  show_label_zoom =  CASE 
  WHEN show_label_5 THEN 5
  WHEN show_label_6 THEN 6
  WHEN show_label_7 THEN 7
  WHEN show_label_8 THEN 8
  WHEN show_label_9 THEN 9
  WHEN show_label_10 THEN 10
  WHEN show_label_11 THEN 11
  WHEN show_label_12 THEN 12
  WHEN show_label_13 THEN 13
  WHEN show_label_14 THEN 14
  WHEN show_label_15 THEN 15
  WHEN show_label_16 THEN 16
  ELSE 17
END;*/

select * from label_point_calc limit 100;

-- Lake Mead 6
UPDATE label_point_calc SET show_label_zoom = 6 WHERE unit_code = 'LAKE';

-- Canyonlands 6
UPDATE label_point_calc SET show_label_zoom = 6 WHERE unit_code = 'CANY';

-- Craters of the moon 6
UPDATE label_point_calc SET show_label_zoom = 6 WHERE unit_code = 'CRMO';

-- "Cuyahoga Valley" 6
UPDATE label_point_calc SET show_label_zoom = 6 WHERE unit_code = 'CUVA';

-- Women's Rights 7
UPDATE label_point_calc SET show_label_zoom = 7 WHERE unit_code = 'WORI';

-- Fort Stanwix 7
UPDATE label_point_calc SET show_label_zoom = 7 WHERE unit_code = 'FOST';


-- George Washington 10
UPDATE label_point_calc SET show_label_zoom = 10 WHERE unit_code = 'GWMP';

-- New York City Parks
-- STLI NW 11
UPDATE label_point_calc SET show_label_zoom = 11, direction = 'NW' WHERE unit_code = 'STLI';

-- Castle Clinton 13 W
UPDATE label_point_calc SET show_label_zoom = 13, direction = 'W' WHERE unit_code = 'CACL';

-- African Burial 13 W
UPDATE label_point_calc SET show_label_zoom = 13, direction = 'W' WHERE unit_code = 'AFBG';

-- "Thaddeus Kosciuszko" 14 W ??
--UPDATE label_point_calc SET show_label_zoom = 14, direction = 'W' WHERE unit_code = 'THKO';

-- Federal Hall 14 E
UPDATE label_point_calc SET show_label_zoom = 14, direction = 'E' WHERE unit_code = 'FEHA';


-- Rosie 11
UPDATE label_point_calc SET show_label_zoom = 11 WHERE unit_code = 'RORI';



-- Indiana Dunes 6
UPDATE label_point_calc SET show_label_zoom = 6 WHERE unit_code = 'INDU';

-- Sleeping Bear Dunes - NE - 6
UPDATE label_point_calc SET show_label_zoom = 6 WHERE unit_code = 'SLBE';

-- Dayton Aviation - 6
UPDATE label_point_calc SET show_label_zoom = 6 WHERE unit_code = 'DAAV';

-- Ronald Reagan Boyhood - 7
UPDATE label_point_calc SET show_label_zoom = 7 WHERE unit_code = 'RRBH';

-- "Guilford Courthouse" - 8
UPDATE label_point_calc SET show_label_zoom = 8 WHERE unit_code = 'GUCO';

-- Abe Lincoln Birthplace NE
UPDATE label_point_calc SET direction = 'NE' WHERE unit_code = 'ABLI';

-- Catoctin N
UPDATE label_point_calc SET direction = 'N' WHERE unit_code = 'CATO';


-- Fort Washington 10
UPDATE label_point_calc SET show_label_zoom = 10 WHERE unit_code = 'FOWA';


-- "World War II Valor in the Pacific" - 6 N
UPDATE label_point_calc SET show_label_zoom = 6, direction = 'N' WHERE unit_code = 'VALR';

-- "Pu`uhonua O Honaunau" NW
UPDATE label_point_calc SET direction = 'NW' WHERE unit_code = 'PUHO';

-- "Christiansted" - SW
UPDATE label_point_calc SET direction = 'SW' WHERE unit_code = 'CHRI';

-- Virgin Islands - NE
UPDATE label_point_calc SET direction = 'NE' WHERE unit_code = 'VIIS';

-- San Juan SW
UPDATE label_point_calc SET direction = 'SW' WHERE unit_code = 'SAJU';


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
WHERE UNIT_CODE = 'MAMC'

--no display on "OBRI"
UPDATE label_points
SET has_label = false 
WHERE UNIT_CODE = 'OBRI'

--Whitman at 7
UPDATE label_point_calc
SET show_label_zoom = 7 
WHERE UNIT_CODE = 'WHMI'
