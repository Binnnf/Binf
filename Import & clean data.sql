create table SALES_DATASET_RFM_PRJ
(
  ordernumber VARCHAR,
  quantityordered VARCHAR,
  priceeach        VARCHAR,
  orderlinenumber  VARCHAR,
  sales            VARCHAR,
  orderdate        VARCHAR,
  status           VARCHAR,
  productline      VARCHAR,
  msrp             VARCHAR,
  productcode      VARCHAR,
  customername     VARCHAR,
  phone            VARCHAR,
  addressline1     VARCHAR,
  addressline2     VARCHAR,
  city             VARCHAR,
  state            VARCHAR,
  postalcode       VARCHAR,
  country          VARCHAR,
  territory        VARCHAR,
  contactfullname  VARCHAR,
  dealsize         VARCHAR
) 


--Xử lý dữ liệu thừa

DELETE 
FROM sales_dataset_rfm_prj
WHERE ordernumber = (
	SELECT ordernumber
	FROM sales_dataset_rfm_prj
	ORDER BY ordernumber DESC
	LIMIT 1
)


SELECT *
FROM sales_dataset_rfm_prj

--Chuyển đổi kiểu dữ liệu

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN ordernumber TYPE INTEGER
USING ordernumber::INTEGER

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN quantityordered TYPE INTEGER
USING quantityordered::INTEGER

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN priceeach TYPE NUMERIC(5,2)
USING priceeach::NUMERIC(5,2)

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN orderlinenumber TYPE INTEGER
USING orderlinenumber::INTEGER

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN sales TYPE NUMERIC(10,2)
USING sales::NUMERIC(10,2)

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN orderdate TYPE TIMESTAMP
USING orderdate::TIMESTAMP

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN status TYPE TEXT
USING status::TEXT

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN productline TYPE TEXT
USING productline::TEXT

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN msrp TYPE INTEGER
USING msrp::INTEGER

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN productcode TYPE VARCHAR(8)
USING productcode::VARCHAR(8)

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN customername TYPE TEXT
USING customername::TEXT

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN phone TYPE VARCHAR(20)
USING phone::VARCHAR(20)

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN city TYPE TEXT
USING city::TEXT

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN state TYPE TEXT
USING state::TEXT

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN country TYPE TEXT
USING country::TEXT

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN territory TYPE TEXT
USING territory::TEXT

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN dealsize TYPE TEXT
USING dealsize::TEXT

--Chuyển dữ liệu cột orderdate thành timestamp nhưng không được vì sai định dạng dữ liệu
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN orderdate TYPE TIMESTAMP
USING orderdate::TIMESTAMP

--Code sai
-- UPDATE sales_dataset_rfm_prj
-- SET orderdate1 = TO_DATE(orderdate, 'yyyy-mm-dd hh:mm:ss')

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN orderdate1 TYPE VARCHAR
USING orderdate1::VARCHAR

--Tạo thêm cột orderdate1 để truyền dữ liệu cột orderdate vào tính toán mà không ảnh hưởng dữ liệu gốc
ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN orderdate1 VARCHAR

--Truyền dữ liệu cột orderdate vào cột orderdate1
UPDATE sales_dataset_rfm_prj
SET orderdate1 = orderdate

--Tạo thêm cột orderdate3 để truyền dữ liệu vào
ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN orderdate3 TIMESTAMP

--Code sai
UPDATE sales_dataset_rfm_prj
SET orderdate1 = (
    SELECT 
        TO_CHAR(TO_DATE(parts[2] || '/' || parts[1] || '/' || parts[3] || ' ' || parts[4]
						, 'MM/DD/YYYY HH24:MI'), 'DD/M/YYYY HH24:MI')
    FROM (
        SELECT 
            regexp_split_to_array(orderdate1, '[ /:]') AS parts
    ) AS split_parts
);

--Code này để chạy thử nhưng không đúng
UPDATE sales_dataset_rfm_prj
SET orderdate3 = (
	SELECT 
		CAST(orderdate2 AS TIMESTAMP)
	FROM (
		SELECT CONCAT(yyyy,'-',mm,'-',dd,' ',hhmm) orderdate2
		FROM (
			SELECT 
				yyyy
				, mm
				, REPLACE(dd, '/', '') dd
				, hhmm
			FROM (
				SELECT
					orderdate1
					, LEFT(orderdate1, POSITION('/' IN orderdate1) - 1) mm
					, SUBSTRING(orderdate1, POSITION('/' IN orderdate1) + 1, 
								LENGTH(orderdate1) - POSITION(':' IN orderdate1)) dd
					, SUBSTRING(orderdate1, POSITION(':' IN orderdate1) - 6, 
								LENGTH(orderdate1) - POSITION(':' IN orderdate1) + 2) yyyy
					, RIGHT(orderdate1, 4) hhmm
				FROM sales_dataset_rfm_prj
			)
		)
	) 
)

