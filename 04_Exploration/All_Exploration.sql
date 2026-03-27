----## DATE-BASED ANALYSIS

--Monthly Orders and revenue
SELECT
	d.year,
	d.month,
	COUNT(*) AS orders,
	SUM(price_INR) AS Revenue
FROM Fact_Swiggy_Orders f
JOIN Dim_Date d ON f.date_id=d.date_id
GROUP BY d.year,d.month
ORDER BY d.year,d.month


--Weekend vs Weekday Analysis
SELECT
	CASE 
		WHEN DATENAME(WEEKDAY,d.fulldate) IN 
		('saturday','sunday') THEN 'weekend' 
		ELSE 'weekday' END AS day_type,
COUNT(*) AS orders,
	SUM(price_INR) AS Revenue
FROM Fact_Swiggy_Orders f
JOIN Dim_Date d ON f.date_id=d.date_id
GROUP BY CASE 
		WHEN DATENAME(WEEKDAY,d.fulldate) IN 
		('saturday','sunday') THEN 'weekend' 
		ELSE 'weekday' END



---- ## LOCATION-BASED ANALYSIS

--Revenue by State
SELECT
	l.State,
	SUM(f.price_INR) AS total_revenue
FROM Fact_Swiggy_Orders f
JOIN Dim_Location l ON f.location_id=l.location_id
GROUP BY l.State
ORDER BY total_revenue DESC

--Orders by State
SELECT 
	l.State ,
	COUNT(*) AS total_orders
FROM Fact_Swiggy_Orders f
JOIN Dim_Location l ON f.location_id=l.location_id
GROUP BY l.State
ORDER BY total_orders DESC



----## RESTAURANT-BASED ANALYSIS

--Orders,revenue per Restaurant
SELECT 
	r.restaurant_Name,
	COUNT(*) as total_orders,
	SUM(f.price_INR) as total_revenue
FROM Fact_Swiggy_Orders f
JOIN Dim_Restaurant r ON r.restaurant_id=f.restaurant_id
GROUP BY r.restaurant_Name
ORDER BY total_orders DESC



----## FOOD PREFERENCE ANALYSIS

--Orders,Revenue by Category
SELECT 
	c.Categroy,
	COUNT(*) AS Orders,
	SUM(f.price_INR) as total_revenue
FROM Fact_Swiggy_Orders f
JOIN Dim_Category c ON c.category_id=f.category_id
GROUP BY c.Categroy
ORDER BY total_revenue DESC


--Most ordered Dishes
SELECT 
	d.Dish_name,
	COUNT(*) AS Order_count
FROM Fact_Swiggy_Orders f
JOIN Dim_Dish d ON d.dish_id=f.dish_id
GROUP BY d.dish_Name
ORDER BY Order_count DESC

--Low Performance Dishes
SELECT 
	d.Dish_name,
	COUNT(*) AS Order_count,
	AVG(f.rating) as avg_rating
FROM Fact_Swiggy_Orders f
JOIN Dim_Dish d ON d.dish_id=f.dish_id
GROUP BY d.dish_Name
HAVING COUNT(*)<10

--Cuisine Performance(orders + ratings)
SELECT
	c.Categroy,
	COUNT(*) AS total_orders,
	AVG(f.rating) as avg_rating
FROM Fact_Swiggy_Orders f
JOIN Dim_Category c ON c.category_id=f.category_id
GROUP BY c.Categroy
ORDER BY total_orders DESC

--Orders by Price Bucket
SELECT 
	price_bucket,
	COUNT(*) as Orders
FROM Fact_Swiggy_Orders
GROUP BY price_bucket

--10 Top Rated Dishes
SELECT TOP 10 
	D.dish_Name,
	f.rating,
	f.ranting_count
FROM Fact_Swiggy_Orders f
JOIN Dim_Dish d ON d.dish_id=f.dish_id
ORDER BY f.rating DESC