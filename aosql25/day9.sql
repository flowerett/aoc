-- Build a report using the orders table that shows:
--   The latest order for each customer,
--   Along with their requested shipping method,
--   Gift wrap choice (as true or false)
--   and the risk flag in separate columns.
-- Order the report by the most recent order first so Evergreen Market can reach out to them ASAP.

WITH ranked_orders AS (
	SELECT
		customer_id,
		order_data -> 'shipping' ->> 'method' AS shipping_method,
		(order_data -> 'gift' ->> 'wrapped')::BOOLEAN AS wrap_choice,
		COALESCE(order_data -> 'risk' ->> 'flag', 'n/a') AS risk_flag,
		rank() OVER (PARTITION BY customer_id ORDER BY created_at DESC)
	FROM
		orders
)
SELECT
	*
FROM
	ranked_orders
WHERE
	rank = 1