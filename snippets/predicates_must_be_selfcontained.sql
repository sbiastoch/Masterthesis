SELECT CASE WHEN g(n) THEN TRUE f(n-1) -- executed 1000x
            ELSE FALSE
       END
FROM generate_series(1, 1000);

-- becomes during discovery

WITH p_1(v) AS (SELECT g(n)) -- executed 1x
SELECT
    1                                            AS callsite,
    (SELECT f(n-1) FROM generate_series(1, 1000) AS param_1
WHERE p_1.v