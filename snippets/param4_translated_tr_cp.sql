CREATE FUNCTION param4(numeric, numeric, numeric, numeric) RETURNS numeric AS $$
WITH RECURSIVE
    callgraph(in_1, out_1) AS (
        (
            WITH pred_1(v) AS (SELECT NOT $1 < 0)
            (   SELECT NULL AS in_1, 
                     $1   AS out_1
            ) UNION (
                SELECT $1              AS in_1, 
                       (SELECT $1 - 1) AS out_1, 
                FROM pred_1 AS p(v)
                WHERE p.v
            )   
        ) UNION (
            SELECT c.out_1         AS in_1, 
                   calls.out_1     AS out_1, 
            FROM (SELECT c.out_1 AS out_1, 
                  FROM callgraph AS c) AS c(out_1),
                LATERAL (
                    WITH pred_1(v) AS (SELECT NOT c.out_1 < 0)
                    SELECT (SELECT c.out_1 - 1) AS out_1, 
                    FROM pred_1 AS p(v)
                    WHERE p.v
                ) AS calls(out_1)
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
                c.out_1 AS out_1,
            FROM callgraph AS c
            WHERE NOT EXISTS (SELECT NULL
                              FROM callgraph AS c2 
                              WHERE (c2.in_1) = (c.out_1))
        )
        SELECT c.out_1                          AS in_1, 
               (SELECT $2 + $3 + $4) :: numeric AS res 
        FROM c
        WHERE (SELECT c.out_1 < 0)
    )
SELECT COALESCE(   (SELECT b.res FROM base_cases b)
                ,  (SELECT DISTINCT NULL :: numeric FROM loop))
$$ LANGUAGE SQL;