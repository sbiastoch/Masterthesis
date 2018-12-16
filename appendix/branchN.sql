CREATE OR REPLACE FUNCTION branch2(NUMERIC)
  RETURNS NUMERIC LANGUAGE SQL
AS $$
SELECT CASE WHEN $1 < 0 THEN 1
            ELSE branch2($1 - 1) + branch2($1 - 1)
       END
$$;

CREATE OR REPLACE FUNCTION branch3(NUMERIC)
  RETURNS NUMERIC LANGUAGE SQL
AS $$
SELECT CASE WHEN $1 < 0 THEN 1
            ELSE branch3($1 - 1) + branch3($1 - 1) + branch3($1 - 1)
       END
$$;

CREATE OR REPLACE FUNCTION branch4(NUMERIC)
  RETURNS NUMERIC LANGUAGE SQL
AS $$
SELECT CASE WHEN $1 < 0 THEN 1
            ELSE branch4($1 - 1) + branch4($1 - 1) + branch4($1 - 1) + branch4($1 - 1)
       END
$$;