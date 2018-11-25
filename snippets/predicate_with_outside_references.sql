-- Function
SELECT CASE
           WHEN T.v <  0 THEN 0
           ELSE f(T.v - 1)
       END
FROM (VALUES (-1), (1)) AS T(v)

-- Predicate
SELECT T.v <  0
FROM (VALUES (-1), (1)) AS T(v)

-- Allowed:-- Function
WITH T(v) AS (VALUES (-1), (1))
SELECT CASE
           WHEN T.v <  0 THEN 0
           ELSE f(T.v - 1)
       END
FROM T