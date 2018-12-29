WITH
  V(i) AS (SELECT 1),
  S(i) AS (SELECT fib_cte(n - (SELECT V.i FROM V))),
  T(i) AS (SELECT fib_cte(n - 2)),
  U(i) AS (SELECT CASE
  				    WHEN n > 0 THEN (SELECT S.i + T.i FROM S, T)
  			     	ELSE (SELECT V.i FROM V)
		          END
  		  ),
  P(i) AS (SELECT n <= 2)
SELECT
  CASE
    WHEN (SELECT P.i FROM P) THEN (SELECT V.i FROM V)
    ELSE (SELECT U.i FROM U)
END