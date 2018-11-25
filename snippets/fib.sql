CREATE FUNCTION fib(int) RETURNS int AS $$
    SELECT CASE
        WHEN $1 = 0 THEN 0
        WHEN $1 = 1 THEN 1 + fib(0)
        ELSE fib($1 - 1) + fib($1 - 2)
    END;
$$ LANGUAGE SQL;