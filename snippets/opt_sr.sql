<eval_recursive_scenario_sr(call_site_1)> :=
  SELECT 
    c.in_1                                                                      AS in_1, 
    <scenario.query[c.in_1 / $1, e.result / fib(scenario.callsites[1].arg_1)] > AS res 
  FROM callgraph c INNER JOIN evaluation e ON (e.in_1) IS NOT DISTINCT FROM (c.out_1)