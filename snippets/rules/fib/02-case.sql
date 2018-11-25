(TRUE|${}_1$|,
 CASE WHEN |\udfArg{1}| <= 1 THEN n ELSE ... END) -> (
    {(TRUE|${}_1$| AND TRUE|${}_2$| AND 1 <= 1 AND TRUE|${}_3$|, n)},
    {(TRUE|${}_1$| AND NOT |\udfArg{1}| <= 1, fib(|\udfArg{1}| - 1) + fib(|\udfArg{1}| - 2))}
)