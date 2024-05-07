--EX1: hackerrank-weather-observation-station-3.

SELECT DISTINCT city
FROM station
WHERE id % 2 = 0

--EX2: hackerrank-weather-observation-station-4.

SELECT 
    COUNT(city) - COUNT(DISTINCT(city))
FROM station

--EX3: hackerrank-the-blunder.

SELECT 
    ROUND(AVG(salary), 0) - ROUND(AVG(REPLACE(salary, '0', '' )), 0)
FROM EMPLOYEES 

--EX4: datalemur-alibaba-compressed-mean.

SELECT 
  ROUND(CAST(SUM(item_count * order_occurrences) / SUM(order_occurrences) AS decimal), 1)
FROM items_per_order

--EX5:datalemur-matching-skills.

SELECT candidate_id
FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(DISTINCT(skill)) = 3

--EX6: datalemur-verage-post-hiatus-1.

SELECT 
  user_id
  , DATE(MAX(post_date)) - DATE(MIN(post_date))
FROM posts
WHERE post_date >= '2021-01-01' AND post_date < '2022-01-01'
GROUP BY 
  user_id	
HAVING COUNT(user_id) >= 2

--EX7: datalemur-cards-issued-difference.

SELECT 
  card_name
  , MAX(issued_amount) - MIN(issued_amount) difference  
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC

--EX8: datalemur-non-profitable-drugs.

--Câu lệnh sai:
SELECT
  manufacturer
  , SUM(drug_count) total_drug --> Sai
  , SUM(losses) total_loss
FROM (
SELECT  
  manufacturer
  , COUNT(drug) drug_count
  , SUM(cogs - total_sales) losses
FROM pharmacy_sales 
GROUP BY manufacturer, total_sales, cogs
) AS A
WHERE losses > 0
GROUP BY manufacturer
ORDER BY total_loss DESC

Câu lệnh đúng:
SELECT  
  manufacturer
  , COUNT(drug) drug_count
  , SUM(cogs - total_sales) losses
FROM pharmacy_sales 
WHERE cogs - total_sales > 0
GROUP BY manufacturer
ORDER BY losses DESC 

--EX9: leetcode-not-boring-movies.

SELECT 
    *
FROM Cinema
WHERE 
    id % 2 <> 0
    AND description <> 'boring'
ORDER BY rating DESC

--EX10: leetcode-number-of-unique-subject.

SELECT
    teacher_id 
    , COUNT(DISTINCT(subject_id)) cnt 
FROM Teacher
GROUP BY teacher_id

--EX11: leetcode-find-followers-count.

SELECT
    user_id
    ,  COUNT(follower_id) followers_count
FROM Followers
GROUP BY user_id     
ORDER BY user_id ASC

--EX12: leetcode-classes-more-than-5-students.

SELECT 
    class
FROM Courses
GROUP BY class    
HAVING COUNT(student) >= 5
















