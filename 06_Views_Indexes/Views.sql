
------// VIEWS 

-- Time analysis summary VIEW

CREATE VIEW vw_time_analysis AS
SELECT
	d.year,
	d.month,
	COUNT(*) AS orders,
	SUM(f.price_INR) AS Revenue,
	SUM(SUM(f.price_INR)) OVER (ORDER BY d.year,d.month) AS cumulative_revenue,
	LAG(SUM(f.price_INR)) OVER(ORDER BY year,month) AS Prev_month_revenue,
	SUM(f.price_INR)-LAG(SUM(f.price_INR)) OVER(ORDER BY year,month) AS Growth
FROM Fact_Swiggy_Orders f
JOIN Dim_Date d ON f.date_id=d.date_id
GROUP BY d.year,d.month

SELECT * FROM vw_time_analysis



--State Analysis Summary VIEW 

CREATE VIEW vw_state_analysis AS
SELECT
	l.State,
	COUNT(*) AS total_orders,
	SUM(f.price_INR) AS total_revenue,
	AVG(f.rating) AS avg_rating,
	RANK() OVER( ORDER BY SUM(f.price_INR),AVG(f.rating)DESC) AS rn
FROM Fact_Swiggy_Orders f
JOIN Dim_Location l ON f.location_id=l.location_id
GROUP BY l.State


SELECT *
FROM vw_state_analysis



--Restaurant Analysis summary VIEW 

CREATE VIEW vw_restaurant_analysis AS
SELECT 
	r.restaurant_Name,
	COUNT(*) as total_orders,
	SUM(f.price_INR) as total_revenue,
	AVG(f.rating) as avg_rating,
	RANK() OVER (ORDER BY COUNT(*) DESC)AS rnk
FROM Fact_Swiggy_Orders f
JOIN Dim_Restaurant r ON r.restaurant_id=f.restaurant_id
GROUP BY r.restaurant_Name

SELECT *
FROM vw_restaurant_analysis



--Category Summary VIEW

CREATE VIEW vw_category_analysis AS
SELECT 
	c.Categroy,
	COUNT(*) AS Orders,
	SUM(f.price_INR) as total_revenue,
	AVG(f.rating) as avg_rating,
	RANK() OVER ( ORDER BY SUM(f.price_INR) DESC)AS rnk
FROM Fact_Swiggy_Orders f
JOIN Dim_Category c ON c.category_id=f.category_id
GROUP BY c.Categroy

SELECT *
FROM vw_category_analysis


 
--Dish Analysis Summary VIEW

CREATE VIEW vw_dish_analysis AS
SELECT 
	c.Categroy,
	d.dish_name,
	COUNT(*) AS Orders,
	SUM(f.price_INR) as total_revenue,
	AVG(f.rating) as avg_rating,
	RANK() OVER (ORDER BY SUM(f.price_INR) DESC)AS rnk
FROM Fact_Swiggy_Orders f
JOIN Dim_Category c ON c.category_id=f.category_id
JOIN Dim_Dish d ON d.dish_id=f.dish_id
GROUP BY c.Categroy,d.dish_name

SELECT *
FROM vw_dish_analysis


