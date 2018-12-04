WITH RECURSIVE callstack(in_1, call_site, out_1) AS (
  (
    WITH pred_1(v) AS (SELECT NOT :n = 0 AND     :n = 1),
         pred_2(v) AS (SELECT NOT :n = 0 AND NOT :n = 1)
        
    ( -- scenario 1
      SELECT :n              AS in_1, 
             1               AS call_site, 
             (SELECT 0)      AS out_1
      FROM pred_1 AS p(v)
      WHERE p.v

    ) UNION (

      SELECT :n              AS in_1, 
             2               AS call_site, 
             (SELECT :n - 1) AS out_1
      FROM pred_2 AS p(v)
      WHERE p.v

      UNION

      SELECT :n              AS in_1, 
             3               AS call_site, 
             (SELECT :n - 2) AS out_1
      FROM pred_2 AS p(v)
      WHERE p.v
    )

  ) UNION (

    SELECT calls.*
    FROM callstack c, LATERAL (

      WITH pred_1(v) AS (SELECT NOT c.out_1 = 0 AND     c.out_1 = 1),
           pred_2(v) AS (SELECT NOT c.out_1 = 0 AND NOT c.out_1 = 1)
          
      (
        SELECT c.out_1              AS in_1, 
               1                    AS call_site, 
               (SELECT 0)           AS out_1
        FROM pred_1 AS p(v)
        WHERE p.v

      ) UNION (

        SELECT c.out_1              AS in_1, 
               2                    AS call_site, 
               (SELECT c.out_1 - 1) AS out_1
        FROM pred_2 AS p(v)
        WHERE p.v

        UNION

        SELECT c.out_1              AS in_1, 
               3                    AS call_site, 
               (SELECT c.out_1 - 2) AS out_1
        FROM pred_2 AS p(v)
        WHERE p.v
      )

    ) AS calls
  )
)
TABLE callstack;