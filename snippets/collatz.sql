CREATE FUNCTION collatz(n numeric) RETURNS numeric AS $$
  SELECT CASE
    WHEN n = 1     THEN 1
    WHEN n % 2 = 0 THEN 1 + collatz(n/2)
    ELSE 1 + collatz(3*n+1)
  END
$$ LANGUAGE SQL;
