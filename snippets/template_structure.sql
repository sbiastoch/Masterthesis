CREATE FUNCTION f(INT) RETURNS INT AS $$
  WITH RECURSIVE
    callstack(arg_1, callsite_id, call_arg_1) AS (
      <collect initial callsites>
        UNION
      <collect subsequent callsites>
    ),
    evaluation(arg_1, result) AS (
      <evaluate basecases>
        UNION
      <evaluate recursive scenarios>
    )
  SELECT e.result FROM evaluation e WHERE e.in_arg_1 = $1
$$ LANGUAGE SQL;