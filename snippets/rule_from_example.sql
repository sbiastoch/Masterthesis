-- Function:
SELECT S.u + T.v
FROM (SELECT CASE
        WHEN U.w <  0 THEN 0
        ELSE f(U.w - 1) END
      FROM (SELECT n) AS U(w)
     ) AS S(u),
     (SELECT CASE
        WHEN U.w < 10 THEN f(U.w - 2)
        ELSE 1 END
      FROM (SELECT n) AS U(w)
     ) AS T(v)

-- Scenario 1: SELECT (SELECT U.w <  0 FROM (SELECT n) AS U(w))
--                AND (SELECT U.w < 10 FROM (SELECT n) AS U(w))
SELECT S.u + T.v
FROM (SELECT 0       ) AS S(u),
     (SELECT f(n - 2)) AS T(v)
     
-- Scenario 2: SELECT (SELECT NOT U.w <  0 FROM (SELECT n) AS U(w))
--                AND (SELECT U.w < 10 FROM (SELECT n) AS U(w))
SELECT S.u + T.v
FROM (SELECT f(n - 1)) AS S(u),
     (SELECT f(n - 2)) AS T(v)
     
-- Scenario 3: SELECT (SELECT U.w <  0 FROM (SELECT n) AS U(w))
--                AND (SELECT NOT U.w < 10 FROM (SELECT n) AS U(w))
SELECT S.u + T.v
FROM (SELECT 0 ) AS S(u),
     (SELECT 1 ) AS T(v)
     
-- Scenario 4: SELECT (SELECT NOT U.w <  0 FROM (SELECT n) AS U(w))
--                AND (SELECT NOT U.w < 10 FROM (SELECT n) AS U(w))
SELECT S.u + T.v
FROM (SELECT f(n - 1)) AS S(u),
     (SELECT 1       ) AS T(v)