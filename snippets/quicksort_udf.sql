CREATE FUNCTION quicksort(arr int []) RETURNS int [] STRICT AS $$
WITH
	pivot(idx) AS (
		SELECT array_length(arr, 1) / 2 + 1
	),
	except_pivot(arr) AS (
		SELECT unnest(arr[: (pivot.idx - 1)] || arr[(pivot.idx + 1) : ]) FROM pivot
	),
	lower(v) AS (
		SELECT array_agg(A.v) FROM except_pivot A(v), pivot WHERE A.v < arr[pivot.idx]
	),
	higher(v) AS (
		SELECT array_agg(A.v) FROM except_pivot A(v), pivot WHERE A.v >= arr[pivot.idx]
	)
SELECT CASE
	WHEN arr = ARRAY[]::INT[] THEN ARRAY[] :: INT[]
	ELSE quicksort(COALESCE((SELECT lower.v FROM lower), ARRAY[]::INT[]))
	       || (SELECT arr[pivot.idx] FROM pivot)
	       || quicksort(COALESCE((SELECT higher.v FROM higher), ARRAY[]::INT[]))
END
$$ LANGUAGE SQL;