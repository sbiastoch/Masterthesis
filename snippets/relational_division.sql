SELECT c.in_1                                      AS in_1,
       array_agg(e.result ORDER BY c.call_site_id) AS result
FROM callgraph c
  INNER JOIN evaluation e ON (c.out_1) = (e.in_1)
WHERE c.call_site_id IN (1, 2)
GROUP BY c.in_1
HAVING COUNT(*) = 2