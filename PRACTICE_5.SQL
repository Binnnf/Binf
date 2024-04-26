EX1:
SELECT 
    country.continent
    , ROUND(AVG(city.population), 0) avg_population
FROM country
LEFT JOIN city
ON city.countrycode = country.code
GROUP BY country.continent

EX2:
WITH a AS (
  SELECT
    user_id
    , COUNT(user_id) count_activation
  FROM emails
  LEFT JOIN texts 
  ON emails.email_id = texts.email_id
  WHERE 
    signup_action <> 'Not Confirmed'
  GROUP BY user_id
)
SELECT 
  ROUND((SUM(a.count_activation)/COUNT(emails.user_id)), 2)
FROM emails 
LEFT JOIN a
ON emails.user_id = a.user_id

EX3:
WITH time_spent_open AS (
  SELECT 
    age_bucket
    , SUM(time_spent) total_time_open
  FROM activities a
  INNER JOIN age_breakdown b
  ON a.user_id = b.user_id
  WHERE 
    activity_type = 'open'
  GROUP BY age_bucket
)
, time_spent_send AS (
  SELECT 
    age_bucket
    , SUM(time_spent) total_time_send
  FROM activities a
  INNER JOIN age_breakdown b
  ON a.user_id = b.user_id
  WHERE 
    activity_type = 'send'
  GROUP BY age_bucket
)
SELECT 
  c.age_bucket
  , ROUND(total_time_send / (total_time_open + total_time_send)*100,2) send_perc
  , ROUND(total_time_open / (total_time_open + total_time_send)*100,2) open_perc
FROM time_spent_open c
LEFT JOIN time_spent_send d
ON c.age_bucket = d.age_bucket

EX4:
SELECT 
  customer_id
FROM customer_contracts a
INNER JOIN products b
ON a.product_id = b.product_id
GROUP BY customer_id
HAVING COUNT(DISTINCT(product_category)) = 3

EX5:
SELECT
    employee_id 
    , name    
    , reports_to  reports_count  
    , ROUND(AVG(age), 0) average_age 
FROM Employees 
WHERE reports_to >= 1

EX6:
SELECT
    a.employee_id 
    , a.name    
    , COUNT(b.reports_to)  reports_count  
    , ROUND(AVG(b.age), 0) average_age 
FROM Employees a
INNER JOIN Employees b
ON a.employee_id  = b.reports_to
WHERE a.employee_id = b.reports_to
GROUP BY a.name  

EX7:
SELECT a.page_id
FROM pages a
FULL JOIN page_likes b
ON a.page_id = b.page_id
GROUP BY 
  a.page_id
  , b.page_id
HAVING b.page_id IS NULL





















