CREATE FUNCTION param4_sr(numeric, numeric, numeric, numeric) RETURNS numeric AS $$
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
                              WHERE (c2.in_1, c2.in_2, c2.in_3, c2.in_4) = (c.out_1, c.out_2, c.out_3, c.out_4))
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
                   bc.res 
            FROM base_cases bc
        ) UNION ALL (
            WITH e(in_1, in_2, in_3, in_4, res) AS (
            SELECT evaluation.in_1 AS in_1, 
                   evaluation.in_2 AS in_2, 
                   evaluation.in_3 AS in_3, 
                   evaluation.in_4 AS in_4, 
                   evaluation.res  AS res 
            FROM evaluation
        )
        SELECT c.in_1                    AS in_1, 
               c.in_2                    AS in_2, 
               c.in_3                    AS in_3, 
               c.in_4                    AS in_4, 
               (SELECT e.res :: numeric) AS res
        FROM callgraph c INNER JOIN e ON (e.in_1, e.in_2, e.in_3, e.in_4)
                                         = (c.out_1, c.out_2, c.out_3, c.out_4)
        WHERE c.call_site = 1)
    )
SELECT COALESCE(   (SELECT DISTINCT ON (e.res) e.res 
                    FROM evaluation AS e(in_1, in_2, in_3, in_4, res)
                    WHERE (e.in_1, e.in_2, e.in_3, e.in_4) = ($1, $2, $3, $4))
                ,  (SELECT DISTINCT NULL :: numeric FROM loop))
$$ LANGUAGE SQL;