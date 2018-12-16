collect_calls(scenario, out_1)
    := UNION |$_{\text{callsite} \in \text{callsites\_id\_of(scenario)}} $| SELECT out_1, evaluate_param_1_with_params(out_1) 
                                     FROM pred_of(scenario) AS p(v)
                                     WHERE NOT p.v

WITH RECURSIVE discovery(in_1, call_site, out_1) AS (
       |$\bigcup $|    collect_calls(scenario, $1)
 |$^{\text{recursive scenarios}} $| 
    UNION
    
    SELECT calls.*
    FROM discovery AS d,
      LATERAL (
           |$ \bigcup$|    collect_calls(scenario, d.out_1)
     |$ ^{\text{recursive scenarios}} $| 
      ) AS calls(in_1, call_site, out_1)
)