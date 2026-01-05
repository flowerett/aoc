-- Challenge: Get the stewards a list of all the passengers and the cocoa car(s) they can be served from that has at least one of their favorite mixins.
-- Remember only the top three most-stocked cocoa cars remained operational, so the passengers must be served from one of those cars.
-- select * from cocoa_cars

WITH most_stocked_cars AS (
	SELECT *
	FROM cocoa_cars
	ORDER BY total_stock DESC
	LIMIT 3
)
SELECT p.passenger_name, ARRAY_AGG(c.car_id) as cars
FROM passengers p
JOIN most_stocked_cars c ON c.available_mixins && p.favorite_mixins
GROUP BY 1
ORDER BY 1;