CREATE OR REPLACE FUNCTION gcd(a INT, b INT)
  RETURNS INT LANGUAGE SQL
AS $$
SELECT CASE WHEN a = b
              THEN a
            WHEN a > b
              THEN gcd(a - b, b)
            WHEN a < b
              THEN gcd(a, b - a)
       END
$$;

-- Recursive-Cases:
SELECT gcd(a - b, b);
SELECT gcd(a, b - a);
