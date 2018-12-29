CREATE FUNCTION f(INT) RETURNS INT AS $$
  WITH RECURSIVE
    callstack(in_1, callsite_id, out_1) AS (
      <collect initial callsites>
        UNION
      <collect subsequent callsites>
    ),
    evaluation(in_1, result) AS (
      <evaluate basecases>
        UNION ALL
      <evaluate recursive scenarios>
    )
  SELECT e.result FROM evaluation e WHERE (e.in_1) = ($1)
$$ LANGUAGE SQL;