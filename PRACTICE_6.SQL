EX1:
WITH a AS (
SELECT 
  title || description
  , COUNT(*) count_dupe
FROM job_listings
GROUP BY title || description
HAVING COUNT(*) >1
)
SELECT COUNT(count_dupe)
FROM a
