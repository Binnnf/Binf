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
WITH a AS (
SELECT
  category
  , product
  , SUM(spend) spend_appliance
FROM product_spend
WHERE 
  category = 'appliance'
  AND EXTRACT(YEAR FROM transaction_date) = 2022
GROUP BY 
  category
  , product
ORDER BY 
  spend_appliance DESC
LIMIT 2
) 
, b AS (
SELECT
  category
  , product
  , SUM(spend) spend_electronics
FROM product_spend
WHERE 
  category = 'electronics'
  AND EXTRACT(YEAR FROM transaction_date) = 2022
GROUP BY 
  category
  , product
ORDER BY 
  spend_electronics DESC
LIMIT 2
) 
SELECT *
FROM a
UNION ALL 
SELECT *
FROM b

EX3:
WITH a AS (
SELECT 
  policy_holder_id
  , COUNT(case_id) count_case_id
FROM callers
GROUP BY policy_holder_id
HAVING COUNT(case_id) >= 3
)
SELECT COUNT(*) 
FROM a

EX4:
SELECT a.page_id
FROM pages a
FULL JOIN page_likes b
ON a.page_id = b.page_id
WHERE b.page_id IS NULL
GROUP BY 
  a.page_id

EX5:
SELECT 
  EXTRACT(MONTH FROM event_date)
  , COUNT(*)
FROM user_actions
WHERE 
  EXTRACT(MONTH FROM event_date) = 7
  AND EXTRACT(YEAR FROM event_date) = 2022
  AND event_type = 'sign-in'
GROUP BY EXTRACT(MONTH FROM event_date)

EX6:
WITH active_users_july AS (
SELECT 
  user_id
  , event_date
FROM user_actions
WHERE 
  EXTRACT(MONTH FROM event_date) = 7
  AND EXTRACT(YEAR FROM event_date) = 2022
GROUP BY 
  user_id
  , event_date
)
, active_users_june AS (
SELECT 
  user_id
  , event_date
FROM user_actions
WHERE 
  EXTRACT(MONTH FROM event_date) = 6
  AND EXTRACT(YEAR FROM event_date) = 2022
GROUP BY 
  user_id
  , event_date
)
SELECT 
  a.user_id
  , (EXTRACT(MONTH FROM a.event_date) = 7) AS month
FROM active_users_july a
INNER JOIN active_users_june b
ON a.user_id = b.user_id
GROUP BY 
  a.user_id
  , a.event_date

EX7:
WITH active_users_july AS (
SELECT 
  user_id
  , event_date
FROM user_actions
WHERE 
  EXTRACT(MONTH FROM event_date) = 7
  AND EXTRACT(YEAR FROM event_date) = 2022
GROUP BY 
  user_id
  , event_date
)
, active_users_june AS (
SELECT 
  user_id
  , event_date
FROM user_actions
WHERE 
  EXTRACT(MONTH FROM event_date) = 6
  AND EXTRACT(YEAR FROM event_date) = 2022
GROUP BY 
  user_id
  , event_date
)
SELECT 
  7 AS month
  , COUNT(DISTINCT(a.user_id)) monthly_active_users
FROM active_users_july a
INNER JOIN active_users_june b
ON a.user_id = b.user_id
































