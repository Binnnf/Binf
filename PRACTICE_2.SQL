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















