-- Write a query that returns the top 3 artists per user. Order the results by the most played. 
WITH ranked_logs AS (
	SELECT
		user_name,
		artist,
		count(*),
		rank() OVER (PARTITION BY user_name ORDER BY count(*) DESC)
	FROM listening_logs
	GROUP BY user_name, artist
)
SELECT
	user_name,
	string_agg(artist, ', '),
	count
FROM ranked_logs
WHERE rank <= 3
GROUP BY 1, 3
ORDER BY 1, 3 DESC;