-- COALESCE(a, b, c) 
WITH 
  a_val AS a,
  b_val AS b,
  c_val AS c
SELECT CASE
  WHEN a_val IS NOT NULL THEN a_val
  WHEN b_val IS NOT NULL THEN b_val
  ELSE c_val  
END

-- NULLIF(a, b)
WITH
  a_val AS a
SELECT CASE
  WHEN a_val = b THEN NULL
  ELSE a_val
END

-- GREATEST(a, b, c)
WITH 
  a_val AS a,
  b_val AS b,
  c_val AS c
SELECT CASE
  WHEN a_val >= b_val AND a_val >= c_val THEN a_val
  WHEN b_val >= a_val AND b_val >= c_val THEN b_val
  ELSE c_val
END

-- LEAST(a, b, c)
WITH 
  a_val AS a,
  b_val AS b,
  c_val AS c
SELECT CASE
  WHEN a_val <= b_val AND a_val <= c_val THEN a_val
  WHEN b_val <= a_val AND b_val <= c_val THEN b_val
  ELSE c_val
END