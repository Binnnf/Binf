SELECT 
  FORMAT_TIMESTAMP('%Y-%m', a.delivered_at) AS month_year
  , COUNT(DISTINCT b.user_id) total_user
  , COUNT(DISTINCT b.order_id) total_order
FROM bigquery-public-data.thelook_ecommerce.orders a
JOIN bigquery-public-data.thelook_ecommerce.order_items b
ON a.order_id = b.order_id
WHERE 
  b.status = 'Complete' 
  AND FORMAT_TIMESTAMP('%Y-%m', delivered_at) >= '2019-01'
  AND FORMAT_TIMESTAMP('%Y-%m', delivered_at) <= '2022-04'
GROUP BY 1
ORDER BY 1
