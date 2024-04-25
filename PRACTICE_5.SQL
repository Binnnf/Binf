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
    OR signup_action IS NULL
  GROUP BY user_id
)
SELECT 
  ROUND((SUM(a.count_activation)/COUNT(emails.user_id)), 2)
FROM emails 
LEFT JOIN a
ON emails.user_id = a.user_id
--> NOT RIGHT YET























