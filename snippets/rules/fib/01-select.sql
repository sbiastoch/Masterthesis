(TRUE, SELECT CASE ... END) -> (
	{(SELECT TRUE AND $1 <= 1,
	  SELECT n)},
	{(SELECT TRUE AND NOT $1 <= 1,
	  SELECT fib($1 - 1) + fib($1 - 2))}
)