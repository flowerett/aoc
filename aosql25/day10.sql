-- Clean-up the deliveries table to remove any records where the delivery_location is 'Volcano Rim', 'Drifting Igloo', 'Abandoned Lighthouse', 'The Vibes'.
-- Move those records to the misdelivered_presents with all the same columns as deliveries plus a flagged_at column with the current time and a reason column with "Invalid delivery location" listed as the reason for each moved record.
-- Make sure your final step shows the misdelivered_presents records that you just moved (i.e. don't include any existing records from the misdelivered_presents table).

-- delete & insert

-- WITH missed_deliveries AS (
-- 	DELETE FROM deliveries
-- 	WHERE delivery_location in('Volcano Rim', 'Drifting Igloo', 'Abandoned Lighthouse', 'The Vibes')
-- 	RETURNING id, child_name, delivery_location, gift_name, scheduled_at
-- )
-- INSERT INTO misdelivered_presents (id, child_name, delivery_location, gift_name, scheduled_at, flagged_at, reason)
-- SELECT *, now()::TIMESTAMP, 'invalid_delivery'
-- FROM missed_deliveries
-- RETURNING *;

-- check
select * from deliveries where delivery_location in ('Volcano Rim', 'Drifting Igloo', 'Abandoned Lighthouse', 'The Vibes');
select * from misdelivered_presents where delivery_location in ('Volcano Rim', 'Drifting Igloo', 'Abandoned Lighthouse', 'The Vibes');
