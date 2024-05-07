--EX1: datalemur-laptop-mobile-viewership.

SELECT 
  SUM(CASE 
      WHEN device_type = 'laptop' THEN 1
      ELSE 0
    END) laptop_views
  , SUM(CASE 
      WHEN device_type IN ('tablet', 'phone') THEN 1
      ELSE 0
    END) mobile_views 
FROM viewership

--EX2: datalemur-triangle-judgement.

SELECT 
    x
    , y
    , z
    , CASE 
        WHEN X + Y > Z AND X + Z > Y AND Z + Y > X THEN 'Yes'
        ELSE 'No'
    END triangle 
FROM Triangle

--EX3: datalemur-uncategorized-calls-percentage.

WITH call_category AS (
  SELECT 
    SUM(CASE 
      WHEN call_category IN ('', 'n/a') THEN 1
      ELSE 0
    END) count_uncategorised 
    , COUNT(call_category) call_categorised
  FROM callers
)

SELECT 
  ROUND((count_uncategorised / call_categorised), 1) * 100 call_percentage
FROM call_category

--EX4: https://leetcode.com/problems/find-customer-referee/description/?envType=study-plan-v2&envId=top-sql-50



--EX5: stratascratch the-number-of-survivors.

SELECT 
    pclass
    , SUM(CASE 
        WHEN survived = 1 THEN 1 
        ELSE 0
    END) AS survivors 
    , SUM(CASE 
        WHEN survived = 0 THEN 1
        ELSE 0
    END) AS nonsurvivors
FROM titanic
GROUP BY pclass




















