-- Using the snowball_inventory and snowball_categories tables, write a query that returns
-- valid snowball categories with the count of valid snowballs per category.
-- Your final table should have the columns official_category and total_usable_snowballs.
-- Sort the output from fewest to most total_usable_snowballs.

SELECT sc.official_category, sum(si.quantity) as total
FROM snowball_categories sc
JOIN snowball_inventory si
ON sc.official_category = si.category_name AND si.quantity > 0
GROUP BY 1
ORDER BY 2 ASC
