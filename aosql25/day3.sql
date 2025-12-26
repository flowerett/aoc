-- Using the hotline_messages table, update any record that has "sorry" (case insensitive) in the transcript
-- and doesn't currently have a status assigned to have a status of "approved"

-- Then delete any records where the tag is "penguin prank", "time-loop advisory", "possible dragon", or "nonsense alert"
-- or if the caller's name is "Test Caller".

-- After updating and deleting the records as described, write a final query that returns how many messages currently
-- have a status of "approved" and how many still need to be reviewed (i.e., status is NULL).

-- select *
-- from hotline_messages
-- where transcript ilike '%sorry%' and status is null;
-- 68

-- select *
-- from hotline_messages m
-- where m.transcript ilike '%sorry%';
-- 104

-- update hotline_messages
-- set status = 'approved'
-- where transcript ilike '%sorry%' and status is null;
-- Query 1 OK: UPDATE 68, 68 rows affected

-- select * from hotline_messages
-- WHERE tag in ('penguin prank', 'time-loop advisory', 'possible dragon', 'nonsense alert')
-- or caller_name = 'Test Caller';
-- 89, 0

-- delete from hotline_messages
-- WHERE tag in ('penguin prank', 'time-loop advisory', 'possible dragon', 'nonsense alert')
-- or caller_name = 'Test Caller';
-- Query 1 OK: DELETE 89, 89 rows affected

SELECT
    CASE
        WHEN status IS NULL THEN 'to_review'
        ELSE status
    END AS status,
    count(*)
FROM hotline_messages
GROUP BY 1;

SELECT
    count(*) filter(WHERE m.status = 'approved') AS approved,
    count(*) filter(WHERE m.status IS NULL) AS to_review
FROM hotline_messages m;
