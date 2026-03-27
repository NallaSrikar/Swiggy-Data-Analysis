

----## DATE-BASED ANALYSIS

--Month-over-Month Analysis
WITH monthly_revenue AS(
	SELECT
	d.year,
	d.month,
	SUM(f.price_INR) AS Revenue	
FROM Fact_Swiggy_Orders f
JOIN Dim_Date d ON f.date_id=d.date_id
GROUP BY d.year,d.month
)
SELECT
year,
month,
Revenue,
LAG(Revenue) OVER(ORDER BY year,month) as Prev_month_revenue
FROM monthly_revenue
ORDER BY year,month


--Month-over-Month Growth
SELECT
	year,
	month,
	Revenue,
	LAG(Revenue) OVER(ORDER BY year,month) as Prev_month_revenue,
	Revenue - LAG(Revenue) OVER(ORDER BY year,month) as Growth
FROM(
	SELECT
	d.year,
	d.month,
	SUM(f.price_INR) AS Revenue	
FROM Fact_Swiggy_Orders f
JOIN Dim_Date d ON f.date_id=d.date_id
GROUP BY d.year,d.month
) t


--Running Total
SELECT
	d.year,
	d.month,
	SUM(f.price_INR) AS Revenue	,
	SUM(SUM(f.price_INR)) OVER (ORDER BY d.year,d.month) as cumulative_revenue
FROM Fact_Swiggy_Orders f
JOIN Dim_Date d ON f.date_id=d.date_id
GROUP BY d.year,d.month

--Peak Month by Revenue 
SELECT TOP 1
	d.month_Name,
	COUNT(*) AS orders,
	SUM(price_INR) AS Revenue
FROM Fact_Swiggy_Orders f
JOIN Dim_Date d ON f.date_id=d.date_id
GROUP BY d.month_Name
ORDER BY Revenue DESC




----## LOCATION-BASED ANALYSIS

--Revenue contribution % by State
SELECT 
	l.State ,
	FORMAT(SUM(f.price_INR)*100.0 /
	SUM(SUM(f.price_INR)) OVER(),'N2') + ' %' AS revenue_pct
FROM Fact_Swiggy_Orders f
JOIN Dim_Location l ON f.location_id=l.location_id
GROUP BY l.State
ORDER BY revenue_pct DESC

--Top City in Each State
WITH top_city AS(
SELECT 
	l.State,
	l.city,
	COUNT(*) AS total_orders,
	SUM(f.price_INR) AS total_revenue,
	RANK() OVER(PARTITION BY L.State ORDER BY SUM(f.price_INR) DESC) AS rnk
FROM Fact_Swiggy_Orders f
JOIN Dim_Location l ON f.location_id=l.location_id
GROUP BY l.State,L.city
)
SELECT * 
FROM top_city
WHERE rnk=1

--State-wise Mnthly Trend
SELECT
	l.State,
	d.year,
	d.month,
	SUM(f.price_INR) AS Revenue
FROM Fact_Swiggy_Orders f
JOIN Dim_Date d ON f.date_id=d.date_id
JOIN Dim_location l ON f.location_id=l.location_id
GROUP BY l.State, d.year, d.month
ORDER BY l.State, d.year, d.month




----## RESTAURANT-BASED ANALYSIS

--Average Rating
SELECT 
	r.restaurant_Name,
	AVG(f.rating) as avg_rating
FROM Fact_Swiggy_Orders f
JOIN Dim_Restaurant r ON r.restaurant_id=f.restaurant_id
GROUP BY r.restaurant_Name
ORDER BY avg_rating DESC

--Top 10 Restaurant 
SELECT *
FROM (SELECT
	r.restaurant_Name,
	COUNT(*) as total_orders,
	RANK() OVER (ORDER BY COUNT(*) DESC)AS rnk
FROM Fact_Swiggy_Orders f
JOIN Dim_Restaurant r ON r.restaurant_id=f.restaurant_id
GROUP BY r.restaurant_Name
) t
WHERE rnk<=10

--Top 3 Restaurant per state
SELECT *
FROM (SELECT
	l.State,
	r.restaurant_Name,
	COUNT(*) as total_orders,
	RANK() OVER (PARTITION BY l.State ORDER BY COUNT(*) DESC)AS rnk
FROM Fact_Swiggy_Orders f
JOIN Dim_Restaurant r ON r.restaurant_id=f.restaurant_id
JOIN Dim_location l ON f.location_id=l.location_id
GROUP BY l.State, r.restaurant_Name
) t
WHERE rnk<=3




----## FOOD PREFERENCE ANALYSIS

--Top Category,Dish per State
SELECT *
FROM (SELECT
	l.State,
	c.Categroy,
	d.dish_Name,
	COUNT(*) as total_orders,
	RANK() OVER (PARTITION BY l.State ORDER BY SUM(f.price_INR) DESC)AS rnk
FROM Fact_Swiggy_Orders f
JOIN Dim_Category c ON c.category_id=f.category_id
JOIN Dim_Dish d ON d.dish_id=f.dish_id
JOIN Dim_location l ON f.location_id=l.location_id
GROUP BY l.State, c.Categroy,d.dish_Name
) t
WHERE rnk<=1

--Category Rating vs Revenue
SELECT
	c.Categroy,
	AVG(f.rating) AS avg_rating,
	SUM(f.price_INR) AS revenue
FROM Fact_Swiggy_Orders f
JOIN Dim_Category c ON c.category_id=f.category_id
GROUP BY c.Categroy

--Dish Price Variation in states,restaurants

SELECT State,Restaurant_Name, Dish_Name,MIN(Price_INR) minimum_price,MAX(Price_INR) maximum_price
FROM Swiggy_Data
GROUP BY Dish_Name,State,Restaurant_Name
HAVING MIN(Price_INR) <> MAX(Price_INR)