--Code đúng
--Sắp xếp lại dữ liệu trong cột orderdate, chuyển kiểu dữ liệu thành timestamp và truyền vào một cột mới trong bảng
UPDATE sales_dataset_rfm_prj
SET orderdate3 = CAST(CONCAT(
							SUBSTRING(orderdate1, POSITION(':' IN orderdate1) - 6, 
								LENGTH(orderdate1) - POSITION(':' IN orderdate1) + 2)
							, '-'
							, LEFT(orderdate1, POSITION('/' IN orderdate1) - 1)
							, '-'
                            , REPLACE(SUBSTRING(orderdate1, POSITION('/' IN orderdate1) + 1, 
								LENGTH(orderdate1) - POSITION(':' IN orderdate1)), '/', '')
							, ' '
							, RIGHT(orderdate1, 4)
							)
					  AS TIMESTAMP
					 );

--Code này sai
-- UPDATE sales_dataset_rfm_prj
-- SET orderdate3 = CAST(CONCAT(
-- 							REPLACE(SUBSTRING(orderdate1, POSITION('/' IN orderdate1) + 1
--                             						, POSITION('/' IN orderdate1) + 5), '/', '')
-- 							, '-'
-- 							, SUBSTRING(orderdate1, POSITION('/' IN orderdate1) + 7, 4)
-- 							, '-'
--                             , LEFT(orderdate1, POSITION('/' IN orderdate1) - 1)
-- 							, ' '
-- 							, RIGHT(orderdate1, 5)
-- 							)
-- 					  AS TIMESTAMP
-- 					 );

--Xóa cột dữ liệu gốc orderdate và cột orderdate1
ALTER TABLE sales_dataset_rfm_prj
DROP COLUMN orderdate

ALTER TABLE sales_dataset_rfm_prj
DROP COLUMN orderdate1 

--Đổi tên cột orderdate3 thành orderdate
ALTER TABLE sales_dataset_rfm_prj 
RENAME COLUMN orderdate3 TO orderdate

--Check NULL
SELECT *
FROM sales_dataset_rfm_prj
WHERE ordernumber IS NULL

SELECT *
FROM sales_dataset_rfm_prj
WHERE quantityordered IS NULL

SELECT *
FROM sales_dataset_rfm_prj
WHERE priceeach IS NULL

SELECT *
FROM sales_dataset_rfm_prj
WHERE orderlinenumber IS NULL

SELECT *
FROM sales_dataset_rfm_prj
WHERE sales IS NULL

SELECT *
FROM sales_dataset_rfm_prj
WHERE orderdate IS NULL

--Check BLANK
SELECT *
FROM sales_dataset_rfm_prj
ORDER BY ordernumber

SELECT *
FROM sales_dataset_rfm_prj
ORDER BY quantityordered

SELECT *
FROM sales_dataset_rfm_prj
ORDER BY priceeach

SELECT *
FROM sales_dataset_rfm_prj
ORDER BY orderlinenumber

SELECT *
FROM sales_dataset_rfm_prj
ORDER BY sales

SELECT *
FROM sales_dataset_rfm_prj
ORDER BY orderdate

--Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME.

ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN contactfirstname TEXT

ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN contactlastname TEXT

--Code để trích xuất firstname và last name từ contactfullname
WITH split_contactfullname AS (
	SELECT
		contactfullname
		, LEFT(contactfullname, POSITION('-' IN contactfullname) - 1) contactlastname
		, SUBSTRING(contactfullname, POSITION('-' IN contactfullname) + 1, LENGTH(contactfullname)) contactfirstname
	FROM sales_dataset_rfm_prj
)
SELECT
	contactfullname
	, CONCAT(UPPER(LEFT(contactlastname, 1))
			, SUBSTRING(contactlastname, POSITION(RIGHT(LEFT(contactlastname, 2), 1) IN contactlastname)
							, LENGTH(contactlastname)))
	, CONCAT(UPPER(LEFT(SUBSTRING(contactfirstname, POSITION('-' IN contactfirstname) + 1, LENGTH(contactfirstname)), 1))
			, SUBSTRING(contactfirstname, POSITION(RIGHT(LEFT(contactfirstname, 2), 1) IN contactfirstname)
							, LENGTH(contactfirstname)))
