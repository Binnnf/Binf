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

--ex4: datalemur-histogram-users-purchases.



--ex5: datalemur-rolling-average-tweets.
--ex6: datalemur-repeated-payments.
--ex7: datalemur-highest-grossing.
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

















