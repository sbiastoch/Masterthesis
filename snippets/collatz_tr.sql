CREATE OR REPLACE FUNCTION collatz_tr(n numeric, l numeric)
RETURNS numeric AS
$$
  SELECT CASE
    WHEN n = 1      THEN l
    WHEN n % 2 = 0 THEN collatz_tr(n/2, l+1)
    ELSE collatz_tr(3*n+1, l+1)
  END
$$ LANGUAGE SQL;