FROM split_contactfullname
--Truyền last name vào cột contactlastname
UPDATE sales_dataset_rfm_prj
SET contactlastname = LEFT(contactfullname, POSITION('-' IN contactfullname) - 1)

--Truyền first name vào cột contactfirstname
UPDATE sales_dataset_rfm_prj
SET contactfirstname = SUBSTRING(contactfullname, POSITION('-' IN contactfullname) + 1, LENGTH(contactfullname))

--Chuẩn hóa CONTACTLASTNAME, CONTACTFIRSTNAME theo định dạng chữ cái đầu tiên viết hoa, chữ cái tiếp theo viết thường.
UPDATE sales_dataset_rfm_prj
SET contactlastname = CONCAT(UPPER(LEFT(contactlastname, 1))
							, SUBSTRING(contactlastname, POSITION(RIGHT(LEFT(contactlastname, 2), 1) IN contactlastname)
											, LENGTH(contactlastname)))

UPDATE sales_dataset_rfm_prj
SET contactfirstname = CONCAT(UPPER(LEFT(SUBSTRING(contactfirstname, POSITION('-' IN contactfirstname) + 1, LENGTH(contactfirstname)), 1))
							, SUBSTRING(contactfirstname, POSITION(RIGHT(LEFT(contactfirstname, 2), 1) IN contactfirstname)
											, LENGTH(contactfirstname)))

--Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE 

ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN qtr_id integer

ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN month_id integer

ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN year_id integer

UPDATE sales_dataset_rfm_prj
SET year_id = EXTRACT(YEAR FROM orderdate)

UPDATE sales_dataset_rfm_prj
SET month_id = EXTRACT(MONTH FROM orderdate)

UPDATE sales_dataset_rfm_prj
SET qtr_id = CASE 
				WHEN month_id IN (1,2,3) THEN 1
				WHEN month_id IN (4,5,6) THEN 2
				WHEN month_id IN (7,8,9) THEN 3
				WHEN month_id IN (10,11,12) THEN 4
				ELSE 0
			END

-- Tìm outlier (nếu có) cho cột QUANTITYORDERED và hãy chọn cách xử lý cho bản ghi đó (2 cách)

-- Sử dụng IQR/Boxplot
-- Tính Q1, Q3, IQR, Min, Max
WITH a AS (
	SELECT 
		PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY quantityordered) Q1
		, PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY quantityordered) Q3
		, PERCENTILE_CONT(0.57) WITHIN GROUP (ORDER BY quantityordered) - PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY quantityordered) IQR
	FROM sales_dataset_rfm_prj
)
	, min_max AS (
	SELECT 
		Q1 - 1.5 * IQR min_value
		, Q3 + 1.5 * IQR max_value
	FROM a
)
-- SELECT *
-- FROM min_max;

-- Tính outlier < min or > max
SELECT *
FROM sales_dataset_rfm_prj
WHERE 
	quantityordered < (SELECT min_value FROM min_max)
	OR quantityordered > (SELECT max_value FROM min_max)
ORDER BY quantityordered 

-- Sử dụng Z-Score = (quantityordered - AVG) / stddev
-- stddev: standard deviation

WITH avg_stddev AS (
	SELECT
		orderdate
		, quantityordered
		, (SELECT
			AVG(quantityordered) 
			FROM sales_dataset_rfm_prj) AS avg_quantityordered
		, (SELECT
			STDDEV(quantityordered) 
			FROM sales_dataset_rfm_prj) AS stddev_quantityordered
	FROM sales_dataset_rfm_prj
)
, outlier_quantityordered AS (
	SELECT
		orderdate
		, quantityordered
		, (quantityordered - avg_quantityordered) / stddev_quantityordered AS z_score
	FROM avg_stddev
	WHERE ABS((quantityordered - avg_quantityordered) / stddev_quantityordered) > 3
)

UPDATE sales_dataset_rfm_prj
SET quantityordered = (SELECT AVG(quantityordered)
						FROM sales_dataset_rfm_prj)
WHERE quantityordered IN (SELECT quantityordered
						 FROM outlier_quantityordered)

CREATE TABLE sales_dataset_rfm_prj_clean AS
SELECT *
FROM sales_dataset_rfm_prj













