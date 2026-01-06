-- Calculate the 7-day rolling average behavior score for each child.
-- Identify any child whose rolling average drops below 0.
-- For those children with a rolling average below 0, return the
-- child_id, child_name, behavior_date (this will be the latest date in the 7-day rolling average), and the calculated 7-day rolling average.
-- Only include results with a behavior_date of December 7, 2025 or later, ensuring that each rolling average is based on a full 7 days of data.
-- Order the results by behavior_date and then child_name.

WITH rolling_behavior AS (
	SELECT
		child_id,
		child_name,
		behavior_date,
		score,
		round(
			avg(score) OVER (
				PARTITION BY child_id
				ORDER BY behavior_date ASC
				ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
			)::NUMERIC,
			2
		) AS rolling_avg
	FROM behavior_logs
	ORDER BY child_id, behavior_date
)
SELECT
	child_id,
	child_name,
	behavior_date,
	rolling_avg
FROM rolling_behavior
WHERE behavior_date >= '2025-12-07'::date AND rolling_avg < 0 
ORDER BY behavior_date, child_name;