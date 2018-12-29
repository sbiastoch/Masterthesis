WITH RECRUSIVE
    ...
    evaluation(in_1, res) AS (
        (TABLE basecases)
        
        UNION ALL (
            WITH e(in_1, res) AS (TABLE evaluation),
                 new_results(in_1, res) AS (
                     <evaluate recursive scenario(scenario[1])>
                       UNION ALL
                     <evaluate recursive scenario(scenario[2])>
                 )
            (SELECT e.* FROM e, (SELECT NULL FROM new_results LIMIT 1) guard)
              UNION ALL
            (TABLE new_results)
        )
    )
<result selection>