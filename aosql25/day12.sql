-- Using the archive_records table, search both the title and description fields for the term "fly". 
-- Make sure that you also match for words like "flying", "flight", etc. 
-- Boost the results where the term appears in the title and lastly, 
-- rank the results by relevance (most relevant first). 
-- Provide the elves the top 5 most relevant archived records back.

WITH vector_archive AS (
	SELECT
		*,
		setweight(to_tsvector('english', title), 'A') ||
		setweight(to_tsvector('english', description), 'B')
		AS vector
	FROM archive_records
)
SELECT
	id, title, description,
	ts_rank(vector, to_tsquery('english', 'fly:*')) AS rank
FROM vector_archive
-- will be faster with a gin index
WHERE vector @@ to_tsquery('english', 'fly:*')
ORDER BY rank DESC
LIMIT 5;