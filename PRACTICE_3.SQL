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





















