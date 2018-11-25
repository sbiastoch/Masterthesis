SELECT 1 WHERE n <= 2
  UNION
SELECT fib(n - 1) + fib(n - 2) WHERE n > 2