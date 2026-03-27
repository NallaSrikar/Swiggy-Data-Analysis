
 --Loading Data into Tables

 INSERT INTO Dim_Date (fulldate,year,month,month_name,quarter,week,day)
	 SELECT DISTINCT Order_Date,
	 YEAR(Order_Date),
	 MONTH(Order_Date),
	 DATENAME(MONTH,Order_Date),
	 DATEPART(QUARTER,Order_Date),
	 DATEPART(WEEK,Order_Date),
	 DAY(Order_Date)
 from Swiggy_Data
 WHERE Order_Date IS NOT NULL

SELECT* FROM Dim_Date

 INSERT INTO Dim_Location (State,city,location)
 SELECT DISTINCT
	State,city,Location
from Swiggy_Data

SELECT* FROM Dim_Location

 INSERT INTO Dim_Restaurant (restaurant_Name)
 SELECT DISTINCT 
	Restaurant_name
from Swiggy_Data

SELECT* FROM Dim_Restaurant


INSERT INTO Dim_Category (Categroy)
SELECT DISTINCT 
	Category
FROM Swiggy_Data 


SELECT* FROM Dim_Category

INSERT INTO Dim_Dish(dish_Name)
SELECT DISTINCT 
	Dish_Name
FROM Swiggy_Data

SELECT* FROM Dim_Dish

INSERT INTO Fact_Swiggy_Orders ( date_id,
 location_id ,
 restaurant_id,
 category_id,
 dish_id,
 price_INR,
 rating,
 ranting_count,
 price_bucket)
 SELECT dd.date_id,
 dl.location_id ,
 dr.restaurant_id,
 dc.category_id,
 di.dish_id,
 s.price_INR,
 s.rating,
 s.rating_count,
 s.Price_Bucket
 FROM Swiggy_Data s

 JOIN Dim_Date dd ON dd.fulldate=s.Order_date
 JOIN Dim_Location dl ON dl.state=s.State AND dl.city=s.City AND dl.location=s.Location
 JOIN Dim_Restaurant dr ON dr.restaurant_Name =s.Restaurant_Name
 JOIN Dim_Category dc ON dc.Categroy=s.Category
 JOIN Dim_Dish di ON di.dish_Name=s.Dish_Name


SELECT * FROM Fact_Swiggy_Orders 



EXEC sp_rename 'Fact_Swiggy_Orders.ranting_count', 'rating_count', 'column'


--Reading Data from all tables
SELECT *
FROM Fact_Swiggy_Orders s
JOIN Dim_Date dd ON dd.date_id=s.date_id
JOIN Dim_Location dl ON  dl.location_id=s.location_id
JOIN Dim_Restaurant dr ON dr.restaurant_id =s.restaurant_id
JOIN Dim_Category dc ON dc.category_id=s.category_id
JOIN Dim_Dish di ON di.dish_id=s.dish_id
