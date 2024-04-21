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




















