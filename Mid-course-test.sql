-- Q1:
-- Task: Tạo danh sách tất cả chi phí thay thế (replacement costs )  khác nhau của các film.
-- Question: Chi phí thay thế thấp nhất là bao nhiêu?
SELECT DISTINCT
	film_id
 	, title
	, replacement_cost
FROM public.film
ORDER BY replacement_cost ASC
-- Chi phí thay thế thấp nhất là 9.99

-- Q2:
-- Task: Viết một truy vấn cung cấp cái nhìn tổng quan về số lượng phim có chi phí thay thế trong các phạm vi chi phí sau
-- 1.	low: 9.99 - 19.99
-- 2.	medium: 20.00 - 24.99
-- 3.	high: 25.00 - 29.99
-- Question: Có bao nhiêu phim có chi phí thay thế thuộc nhóm “low”?
WITH flim_cost_category AS (
SELECT
	film_id
 	, title
	, CASE 
		WHEN replacement_cost >= 25 AND replacement_cost < 29.9 THEN 'high'
		WHEN replacement_cost >= 20 THEN 'medium'
		WHEN replacement_cost >= 9.99 THEN 'low'
		ELSE 'undefined'
	END cost_category
FROM public.film
GROUP BY
	film_id
	, title
)
SELECT COUNT(cost_category) count_cost
FROM flim_cost_category
WHERE cost_category = 'low'

--Q3:
-- Task: Tạo danh sách các film_title bao gồm tiêu đề (title), 
-- độ dài (length) và tên danh mục (category_name) được sắp xếp theo độ dài giảm dần. 
-- Lọc kết quả để chỉ các phim trong danh mục 'Drama' hoặc 'Sports'.
-- Question: Phim dài nhất thuộc thể loại nào và dài bao nhiêu?
SELECT 
	a.title
	, length
	, c.name category
FROM film a
INNER JOIN film_category b
ON a.film_id = b.film_id
INNER JOIN category c
ON b.category_id = c.category_id
WHERE c.name IN ('Drama', 'Sports')
ORDER BY length DESC
--Phim dài nhất: SMOOCHY CONTROL, thể loại: "Sports", độ dài: 184

--Q4:
-- Task: Đưa ra cái nhìn tổng quan về số lượng phim (tilte) trong mỗi danh mục (category).
-- Question:Thể loại danh mục nào là phổ biến nhất trong số các bộ phim?
SELECT 
	c.name category
	, COUNT(a.film_id) count_film
FROM film a
INNER JOIN film_category b
ON a.film_id = b.film_id
INNER JOIN category c
ON b.category_id = c.category_id
GROUP BY category
ORDER BY count_film DESC
-- Thể loại danh mục phổ biến nhất trong số các bộ phim: "Sports"

--Q5:
-- Task:Đưa ra cái nhìn tổng quan về họ và tên của các diễn viên cũng như số lượng phim họ tham gia.
-- Question: Diễn viên nào đóng nhiều phim nhất?
SELECT 
	c.first_name
	, c.last_name
	, COUNT(a.film_id) count_film
FROM film a
INNER JOIN film_actor b
ON a.film_id = b.film_id
INNER JOIN actor c
ON b.actor_id = c.actor_id
GROUP BY 
	c.first_name
	, c.last_name
ORDER BY count_film DESC
-- Diễn viên đóng nhiều phim nhất: SUSAN DAVIS

-- Q6:
-- Task: Tìm các địa chỉ không liên quan đến bất kỳ khách hàng nào.
-- Question: Có bao nhiêu địa chỉ như vậy?
SELECT 
	customer_id
	, address
FROM address a
LEFT JOIN customer b
ON a.address_id = b.address_id
WHERE customer_id IS NULL
--Có bao nhiêu địa chỉ như vậy? 4

--Q7:
-- Task: Danh sách các thành phố và doanh thu tương ứng trên từng thành phố 
-- Question:Thành phố nào đạt doanh thu cao nhất?

SELECT 
	a.city
	, SUM(d.amount) city_amout
FROM city a
INNER JOIN address b
ON a.city_id = b.city_id
INNER JOIN customer c
ON b.address_id = c.address_id
INNER JOIN payment d
ON c.customer_id = d.customer_id
GROUP BY a.city
ORDER BY city_amout DESC
-- Thành phố đạt doanh thu cao nhất: "Cape Coral"

--Q8:
-- Task: Tạo danh sách trả ra 2 cột dữ liệu: 
-- -	cột 1: thông tin thành phố và đất nước ( format: “city, country")
-- -	cột 2: doanh thu tương ứng với cột 1
-- Question: thành phố của đất nước nào đat doanh thu cao nhất

SELECT
	a.city ||' '|| b.country location
	, SUM(e.amount) revenue
FROM city a
INNER JOIN country b
ON a.country_id = b.country_id
INNER JOIN address c
ON a.city_id = c.city_id
INNER JOIN customer d
ON c.address_id = d.address_id
INNER JOIN payment e
ON d.customer_id = e.customer_id
GROUP BY location
ORDER BY revenue







































