--EX1: hackerrank-more-than-75-marks.

SELECT name    
FROM students
WHERE marks > 75
GROUP BY 
    name
    , id
ORDER BY 
    RIGHT(name, 3)
    , id

--EX2: leetcode-fix-names-in-a-table.

SELECT 
    user_id        
    , CONCAT(UPPER(LEFT(name, 1)), LOWER(SUBSTRING(name, 2, LENGTH(name)))) name
FROM Users

--EX3: datalemur-total-drugs-sales.

SELECT
  manufacturer
  , CONCAT('$', ROUND(SUM(total_sales)/1000000, 0), ' million') sale
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC

--EX4: avg-review-ratings.

SELECT 
  EXTRACT(MONTH FROM submit_date) mth
  , product_id	product
  , ROUND((AVG(stars)), 2) avg_stars
FROM reviews
GROUP BY 
  EXTRACT(MONTH FROM submit_date)
  , product_id
ORDER BY 
  EXTRACT(MONTH FROM submit_date)
  , product_id

--EX5: teams-power-users.

SELECT
  sender_id 
  , COUNT(content) message_count
FROM messages
WHERE 
  EXTRACT(MONTH FROM sent_date) = 08
  AND EXTRACT(YEAR FROM sent_date) = 2022
GROUP BY 
  sender_id
ORDER BY COUNT(content) DESC
LIMIT 2

--EX6: invalid-tweets.

SELECT 
    tweet_id 
FROM Tweets
WHERE LENGTH(content) > 15 

--EX7: user-activity-for-the-past-30-days.

SELECT 
    activity_date day
    , COUNT(activity_type) active_users 
FROM Activity
WHERE 
    activity_date >= '2019-06-27'
    AND activity_date < '2019-07-28'
    AND activity_type <> 'end_session'
    AND activity_type <> 'open_session'
GROUP BY activity_date

--EX8: number-of-hires-during-specific-time-period.

SELECT 
    COUNT(id)
FROM employees
WHERE 
    EXTRACT(MONTH FROM joining_date) >= 01 
    AND EXTRACT(MONTH FROM joining_date) <= 07 
    AND EXTRACT(YEAR FROM joining_date) = 2022

--EX9:positions-of-letter-a.

SELECT POSITION('a' IN first_name) position
FROM worker
WHERE first_name = 'Amitah'

--EX10: macedonian-vintages.

SELECT 
    CONCAT(title, SUBSTRING(title, POSITION(' ' IN title)+1, 4))
FROM winemag_p2
WHERE country = 'Macedonia'






















