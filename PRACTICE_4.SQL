EX1:
SELECT 
  SUM(CASE 
      WHEN device_type = 'laptop' THEN 1
      ELSE 0
    END) laptop_views
  , SUM(CASE 
      WHEN device_type IN ('tablet', 'phone') THEN 1
      ELSE 0
    END) mobile_views 
FROM viewership

EX2:
SELECT 
    x
    , y
    , z
    , CASE 
        WHEN X + Y > Z AND X + Z > Y AND Z + Y > X THEN 'Yes'
        ELSE 'No'
    END triangle 
FROM Triangle

EX5:
SELECT 
    pclass
    , SUM(CASE 
        WHEN survived = 1 THEN 1 
        ELSE 0
    END) AS survivors 
    , SUM(CASE 
        WHEN survived = 0 THEN 1
        ELSE 0
    END) AS nonsurvivors
FROM titanic
GROUP BY pclass




















