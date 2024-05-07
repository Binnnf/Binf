--EX1: hackerank-revising-the-select-query. 

SELECT name
FROM city
WHERE 
    countrycode = 'USA'
    AND population > 120000

--EX2: hackerank-japanese-cities-attributes. 

SELECT *
FROM city
WHERE countrycode = 'JPN'

--EX3: hackerank-weather-observation-station-1. 

SELECT 
    city
    , state
FROM station

--EX4:hackerank-weather-observation-station-6. 

SELECT DISTINCT city
FROM station
WHERE 
    city LIKE 'i.e.%'
    OR city LIKE 'a%'
    OR city LIKE 'e%'
    OR city LIKE 'i%'
    OR city LIKE 'o%'
    OR city LIKE 'u%'

--EX5: hackerank-weather-observation-station-7. 

SELECT DISTINCT city
FROM station
WHERE 
    city LIKE '%a'
    OR city LIKE '%e'
    OR city LIKE '%i'
    OR city LIKE '%o'
    OR city LIKE '%u'

--EX6: hackerank-weather-observation-station-9. 

SELECT DISTINCT city
FROM station
WHERE 
    city NOT LIKE 'a%'
    AND city NOT LIKE 'e%'
    AND city NOT LIKE 'i%'
    AND city NOT LIKE 'o%'
    AND city NOT LIKE 'u%'

--EX7: hackerank-name-of-employees. 

SELECT name
FROM employee
ORDER BY name ASC

--EX8: hackerank-salary-of-employees. 

SELECT name
FROM employee
WHERE 
    salary > 2000
    AND months < 10
ORDER BY employee_id ASC

--EX9: leetcode-recyclable-and-low-fat-products. 
SELECT product_id
FROM products
WHERE
    low_fats = 'Y'
    AND recyclable = 'Y'

--EX10: leetcode-find-customer-referee. 

SELECT name
FROM customer
WHERE 
    NOT referee_id = 2
    OR referee_id IS NULL

--EX11: leetcode-big-countries. 

SELECT 
    name
    , population
    , area
FROM world
WHERE 
    area >= 3000000
    OR population > 25000000

--EX12: leetcode-article-views. 
SELECT DISTINCT author_id id
FROM views
WHERE author_id = viewer_id
ORDER BY id

--EX13: datalemur-tesla-unfinished-part. 

SELECT 
  part
  , assembly_step
FROM parts_assembly
WHERE finish_date IS NULL

--EX14: datalemur-lyft-driver-wages. 
SELECT *
FROM lyft_drivers
WHERE 
    yearly_salary <=30000 
    OR yearly_salary >=70000

--EX15: datalemur-find-the-advertising-channel.
SELECT advertising_channel
FROM uber_advertising
WHERE 
    year = 2019
    AND money_spent > 100000

























