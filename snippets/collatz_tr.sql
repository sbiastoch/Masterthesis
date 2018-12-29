CREATE FUNCTION collatz_tr(n NUMERIC, l NUMERIC)
RETURNS NUMERIC AS $$
  SELECT CASE
    WHEN n = 1      THEN l
    WHEN n % 2 = 0 THEN collatz_tr(n/2, l+1)
    ELSE collatz_tr(3*n+1, l+1)
  END
$$ LANGUAGE SQL;
