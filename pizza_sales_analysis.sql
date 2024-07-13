SELECT *
FROM projects.pizza_sales
;

SELECT order_date, STR_TO_DATE(order_date, '%d-%m-%Y') AS new_order_date
FROM pizza_sales
WHERE order_date LIKE '%-%-%'
;

SET SQL_SAFE_UPDATES = 0;

UPDATE pizza_sales
SET order_date = STR_TO_DATE(order_date, '%d-%m-%Y')
WHERE order_date LIKE '%-%-%';

-- A. KPI's
-- 1. Total Revenue
SELECT SUM(total_price) as total_revenue
FROM sales
;

-- 2. Average order value
SELECT COUNT(order_id), COUNT(DISTINCT order_id)
FROM pizza_sales
;

SELECT SUM(total_price)/COUNT(DISTINCT order_id) as avg_order_value
FROM pizza_sales
;

-- 3. Total Pizza Sold
SELECT SUM(quantity) AS total_pizza_sold
FROM pizza_sales
;

-- 4. Total orders
SELECT COUNT(DISTINCT order_id) as total_order
FROM pizza_sales
;

-- 5. Total Pizza per oder
SELECT FORMAT(SUM(quantity)/COUNT(DISTINCT order_id),'N2') as total_pizza_per_order
FROM pizza_sales
;

SELECT CAST(SUM(quantity)/COUNT(DISTINCT order_id) AS DECIMAL (10,2)) as total_pizza_per_order
FROM pizza_sales
;

-- B. Purchase Trend
-- 1. Aggregate total order by DAYNAME

SELECT DAYNAME(order_date) AS day_of_week, COUNT(DISTINCT order_id) AS total_order_per_day
FROM pizza_sales
GROUP BY day_of_week
ORDER BY total_order_per_day DESC
;

-- 2. Aggregate total order by MONTH
SELECT MONTHNAME(order_date) AS 'month', COUNT(DISTINCT order_id) AS total_order_per_day
FROM sales
GROUP BY MONTHNAME(order_date)
ORDER BY total_order_per_day DESC
;

-- C. Revenue by category
-- 1. %sales by category
SELECT pizza_category, SUM(total_price) AS revenue, SUM(total_price) *100 / 
	(SELECT SUM(total_price) FROM pizza_sales) AS percentage
FROM pizza_sales
GROUP BY pizza_category
;

-- 2. quantity by category
SELECT pizza_category, SUM(quantity) AS total_order
FROM pizza_sales
GROUP BY pizza_category
;

-- D. % of sales by Pizza size
SELECT pizza_size, CAST(SUM(total_price) as DECIMAL (10,2)) AS revenue, CAST(CAST(SUM(total_price) as DECIMAL (10,2)) *100 / 
	(SELECT CAST(SUM(total_price) as DECIMAL(10,2)) FROM pizza_sales) AS DECIMAL(10,2)) AS percentage
FROM pizza_sales
GROUP BY pizza_size
ORDER BY pizza_size
;

-- E. Top 5 Pizza 
-- 1. by revenue
SELECT pizza_name, SUM(total_price) AS revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY revenue DESC
LIMIT 5
;

-- 2. by quantity
SELECT pizza_name, SUM(quantity) AS total_sale_volume
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_sale_volume DESC
LIMIT 5
;

-- 3. by order
SELECT pizza_name, COUNT(DISTINCT order_id) AS total_order
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_order DESC
LIMIT 5
;

-- F. Bottom 5 Pizza 
-- 1. by revenue
SELECT pizza_name, SUM(total_price) AS revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY revenue 
LIMIT 5
;

-- 2. by quantity
SELECT pizza_name, SUM(quantity) AS total_sale_volume
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_sale_volume 
LIMIT 5
;

-- 3. by order
SELECT pizza_name, COUNT(DISTINCT order_id) AS total_order
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_order 
LIMIT 5
;

SELECT @@hostname AS server_name;
SELECT DATABASE() AS database_name;