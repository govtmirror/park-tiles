-- http://stackoverflow.com/questions/10621897/replace-blank-spaces-with-null-values
CREATE OR REPLACE FUNCTION f_empty_to_null(_tbl regclass
                                               , OUT updated_rows int) AS
$func$
DECLARE
   _typ  CONSTANT regtype[] := '{text, bpchar, varchar}';  -- basic char types
   _sql  text;
BEGIN

-- Build command
SELECT INTO _sql
       'UPDATE ' || _tbl
       || E'\nSET    '
       || string_agg(
            format($$%1$s = CASE WHEN %1$s = '' THEN NULL ELSE %1$s END$$, col)
           ,E'\n      ,')
       || E'\nWHERE  ' || string_agg(col || $$ = ''$$, ' OR ')
FROM  (
   SELECT quote_ident(attname) AS col
   FROM   pg_attribute
   WHERE  attrelid = _tbl              -- valid, visible, legal table name 
   AND    attnum >= 1                  -- exclude tableoid & friends
   AND    NOT attisdropped             -- exclude dropped columns
   AND    NOT attnotnull               -- exclude columns defined NOT NULL!
   AND    atttypid = ANY(_typ)         -- only character types
   ORDER  BY attnum
   ) sub;


-- Execute
IF _sql IS NULL THEN
   updated_rows := 0;                        -- nothing to update
ELSE
   EXECUTE _sql;
   GET DIAGNOSTICS updated_rows = ROW_COUNT; -- Report number of affected rows
END IF;

RETURN;
END
$func$  LANGUAGE plpgsql;
