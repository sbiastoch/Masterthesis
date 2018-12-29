<eval_recursive_scenario(call_site_1, ..., call_site_n)> :=
  SELECT 
    results.in_1                                                                    AS in_1, 
    <scenario.query[results.in_1 / $1,
                    results.call_1 / fib(scenario.callsites[1].arg_1),
                                        ...
                    results.call_n / fib(scenario.callsites[n].arg_n)]>::<arg type> AS res 
  FROM ( -- Table (c)
    SELECT c.in_1                       AS in_1, 
           nth_value(e.res,  1 ) OVER w AS call_1, 
                             ...
           nth_value(e.res, <n>) OVER w AS call_<n>, 
           count(*) OVER w              AS count
    FROM
      callgraph c INNER JOIN evaluation e ON (e.in_1) = (c.out_1) -- Table (b)
    WHERE NOT EXISTS (SELECT NULL FROM e WHERE (e.in_1) = (c.in_1) ) -- (1)
      AND c.callsite_id IN (<call_site_1.id>, ..., <call_site_n.id>) -- (2)
    WINDOW w AS (PARTITION BY (c.in_1) ORDER BY (c.call_site) RANGE UNBOUNDED PRECEDING)
  ) AS results 
  WHERE results.count = <n> -- (3)