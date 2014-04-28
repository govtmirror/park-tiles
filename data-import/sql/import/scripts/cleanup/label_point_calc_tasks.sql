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

--Whitman at 7
UPDATE label_point_calc
SET show_label_zoom = 7 
WHERE UNIT_CODE = 'WHMI';
