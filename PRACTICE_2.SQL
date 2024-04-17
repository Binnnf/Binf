EX1:
SELECT DISTINCT city
FROM station
WHERE id % 2 = 0

EX2:
SELECT 
    COUNT(city) - COUNT(DISTINCT(city))
FROM station

EX3:

EX4:
SELECT 
  ROUND(CAST(SUM(item_count * order_occurrences) / SUM(order_occurrences) AS decimal), 1)
FROM items_per_order

EX 5:
SELECT candidate_id
FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(DISTINCT(skill)) = 3

EX6:
SELECT 
  user_id
  , DATE(MAX(post_date)) - DATE(MIN(post_date))
FROM posts
WHERE post_date >= '2021-01-01' AND post_date < '2022-01-01'
GROUP BY 
  user_id	
HAVING COUNT(user_id) >= 2

EX7:
SELECT 
  card_name
  , MAX(issued_amount) - MIN(issued_amount) difference  
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC

EX8:
SELECT 
  manufacturer
  , COUNT(drug)
  , total_sales - cogs 
FROM pharmacy_sales
GROUP BY manufacturer, total_sales, cogs














