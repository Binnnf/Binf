EX1:
WITH a AS (
SELECT 
  company_id || title || description
  , COUNT(*) count_dupe
FROM job_listings
GROUP BY 
  company_id || title || description
HAVING COUNT(*) >1
)
SELECT COUNT(count_dupe)
FROM a

EX2:
SELECT 
  category
  , product
  , spend
FROM product_spend a
WHERE spend IN (
  SELECT spend 
  FROM product_spend
  WHERE category = a.category
  ORDER BY spend DESC
  LIMIT 2
)




































