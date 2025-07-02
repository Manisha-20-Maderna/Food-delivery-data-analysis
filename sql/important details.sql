-- Total Orders
SELECT COUNT(*) AS total_orders FROM cleaned_order_details;

-- ️ Average Delivery Time (in minutes)
SELECT ROUND(AVG(`Time_taken(min)`), 2) AS avg_time_taken FROM cleaned_order_details;

--  Avg. Delivery Time by Vehicle Condition
SELECT Vehicle_condition, ROUND(AVG(`Time_taken(min)`), 2) AS avg_time
FROM cleaned_order_details
GROUP BY Vehicle_condition;

--  Orders per Day
SELECT Order_Date, COUNT(*) AS total_orders
FROM cleaned_order_details
GROUP BY Order_Date
ORDER BY Order_Date;

--  Orders by Multiple Deliveries
SELECT multiple_deliveries, COUNT(*) AS total
FROM cleaned_order_details
GROUP BY multiple_deliveries
ORDER BY multiple_deliveries;


--  Count of Unique Restaurant Locations
SELECT COUNT(DISTINCT CONCAT(Restaurant_latitude, ',', Restaurant_longitude)) AS unique_restaurants
FROM cleaned_location_details;

--  Count of Unique Delivery Locations
SELECT COUNT(DISTINCT CONCAT(Delivery_location_latitude, ',', Delivery_location_longitude)) AS unique_delivery_points
FROM cleaned_location_details;


--  Total Delivery Persons
SELECT COUNT(*) AS total_delivery_persons FROM cleaned_delivery_person;

--  Average Delivery Ratings
SELECT ROUND(AVG(Delivery_person_Ratings), 2) AS avg_rating FROM cleaned_delivery_person;

--  Age Distribution (Grouped)
SELECT
  CASE
    WHEN Delivery_person_Age < 25 THEN '< 25'
    WHEN Delivery_person_Age BETWEEN 25 AND 34 THEN '25-34'
    WHEN Delivery_person_Age BETWEEN 35 AND 44 THEN '35-44'
    ELSE '45+'
  END AS age_group,
  COUNT(*) AS count
FROM cleaned_delivery_person
GROUP BY age_group;


--  Average Time by Delivery Person Age Group
SELECT
  CASE
    WHEN d.Delivery_person_Age < 25 THEN '< 25'
    WHEN d.Delivery_person_Age BETWEEN 25 AND 34 THEN '25-34'
    WHEN d.Delivery_person_Age BETWEEN 35 AND 44 THEN '35-44'
    ELSE '45+'
  END AS age_group,
  ROUND(AVG(o.`Time_taken(min)`), 2) AS avg_delivery_time
FROM cleaned_order_details o
JOIN cleaned_delivery_person d ON o.ID = d.ID
GROUP BY age_group;


-- Avg delivery time by rating band
SELECT
  CASE
    WHEN Delivery_person_Ratings < 2 THEN 'Poor'
    WHEN Delivery_person_Ratings < 3 THEN 'Fair'
    WHEN Delivery_person_Ratings < 4 THEN 'Good'
    ELSE 'Excellent'
  END AS rating_group,
  ROUND(AVG(o.`Time_taken(min)`), 2) AS avg_time
FROM cleaned_order_details o
JOIN cleaned_delivery_person d ON o.ID = d.ID
GROUP BY rating_group;


-- Hourly order volume
SELECT HOUR(Time_Orderd) AS order_hour, COUNT(*) AS total_orders
FROM cleaned_order_details
GROUP BY order_hour
ORDER BY order_hour;


-- Orders where pickup was > 15 mins after order
SELECT COUNT(*) AS late_pickups
FROM cleaned_order_details
WHERE TIMESTAMPDIFF(MINUTE, Time_Orderd, Time_Order_picked) > 15;
