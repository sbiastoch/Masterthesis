WITH RECURSIVE
  ...
  loop AS (
    SELECT NULL
      UNION ALL
    TABLE loop
   )
SELECT
  COALESCE(
    (SELECT e.res FROM evaluation e WHERE (e.in_1) = ($1)),
    (SELECT DISTINCT NULL::<return type> FROM loop)
  )