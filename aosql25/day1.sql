-- Using the wish_list table, count how many times each cleaned toy name appears, from most requested to least requested.
-- Return the results in two columns: wish and count.
-- Make sure the wish results have no extra leading or trailing spaces and are all lowercase.

SELECT
	LOWER(TRIM(raw_wish)) AS wish,
	count(*)
FROM wish_list
GROUP BY 1
ORDER BY 2 DESC
