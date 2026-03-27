
----## STORED PROCEDURES


--Sate,Category Analysis
CREATE PROCEDURE sp_analysis
    @type VARCHAR(50)
AS
BEGIN
    IF @type = 'State'
    BEGIN
        SELECT
         l.State,
        COUNT(*) AS orders,
        SUM(f.price_INR) AS revenue,
		AVG(f.rating) AS avg_rating
    FROM Fact_Swiggy_Orders f
    JOIN dim_location l ON f.location_id = l.location_id
    GROUP BY l.state;
    END

    ELSE IF @type = 'Category'
    BEGIN
        SELECT 
		c.Categroy,
        COUNT(*) AS orders,
        SUM(f.price_INR) AS revenue,
		AVG(f.rating) AS avg_rating
    FROM Fact_Swiggy_Orders f
    JOIN dim_category c ON f.category_id = c.category_id
    GROUP BY c.Categroy;
    END
END;

EXEC sp_analysis 'State'
EXEC sp_analysis 'Category'


--Top Dish Analysis
CREATE PROCEDURE sp_top_dishes
    @top_n INT
AS
BEGIN
    SELECT TOP (@top_n)
        dsh.dish_name,
        COUNT(*) AS total_orders,
        SUM(f.Price_INR) AS revenue,
		AVG(f.rating) AS avg_rating
    FROM Fact_Swiggy_Orders f
    JOIN dim_dish dsh ON f.dish_id = dsh.dish_id
    GROUP BY dsh.dish_name
    ORDER BY total_orders DESC;
END;

EXEC sp_top_dishes '10'

--Monthly Trend Analysis
CREATE PROCEDURE sp_monthly_trend
AS
BEGIN
    SELECT 
        d.year,
        d.month,
        SUM(f.price_INR) AS revenue,
        LAG(SUM(f.price_INR)) OVER(ORDER BY d.year, d.month) AS prev_month,
		SUM(f.price_INR)-LAG(SUM(f.price_INR)) OVER(ORDER BY year,month) AS Growth
    FROM Fact_Swiggy_Orders f
    JOIN dim_date d ON f.date_id = d.date_id
    GROUP BY d.year, d.month;
END;

EXEC sp_monthly_trend

--Data Quality Analysis
CREATE PROCEDURE sp_data_quality_report
AS
BEGIN
    SELECT 
        COUNT(*) AS total_rows,
        SUM(CASE WHEN data_issue_flag = 'Invalid Rating Count'  THEN 1 ELSE 0 END) AS bad_rows,
        SUM(CASE WHEN data_issue_flag = 'Invalid Rating Count' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS issue_pct
    FROM Swiggy_Data;
END;

EXEC sp_data_quality_report

--State and Price bucket Filter Analysis
CREATE PROCEDURE sp_kpi_filter
    @state VARCHAR(50),
    @price_bucket VARCHAR(20)
AS
BEGIN
    SELECT 
        l.State,
        f.price_bucket,
        COUNT(*) AS orders,
        SUM(f.price_INR) AS revenue
    FROM Fact_Swiggy_Orders f
    JOIN dim_location l ON f.location_id = l.location_id
    WHERE l.state = @state
      AND f.price_bucket = @price_bucket
    GROUP BY l.state, f.price_bucket;
END;

EXEC sp_kpi_filter assam,low


