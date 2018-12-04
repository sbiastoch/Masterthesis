CREATE OR REPLACE FUNCTION sieve(i int, xs int [])
  RETURNS int [] AS $$
SELECT array_agg(T.v)
FROM
  unnest(xs) AS T(v)
WHERE
  CASE
    WHEN i - 1 > array_length(xs, 1) / 2 THEN TRUE
    ELSE (T.v = i -- keep current i
          OR T.v % i != 0)-- remove all multiples of i
         AND T.v = ANY (sieve(i + 1, xs)) -- keep only other nonprime numbers
  END;
$$ LANGUAGE SQL;