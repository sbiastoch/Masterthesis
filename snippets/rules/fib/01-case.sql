(TRUE, CASE ... END) -> (
	{(TRUE AND $1 <= 1,
	  n)},
	{(TRUE AND NOT $1 <= 1,
	  fib($1 - 1) + fib($1 - 2))}
)