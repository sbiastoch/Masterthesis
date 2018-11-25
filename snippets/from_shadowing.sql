WITH T(v) AS (SELECT f(n))     -- 1. $T = \{T\}$
SELECT CASE                    -- 2. $\hasCallsite(\{T\} \setminus \{T\}, T.v) = FALSE \text{do not add new T}$
           WHEN T.v = 0 THEN 1 --    entire CASE is considered a basecase 
           ELSE 42
       END
FROM (SELECT f(n)) AS T(v) -- 3. $T = \{T\} \setminus \{T\} \cup \{T\}$
                           -- (remove existing T due to shadowing and new T as it is recursive)





WITH T(v) AS (SELECT f(n)) -- recursive CTE
SELECT T.v
FROM (SELECT 1) AS T(v)    -- overrides recursive CTE by a nonrecursive one => Query is nonrecursive

-- Recursive case:
SELECT
    (SELECT T.v FROM (SELECT 1) AS T(v)) -- cannot access outer (recursive) T
FROM (SELECT f(n)) AS T(v)

-- Recursive case:
WITH T(v) AS (SELECT f(n))
SELECT
    (SELECT T.v FROM (SELECT 1) AS T(v)) -- cannot access outer (recursive) T
FROM T