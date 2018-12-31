<eval_recursive_scenario_sr(scenario)> :=
  SELECT 
    c.in_1                                                         AS in_1, 
    <scenario.query[c.in_1 / $1,
                    e.result / fib(scenario.callsites[1].arg_1)] > AS res 
  FROM callgraph c INNER JOIN evaluation e ON (e.in_1) = (c.out_1)