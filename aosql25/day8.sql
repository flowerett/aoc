-- Generate a report, using the products and price_changes tables for leadership that 
-- returns the product_name, current_price, previous_price, and the difference between the current and previous prices.

-- CTE, Window Functions, lead(), rank()
with ranked_prices as (
  select product_id,
    price as current_price,
    lead(price) over w as prev_price,
    effective_timestamp,
    rank() over w
  from price_changes
  window w as (
    partition by product_id order by effective_timestamp desc
  )
)
select p.product_name, rp.current_price, rp.prev_price, rp.current_price - rp.prev_price as diff
from products p
join ranked_prices rp
on rp.product_id = p.product_id and rp.rank = 1
order by p.product_name