
--DIMENTION TABLES

CREATE TABLE Dim_Date
	(date_id  INT IDENTITY(1,1) PRIMARY KEY,
	fulldate DATE,
	year INT,
	month INT,
	month_Name VARCHAR(10),
	quarter INT,
	week INT,
	day INT
	)

CREATE TABLE Dim_Location
	( location_id INT IDENTITY(1,1) PRIMARY KEY,
	State VARCHAR(100),
	city VARCHAR(100),
	location VARCHAR(100),
	)


CREATE TABLE Dim_Restaurant
	(restaurant_id INT IDENTITY(1,1) PRIMARY KEY,
	restaurant_Name VARCHAR(200)
	)

CREATE TABLE Dim_Category
	(category_id INT IDENTITY(1,1) PRIMARY KEY,
	Categroy VARCHAR(200)
	)

CREATE TABLE Dim_Dish
	( dish_id INT IDENTITY(1,1) PRIMARY KEY,
	dish_Name VARCHAR(200)
	)

--FACT TABLES

CREATE TABLE Fact_Swiggy_Orders
(order_id INT IDENTITY(1,1) PRIMARY KEY,
 date_id INT,
 location_id INT,
 restaurant_id INT,
 category_id INT,
 dish_id INT,
 price_INR DECIMAL(10,2),
 rating DECIMAL(4,2),
 ranting_count INT,
 price_bucket varchar(50)

 FOREIGN KEY (date_id) REFERENCES Dim_Date(date_id),
 FOREIGN KEY (location_id) REFERENCES Dim_Location(location_id),
 FOREIGN KEY (restaurant_id) REFERENCES Dim_Restaurant(restaurant_id),
 FOREIGN KEY (category_id) REFERENCES dim_Category(category_id),
 FOREIGN KEY (dish_id) REFERENCES Dim_Dish(dish_id)

 )