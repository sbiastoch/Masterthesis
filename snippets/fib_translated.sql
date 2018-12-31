CREATE OR REPLACE FUNCTION fib(numeric) RETURNS numeric AS $$
WITH RECURSIVE
    callgraph(in_1, call_site, out_1) AS (
        (
            WITH pred_1(v) AS (SELECT NOT $1 <= 2)
            (
                (   SELECT NULL AS in_1, 
                           0    AS call_site,
                           $1   AS out_1
                ) UNION (
                    SELECT $1              AS in_1, 
                           1               AS call_site, 
                           (SELECT $1 - 1) AS out_1
                    FROM pred_1 AS p(v)
                    WHERE p.v
                )        
            ) UNION (
                SELECT $1              AS in_1, 
                       2               AS call_site, 
                       (SELECT $1 - 2) AS out_1
                FROM pred_1 AS p(v)
                WHERE p.v
            )
        ) UNION (
            SELECT c.out_1 AS in_1, 
                   calls.call_site, 
                   calls.out_1 AS out_1 
            FROM (SELECT c.out_1 FROM callgraph AS c) AS c(out_1),
                LATERAL (
                    WITH pred_1(v) AS (SELECT NOT c.out_1 <= 2)
                    (   SELECT 1                    AS call_site, 
                               (SELECT c.out_1 - 1) AS out_1
                        FROM pred_1 AS p(v)
                        WHERE p.v
                    ) UNION (
                        SELECT 2                    AS call_site,
                               (SELECT c.out_1 - 2) AS out_1
                        FROM pred_1 AS p(v)
                        WHERE p.v
                    )
                ) AS calls(call_site, out_1)
        )
    ), 
    loop(v) AS (
        (SELECT NULL)
            UNION ALL
        (SELECT NULL FROM loop)
    ), 
    base_cases(in_1, res) AS (
        WITH c(out_1) AS (
            SELECT DISTINCT ON (c.out_1)
               c.out_1 AS out_1 
            FROM callgraph AS c
            WHERE NOT EXISTS (SELECT NULL
                              FROM callgraph AS c2 
                              WHERE (c2.in_1) = (c.out_1))
        )
        SELECT c.out_1               AS in_1, 
               (SELECT 1 :: numeric) AS res 
        FROM c
        WHERE (SELECT c.out_1 <= 2)
    ), 
    evaluation(in_1, res) AS (
        (   SELECT bc.in_1 AS in_1, 
                   bc.res  AS res
            FROM base_cases AS bc(in_1, res)
        ) UNION ALL (
            WITH e(in_1, res) AS (
                SELECT evaluation.in_1 AS in_1, 
                       evaluation.res  AS res 
                FROM evaluation
            ), 
            new_results(in_1, res) AS (
                SELECT arg_res.in_1                                              AS in_1, 
                       (SELECT arg_res.res_call_1) + (SELECT arg_res.res_call_2) AS res
                FROM (
                    SELECT c.in_1                     AS in_1, 
                           nth_value(e.res, 1) OVER w AS res_call_1, 
                           nth_value(e.res, 2) OVER w AS res_call_2, 
                           count(*) OVER w            AS res_count
                    FROM callgraph c INNER JOIN e ON (e.in_1) = (c.out_1)
                    WHERE NOT EXISTS (SELECT NULL 
                                      FROM e
                                      WHERE (e.in_1) = (c.in_1))
                           AND c.call_site = ANY(ARRAY[1, 2])
                    WINDOW w AS (PARTITION BY (c.in_1) 
                                 ORDER BY (c.call_site) ASC RANGE UNBOUNDED PRECEDING)
                ) AS arg_res(in_1, res_call_1, res_call_2, res_count)
                WHERE arg_res.res_count = 2
            )
            (   SELECT e.in_1 AS in_1,
                       e.res  AS res 
                FROM (SELECT NULL FROM new_results LIMIT 1) AS guard, e
            ) UNION ALL (
                SELECT new_results.in_1 AS in_1, 
                       new_results.res  AS res 
                FROM new_results
            )
        )
    )
SELECT COALESCE(   (SELECT DISTINCT ON (e.res) e.res 
                    FROM evaluation AS e(in_1, res)
                    WHERE (e.in_1) = ($1))
                ,  (SELECT DISTINCT NULL :: numeric FROM loop))
$$ LANGUAGE SQL;