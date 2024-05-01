--EX1: datalemur-duplicate-job-listings.
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

--EX2: datalemur-highest-grossing.
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

--EX3: datalemur-frequent-callers.
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

--EX4: datalemur-page-with-no-likes.
SELECT a.page_id
FROM pages a
FULL JOIN page_likes b
ON a.page_id = b.page_id
WHERE b.page_id IS NULL
GROUP BY 
  a.page_id

--EX5: datalemur-user-retention.
SELECT 
  EXTRACT(MONTH FROM event_date)
  , COUNT(*)
FROM user_actions
WHERE 
  EXTRACT(MONTH FROM event_date) = 7
  AND EXTRACT(YEAR FROM event_date) = 2022
  AND event_type = 'sign-in'
GROUP BY EXTRACT(MONTH FROM event_date)

--EX6: leetcode-monthly-transactions.
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

--EX7: leetcode-product-sales-analysis.
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
  EXTRACT(MONTH FROM a.event_date) month1
  , COUNT(DISTINCT(a.user_id)) monthly_active_users
FROM active_users_july a
INNER JOIN active_users_june b
ON a.user_id = b.user_id
GROUP BY EXTRACT(MONTH FROM a.event_date) 

--EX8: leetcode-customers-who-bought-all-products.
WITH a AS (
    SELECT
        product_id 
        , year first_year
        , quantity 
        , price 
    FROM sales
    WHERE product_id = 100
    GROUP BY 
        product_id 
        , quantity 
        , price
        , year
    ORDER BY year ASC
    LIMIT 1
)
, b AS (
    SELECT
        product_id 
        , year first_year
        , quantity 
        , price 
    FROM sales
    WHERE product_id = 200
    GROUP BY 
        product_id 
        , quantity 
        , price
        , year
    ORDER BY year ASC
    LIMIT 1
)
SELECT *
FROM a
UNION ALL
SELECT *
FROM b

--EX9: leetcode-employees-whose-manager-left-the-company.
SELECT a.employee_id
FROM Employees a
WHERE 
NOT EXISTS (
        SELECT b.employee_id 
        FROM Employees b
        WHERE a.manager_id = b.employee_id
)
AND a.manager_id IS NOT NULL 
AND a.salary < 30000

--EX10: leetcode-primary-department-for-each-employee.

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

--EX11: https://leetcode.com/problems/movie-rating/?envType=study-plan-v2&envId=top-sql-50

WITH count_user_rating AS (
    SELECT
        user_id
        , COUNT(user_id) count_rating
    FROM MovieRating
    GROUP BY user_id
    ORDER BY count_rating DESC
    LIMIT 2
)
, highest_avg_rating AS (
    SELECT
        movie_id
        , AVG(rating) avg_rating
    FROM MovieRating
    WHERE 
        EXTRACT(YEAR FROM created_at) = 2020
        AND EXTRACT(MONTH FROM created_at) = 2
    GROUP BY movie_id
    ORDER BY avg_rating DESC
    LIMIT 2
)
(SELECT b.name results
FROM count_user_rating a 
JOIN Users b
ON a.user_id = b.user_id
ORDER BY a.user_id
LIMIT 1)
UNION ALL
(SELECT b.title
FROM highest_avg_rating a 
JOIN Movies b
ON a.movie_id = b.movie_id
ORDER BY a.movie_id ASC
LIMIT 1)

--EX12: https://leetcode.com/problems/friend-requests-ii-who-has-the-most-friends/?envType=study-plan-v2&envId=top-sql-50

WITH a AS (
SELECT 
    requester_id user_id
    , COUNT(requester_id) count_friends
FROM RequestAccepted
GROUP BY requester_id
UNION 
SELECT 
    accepter_id user_id
    , COUNT(accepter_id) count_friends
FROM RequestAccepted
GROUP BY accepter_id
)
SELECT 
    user_id id
    , SUM(count_friends) num
FROM a
GROUP BY user_id
ORDER BY SUM(count_friends) DESC
LIMIT 1
  
  
  
  
  





























