-- Generate a report that returns the dates and families that have no delivery assigned after December 14th, using the families and deliveries_assigned.
-- Each row in the report should be a date and family name that represents the dates in which families don't have a delivery assigned yet.
-- Label the columns as unassigned_date and name. Order the results by unassigned_date and name, respectively, both in ascending order.

WITH dates AS (
	SELECT generate_series(
		'2025-12-15'::date,
		'2025-12-31'::date,
		INTERVAL '1 day'
	)::date AS date
),
family_with_dates AS (
	SELECT * FROM families
	CROSS JOIN dates
	ORDER BY id, date
)
SELECT f.date as unassigned_date, f.family_name
FROM family_with_dates f
LEFT JOIN deliveries_assigned da 
ON da.family_id = f.id AND da.gift_date = f.date
WHERE da.id IS NULL
ORDER BY 1, 2;