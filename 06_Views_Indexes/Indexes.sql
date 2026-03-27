
---- ## CREATING INDEXES

CREATE INDEX idx_fact_location
ON Fact_Swiggy_Orders(location_id)


CREATE INDEX idx_fact_category
ON Fact_Swiggy_Orders(category_id)

CREATE INDEX idx_fact_date
ON Fact_Swiggy_Orders(date_id)

CREATE INDEX idx_dim_date
ON Dim_Date(year, month)

CREATE INDEX idx_fact_restaurant
ON Fact_Swiggy_Orders(restaurant_id)

CREATE INDEX idx_fact_dish
ON Fact_Swiggy_Orders(dish_id)

CREATE INDEX idx_dim_location_state
ON Dim_Location(State)

