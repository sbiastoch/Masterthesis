CREATE OR REPLACE FUNCTION fib_tr(n0 NUMERIC, -- fib(n-2)
	                              n1 NUMERIC, -- fib(n-1)
	                              n NUMERIC,
	                              nmax NUMERIC)
RETURNS NUMERIC AS $$
	SELECT CASE WHEN n = nmax THEN n0
			    ELSE fib_tr(n1, n0 + n1, n + 1, nmax)
		   END
$$ LANGUAGE SQL;