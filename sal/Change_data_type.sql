-- Drop existing cleaned table
DROP TABLE IF EXISTS cleaned_order_details;

-- Copy from raw table
CREATE TABLE cleaned_order_details AS
SELECT * FROM raw_order_details;

-- Convert Order_Date to DATE
ALTER TABLE cleaned_order_details ADD COLUMN formatted_order_date DATE;
UPDATE cleaned_order_details
SET formatted_order_date = STR_TO_DATE(Order_Date, '%d-%m-%Y')
WHERE Order_Date IS NOT NULL AND TRIM(Order_Date) != '';
ALTER TABLE cleaned_order_details DROP COLUMN Order_Date;
ALTER TABLE cleaned_order_details CHANGE formatted_order_date Order_Date DATE;

-- Replace invalid/NULL time values with '00:00:00'
UPDATE cleaned_order_details
SET Time_Orderd = '00:00:00'
WHERE Time_Orderd IS NULL OR TRIM(LOWER(Time_Orderd)) IN ('', 'nan', 'null');

UPDATE cleaned_order_details
SET Time_Order_picked = '00:00:00'
WHERE Time_Order_picked IS NULL OR TRIM(LOWER(Time_Order_picked)) IN ('', 'nan', 'null');

-- Add new DATETIME columns
ALTER TABLE cleaned_order_details
  ADD COLUMN formatted_ordered DATETIME,
  ADD COLUMN formatted_picked DATETIME;

-- Convert to proper DATETIME
UPDATE cleaned_order_details
SET formatted_ordered = STR_TO_DATE(CONCAT(Order_Date, ' ', Time_Orderd), '%Y-%m-%d %H:%i:%s'),
    formatted_picked  = STR_TO_DATE(CONCAT(Order_Date, ' ', Time_Order_picked), '%Y-%m-%d %H:%i:%s');

-- Drop original and rename
ALTER TABLE cleaned_order_details
  DROP COLUMN Time_Orderd,
  DROP COLUMN Time_Order_picked,
  CHANGE formatted_ordered Time_Orderd DATETIME,
  CHANGE formatted_picked Time_Order_picked DATETIME;

-- Clean and convert 'multiple_deliveries'
UPDATE cleaned_order_details
SET multiple_deliveries = NULL
WHERE TRIM(LOWER(multiple_deliveries)) IN ('nan', 'null', '');

-- Replace NULLs with 1 (or choose another default if needed)
UPDATE cleaned_order_details
SET multiple_deliveries = 1
WHERE multiple_deliveries IS NULL;

ALTER TABLE cleaned_order_details
  MODIFY COLUMN multiple_deliveries INT;

-- Clean and convert 'Time_taken(min)'
UPDATE cleaned_order_details
SET `Time_taken(min)` = REPLACE(`Time_taken(min)`, '(min)', '');

-- Replace NULLs with average
UPDATE cleaned_order_details
JOIN (
    SELECT ROUND(AVG(`Time_taken(min)`), 1) AS avg_time_taken
    FROM cleaned_order_details
    WHERE `Time_taken(min)` IS NOT NULL
) AS avg_table
ON 1 = 1
SET `Time_taken(min)` = avg_table.avg_time_taken
WHERE `Time_taken(min)` IS NULL;


DROP TABLE IF EXISTS cleaned_location_details;

CREATE TABLE cleaned_location_details AS
SELECT * FROM raw_location_details;

ALTER TABLE cleaned_location_details
  MODIFY COLUMN Restaurant_latitude FLOAT,
  MODIFY COLUMN Restaurant_longitude FLOAT,
  MODIFY COLUMN Delivery_location_latitude FLOAT,
  MODIFY COLUMN Delivery_location_longitude FLOAT;

-- Replace NULL coordinates with 0.0 (or handle as needed)
UPDATE cleaned_location_details
SET Restaurant_latitude = 0.0
WHERE Restaurant_latitude IS NULL;
UPDATE cleaned_location_details
SET Restaurant_longitude = 0.0
WHERE Restaurant_longitude IS NULL;

UPDATE cleaned_location_details
SET Delivery_location_latitude = 0.0
WHERE Delivery_location_latitude IS NULL;

UPDATE cleaned_location_details
SET Delivery_location_longitude = 0.0
WHERE Delivery_location_longitude IS NULL;


DROP TABLE IF EXISTS cleaned_delivery_person;

CREATE TABLE cleaned_delivery_person AS
SELECT * FROM raw_delivery_person;

-- Replace invalid values with NULL
UPDATE cleaned_delivery_person
SET Delivery_person_Age = NULL
WHERE TRIM(LOWER(Delivery_person_Age)) IN ('nan', 'null', '');

UPDATE cleaned_delivery_person
SET Delivery_person_Ratings = NULL
WHERE TRIM(LOWER(Delivery_person_Ratings)) IN ('nan', 'null', '');

-- Replace NULLs with average values
UPDATE cleaned_delivery_person
JOIN (
    SELECT ROUND(AVG(Delivery_person_Age), 0) AS avg_age
    FROM cleaned_delivery_person
    WHERE Delivery_person_Age IS NOT NULL
) AS avg_table
ON 1 = 1
SET Delivery_person_Age = avg_table.avg_age
WHERE Delivery_person_Age IS NULL;


UPDATE cleaned_delivery_person
JOIN (
    SELECT ROUND(AVG(Delivery_person_Ratings), 2) AS avg_rating
    FROM (
        SELECT Delivery_person_Ratings
        FROM cleaned_delivery_person
        WHERE Delivery_person_Ratings IS NOT NULL
    ) AS ratings_sub
) AS avg_table
ON 1 = 1
SET Delivery_person_Ratings = avg_table.avg_rating
WHERE Delivery_person_Ratings IS NULL;


-- Convert data types
ALTER TABLE cleaned_delivery_person
  MODIFY COLUMN Delivery_person_Age INT,
  MODIFY COLUMN Delivery_person_Ratings FLOAT;


ALTER TABLE cleaned_order_details
  MODIFY COLUMN `Time_taken(min)` FLOAT;

-- Replace NULLs in Vehicle_condition with 0
UPDATE cleaned_order_details
SET Vehicle_condition = 0
WHERE Vehicle_condition IS NULL;

ALTER TABLE cleaned_order_details
  MODIFY COLUMN Vehicle_condition INT;
