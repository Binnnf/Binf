--ex1: https://datalemur.com/questions/yoy-growth-rate

WITH a AS (
  SELECT 
    EXTRACT(YEAR FROM transaction_date) yr
    , product_id
    , SUM(spend) curr_year_spend 
  FROM user_transactions
  GROUP BY 
    product_id
    , EXTRACT(YEAR FROM transaction_date)
)
SELECT 
  *
  , LAG(curr_year_spend) OVER(PARTITION BY product_id ORDER BY yr) prev_year_spend
  , ROUND((curr_year_spend - LAG(curr_year_spend) OVER(PARTITION BY product_id ORDER BY yr))
      /LAG(curr_year_spend) OVER(PARTITION BY product_id ORDER BY yr)*100, 2) yoy_rate
FROM a

--ex2: https://datalemur.com/questions/card-launch-success

WITH a AS (
  SELECT 
    card_name
    , SUM(issued_amount) issued_amount
    , issue_month
    , issue_year
    , ROW_NUMBER() OVER(PARTITION BY issue_year ORDER BY issue_year, issue_month) rn
  FROM monthly_cards_issued
  GROUP BY 
    card_name
    , issue_month
    , issue_year
  ORDER BY 
    issue_year
    , issue_month
)
SELECT 
  card_name
  , issued_amount
FROM a
WHERE rn = 1

--ex3: datalemur-third-transaction.

WITH a AS (
  SELECT 
    user_id
    , spend
    , transaction_date
    , ROW_NUMBER() OVER(PARTITION BY user_id) rn
  FROM transactions
)
SELECT 
  user_id
  , spend
  , transaction_date
FROM a 
WHERE rn = 3 

--ex4: https://datalemur.com/questions/histogram-users-purchases

WITH a AS (  
  SELECT 
    transaction_date
    , user_id
    , COUNT(product_id) OVER(PARTITION BY user_id ORDER BY transaction_date DESC) purchase_count
    , ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date DESC) ranking
  FROM user_transactions
)
SELECT 
  transaction_date
  , user_id
  , purchase_count
FROM a
WHERE ranking = 1 
ORDER BY transaction_date

--ex5: https://datalemur.com/questions/rolling-average-tweets

WITH a AS (  
  SELECT 
    *
    , LAG(tweet_count) OVER(PARTITION BY user_id) lag1
    , LAG(tweet_count, 2) OVER(PARTITION BY user_id) lag2
  FROM tweets
)
SELECT 
  user_id
  , tweet_date
  , CASE 
      WHEN lag1 IS NULL THEN ROUND(tweet_count/1.0, 2)
      WHEN lag2 IS NULL THEN ROUND((tweet_count + lag1)/2.0, 2)
      ELSE ROUND((tweet_count + lag1 + lag2)/3.0, 2)
  END rolling_avg_3d
FROM a 

--ex6: https://datalemur.com/questions/repeated-payments

WITH a AS (  
  SELECT 
    merchant_id
    , LAG(merchant_id) OVER() lag_merchant_id
    , credit_card_id
    , LAG(credit_card_id) OVER() lag_credit_card_id
    , amount
    , LAG(amount) OVER() lag_amount
    , (EXTRACT(MINUTE FROM transaction_timestamp) 
    + EXTRACT(HOUR FROM transaction_timestamp) * 60) time_diff
    , LAG(EXTRACT(MINUTE FROM transaction_timestamp) 
    + EXTRACT(HOUR FROM transaction_timestamp) * 60) OVER() lag_time_diff
  FROM transactions
)
SELECT COUNT(*)
FROM a  
WHERE 
  merchant_id = lag_merchant_id 
  AND credit_card_id = lag_credit_card_id
  AND amount = lag_amount
  AND time_diff - lag_time_diff <= 10

--ex7: https://datalemur.com/questions/sql-highest-grossing

WITH a AS (
  SELECT 
    category
    , product
    , SUM(spend) OVER(PARTITION BY category, product) total_spend
  FROM product_spend 
  WHERE EXTRACT(YEAR FROM transaction_date) = 2022
)
, b AS (
  SELECT 
    *
    , DENSE_RANK() OVER(PARTITION BY category ORDER BY total_spend DESC) ranking
  FROM a 
  GROUP BY category, product, total_spend
)
SELECT 
  category
  , product	
  ,total_spend
FROM b
WHERE ranking <= 2

--ex8: https://datalemur.com/questions/top-fans-rank

WITH a AS (  
  SELECT 
    artist_name
    , COUNT(b.song_id) count1
  FROM artists a
  JOIN songs b 
  ON a.artist_id = b.artist_id 
  JOIN global_song_rank c
  ON b.song_id = c.song_id
  WHERE c.rank <= 10
  GROUP BY artist_name
)
, b AS (  
  SELECT 
    artist_name
    , DENSE_RANK() OVER(ORDER BY count1 DESC) artist_rank
  FROM a  
)
SELECT *
FROM b
  WHERE artist_rank <= 5 

















