--// RAW DATA

--Reading rows

SELECT* FROM Swiggy_Data


--// DATA CLEANING 


--Structure validation

SELECT column_name,data_type
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name= 'swiggy_data'

--NULLHandling

SELECT 
SUM(CASE WHEN State IS NULL THEN 1 ELSE 0 END ) AS State_nulls,
SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END ) AS City_nulls,
SUM(CASE WHEN Order_Date IS NULL THEN 1 ELSE 0 END ) AS Orderdate_nuls,
SUM(CASE WHEN Restaurant_Name IS NULL THEN 1 ELSE 0 END ) AS Restaurant_nulls,
SUM(CASE WHEN Location IS NULL THEN 1 ELSE 0 END ) AS Location_nulls,
SUM(CASE WHEN Category IS NULL THEN 1 ELSE 0 END ) AS Category_nulls,
SUM(CASE WHEN Dish_Name IS NULL THEN 1 ELSE 0 END ) AS Dish_nulls,
SUM(CASE WHEN Price_INR IS NULL THEN 1 ELSE 0 END ) AS price_nuls,
sum(CASE WHEN Rating IS NULL THEN 1 ELSE 0 END ) AS Rating_nulls,
SUM(CASE WHEN Rating_Count IS NULL THEN 1 ELSE 0 END ) AS Ratingcount_nulls
FROM Swiggy_Data

--Blanking/Dirty Cleaning

SELECT*
FROM Swiggy_Data
WHERE State='' OR City='' OR Restaurant_Name='' OR Location=''OR Category='' OR Dish_Name=''

UPDATE Swiggy_Data
SET State= TRIM(State), City=TRIM(City),
Restaurant_Name=TRIM(Restaurant_Name),
Location=TRIM(location),Category=TRIM(Category),
Dish_Name=TRIM(Dish_Name)

--Duplicate Handling

WITH cte AS (
SELECT*,ROW_NUMBER() OVER(PARTITION BY State,City,Order_Date,Restaurant_Name,Location,
Category,Dish_Name,Price_INR,Rating,Rating_count ORDER BY State) AS rn
FROM Swiggy_Data
)
DELETE FROM cte 
WHERE rn>1

--Data Type Fixing

ALTER TABLE Swiggy_Data
ALTER COLUMN Price_INR DECIMAL(10,2)

--Date Cleaning

UPDATE Swiggy_Data
SET Order_Date=CONVERT(DATE,Order_Date) 

--Data Profiling 

select COUNT(*) AS total_rows,
	MIN(Price_INR) AS minimum_price,
	MAX(Price_INR) AS maximum_price,
	AVG(Price_INR) AS average_price,
	MIN(Rating) AS minimum_rating,
	MAX(Rating) AS maximum_rating,
	AVG(Rating) AS average_rating
FROM Swiggy_Data

--Inconsistent Data Handiling / Adding Flag Column

SELECT *
FROM Swiggy_Data
where Rating>0 AND Rating_Count=0

ALTER TABLE Swiggy_Data
ALTER COLUMN Rating FLOAT NULL

UPDATE Swiggy_Data
SET Rating=NULL
WHERE Rating>0 AND Rating_Count=0


ALTER TABLE Swiggy_Data
ADD data_issue_flag VARCHAR(50)

UPDATE Swiggy_Data
SET data_issue_flag='Invalid Rating Count'
WHERE Rating IS NULL AND Rating_Count=0


--Price Segmentation

ALTER TABLE Swiggy_data
ADD Price_Bucket VARCHAR(20)

UPDATE Swiggy_data
SET Price_Bucket =
	CASE 
		WHEN Price_INR<500 THEN 'Low'
		WHEN Price_INR<1000 THEN 'Medium'
		ELSE 'High'
	END;
