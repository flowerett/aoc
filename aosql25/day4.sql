-- Using the official_shifts and last_minute_signups tables, create a combined de-duplicated volunteer list.
-- Ensure the list has standardized role labels of 
-- Stage Setup, Cocoa Station, Parking Support, Choir Assistant, Snow Shoveling, Handwarmer Handout.
-- Make sure that the timeslot formats follow John's official shifts format.

SELECT
	volunteer_name,
	CASE 
        WHEN assigned_task ILIKE '%stage%' THEN 'Stage Setup'
        WHEN assigned_task ILIKE '%cocoa%' THEN 'Cocoa Station'
        WHEN assigned_task ILIKE '%parking%' THEN 'Parking Support'
        WHEN assigned_task ILIKE '%choir%' THEN 'Choir Assistant'
        WHEN assigned_task ILIKE '%shovel%' THEN 'Snow Shoveling'
        WHEN assigned_task ILIKE '%handwarmer%' THEN 'Handwarmer Handout'
        ELSE INITCAP(REPLACE(assigned_task, '_', ' '))
	END AS ROLE,
	CASE 
        WHEN time_slot ILIKE '%10%' THEN '10:00 AM'
        WHEN time_slot ILIKE '2%' THEN '2:00 PM'
        WHEN time_slot ILIKE '%noon%' THEN '12:00 PM'
	END AS shift_time
FROM
	last_minute_signups
UNION
SELECT
	volunteer_name,
	INITCAP(REPLACE(ROLE, '_', ' ')) AS ROLE,
	shift_time
FROM
	official_shifts
ORDER BY
	volunteer_name;