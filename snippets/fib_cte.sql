WITH
  P(i) AS (SELECT 1),
  T(i) AS (SELECT fib_cte(n-1)),
  S(i) AS (SELECT CASE
             WHEN n <> 3 THEN fib_cte(n-2)
             ELSE (SELECT P.i FROM P )
           END)
SELECT
  CASE
    WHEN n <= 2 THEN (SELECT P.i FROM P)
    ELSE (SELECT T.i + S.i FROM S, T)
END