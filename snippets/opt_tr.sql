WITH RECURSIVE
    callgraph AS (
      ((SELECT NULL, $1)
         UNION ALL ... -- unchanged
      ) UNION ... -- unchanged
    ),
    basecases AS (...), -- unchanged
    -- no evaluation
    loop      AS (...)  -- unchanged
SELECT
  COALESCE(
    (SELECT b.result FROM basecases b),
    (SELECT DISTINCT NULL::NUMERIC FROM loop)
  )