EX1:
SELECT name    
FROM students
WHERE marks > 75
GROUP BY 
    name
    , id
ORDER BY 
    RIGHT(name, 3)
    , id

EX2:
SELECT 
    user_id        
    , CONCAT(UPPER(LEFT(name, 1)), LOWER(SUBSTRING(name, 2, LENGTH(name)))) name
FROM Users

EX3:
SELECT
  manufacturer
  , CONCAT('$', ROUND(SUM(total_sales)/1000000, 0), ' million') sale
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC

EX4:
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

EX5:
SELECT 
    tweet_id 
FROM Tweets
WHERE LENGTH(content) > 15 

EX6: 





















