-- Function
SELECT CASE
        WHEN n <  0 THEN 0
        ELSE f(n - 1) END
FROM (SELECT n) AS T(v)

-- Scenario 1: SELECT n < 0
SELECT 0 FROM (SELECT n) AS T(v)

-- Scenario 2: SELECT NOT n < 0
SELECT f(T.v - 1) FROM (SELECT n) AS T(v)