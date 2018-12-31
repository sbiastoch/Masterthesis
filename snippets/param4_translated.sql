CREATE OR REPLACE FUNCTION param4(numeric, numeric, numeric, numeric) RETURNS numeric AS $$
WITH RECURSIVE
    callgraph(in_1, in_2, in_3, in_4, call_site, out_1, out_2, out_3, out_4) AS (
        (
            WITH pred_1(v) AS (SELECT NOT $1 < 0)
            (   SELECT NULL AS in_1, 
                     NULL AS in_2, 
                     NULL AS in_3, 
                     NULL AS in_4, 
                     0    AS call_site,
                     $1   AS out_1,
                     $2   AS out_2,
                     $3   AS out_3,
                     $4   AS out_4
            ) UNION (
                SELECT $1              AS in_1, 
                       $2              AS in_2, 
                       $3              AS in_3, 
                       $4              AS in_4, 
                       1               AS call_site, 
                       (SELECT $1 - 1) AS out_1, 
                       (SELECT $2)     AS out_2, 
                       (SELECT $3)     AS out_3, 
                       (SELECT $4)     AS out_4 
                FROM pred_1 AS p(v)
                WHERE p.v
            )   
        ) UNION (
            SELECT c.out_1         AS in_1, 
                   c.out_2         AS in_2, 
                   c.out_3         AS in_3, 
                   c.out_4         AS in_4, 
                   calls.call_site AS call_site, 
                   calls.out_1     AS out_1, 
                   calls.out_2     AS out_2, 
                   calls.out_3     AS out_3, 
                   calls.out_4     AS out_4 
            FROM (SELECT c.out_1 AS out_1, 
                         c.out_2 AS out_2, 
                         c.out_3 AS out_3, 
                         c.out_4 AS out_4
                  FROM callgraph AS c) AS c(out_1, out_2, out_3, out_4),
                LATERAL (
                    WITH pred_1(v) AS (SELECT NOT c.out_1 < 0)
                    SELECT 1                    AS call_site, 
                           (SELECT c.out_1 - 1) AS out_1, 
                           (SELECT c.out_2)     AS out_2, 
                           (SELECT c.out_3)     AS out_3, 
                           (SELECT c.out_4)     AS out_4 
                    FROM pred_1 AS p(v)
                    WHERE p.v
                ) AS calls(call_site, out_1, out_2, out_3, out_4)
        )
    ), 
    loop(v) AS (
        (SELECT NULL)
            UNION ALL
        (SELECT NULL FROM loop)
    ), 
    base_cases(in_1, in_2, in_3, in_4, res) AS (
        WITH c(out_1, out_2, out_3, out_4) AS (
            SELECT DISTINCT ON (c.out_1, c.out_2, c.out_3, c.out_4)
                c.out_1 AS out_1,
                c.out_2 AS out_2,
                c.out_3 AS out_3,
                c.out_4 AS out_4
            FROM callgraph AS c
            WHERE NOT EXISTS (SELECT NULL
                              FROM callgraph AS c2 
                              WHERE (c2.in_1, c2.in_2, c2.in_3, c2.in_4) 
                                    = (c.out_1, c.out_2, c.out_3, c.out_4))
        )
        
        
        
        SELECT c.out_1                                         AS in_1, 
               c.out_2                                         AS in_2, 
               c.out_3                                         AS in_3, 
               c.out_4                                         AS in_4, 
               (SELECT c.out_2 + c.out_3 + c.out_4) :: numeric AS res 
        FROM c
        WHERE (SELECT c.out_1 < 0)
    ), 
    evaluation(in_1, in_2, in_3, in_4, res) AS (
        (   SELECT bc.in_1 AS in_1, 
                   bc.in_2 AS in_2, 
                   bc.in_3 AS in_3, 
                   bc.in_4 AS in_4, 
                   bc.res  AS res
            FROM base_cases AS bc(in_1, in_2, in_3, in_4, res)
        ) UNION ALL (
            WITH e(in_1, in_2, in_3, in_4, res) AS (
                SELECT evaluation.in_1 AS in_1, 
                       evaluation.in_2 AS in_2, 
                       evaluation.in_3 AS in_3, 
                       evaluation.in_4 AS in_4, 
                       evaluation.res  AS res 
                FROM evaluation
            ), 
            new_results(in_1, in_2, in_3, in_4, res) AS (
                SELECT arg_res.in_1                AS in_1, 
                       arg_res.in_2                AS in_2, 
                       arg_res.in_3                AS in_3, 
                       arg_res.in_4                AS in_4, 
                       (SELECT arg_res.res_call_1) AS res
                FROM (
                    SELECT c.in_1                     AS in_1, 
                           c.in_2                     AS in_2, 
                           c.in_3                     AS in_3, 
                           c.in_4                     AS in_4, 
                           nth_value(e.res, 1) OVER w AS res_call_1, 
                           count(*) OVER w            AS res_count
                    FROM callgraph c INNER JOIN e ON (e.in_1, e.in_2, e.in_3, e.in_4) 
                                                        = (c.out_1, c.out_2, c.out_3, c.out_4)
                    WHERE NOT EXISTS (SELECT NULL 
                                      FROM e
                                      WHERE (e.in_1, e.in_2, e.in_3, e.in_4) 
                                               = (c.in_1, c.in_2, c.in_3, c.in_4))
                           AND c.call_site = ANY(ARRAY[1])
                    WINDOW w AS (PARTITION BY (c.in_1, c.in_2, c.in_3, c.in_4) 
                                 ORDER BY (c.call_site) ASC RANGE UNBOUNDED PRECEDING)
                ) AS arg_res(in_1, in_2, in_3, in_4, res_call_1, res_count)
                WHERE arg_res.res_count = 1
            )
            (   SELECT e.in_1 AS in_1,
                       e.in_2 AS in_2,
                       e.in_3 AS in_3,
                       e.in_4 AS in_4,
                       e.res  AS res 
                FROM (SELECT NULL FROM new_results LIMIT 1) AS guard, e
            ) UNION ALL (
                SELECT new_results.in_1 AS in_1, 
                       new_results.in_2 AS in_2, 
                       new_results.in_3 AS in_3, 
                       new_results.in_4 AS in_4, 
                       new_results.res  AS res 
                FROM new_results
            )
        )
    )
SELECT COALESCE(   (SELECT DISTINCT e.res 
                    FROM evaluation AS e(in_1, in_2, in_3, in_4, res)
                    WHERE (e.in_1, e.in_2, e.in_3, e.in_4) = ($1, $2, $3, $4))
                ,  (SELECT DISTINCT NULL :: numeric FROM loop))
$$ LANGUAGE SQL;