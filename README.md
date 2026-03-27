# Swiggy-Data-Analysis

This Project Focuses on analyzing swiggy data. The project transforms raw Swiggy delivery data into a structured Star Schema, implementing advanced data cleaning, ETL processes, and analytical querying to derive business insights.

## Project Overview

The objective of this project is to analyze Swiggy's food ordering patterns, restaurant performance, and regional revenue trends. The workflow covers the entire data lifecycle:

**Data Cleaning:** Standardizing formats and handling anomalies.

**Data Modeling:** Designing a Star Schema for optimized performance.

**ETL:** Migrating raw data into Dimension and Fact tables.

**Advanced Analytics:** Using Window Functions, Indexes, CTEs, Triggers and Stored Procedures for business KPIs.

## Objectives

1.Clean Raw Data and Create Data Model

2.Ensure data quality and validation

3.Analyze revenue and order trends

4.Identify top-performing states and restaurants

5.Evaluate category-wise performance and customer Behavior 

6.Optimize query performance

## Data MOdel

The project follows a Star Schema design to ensure efficient querying and clear data relationships.

**Fact Table:** Fact_Swiggy_Orders (contains metrics: price, ratings, and foreign keys).

**Dimension Tables:** Dim_Date, Dim_Location, Dim_Restaurant, Dim_Category, and Dim_Dish.

**Audit Table:** order_audit (tracks price changes via triggers).

## File Structure & Execution Flow

**1. Data Preparation (Data_Cleaning.sql)**

Before modeling, the raw data underwent rigorous cleaning:

**Null & Blank Handling:** Identified and trimmed whitespace from categorical columns.

**Deduplication**: Used ROW_NUMBER() and CTE to remove duplicate order records.

**Type Casting:** Standardized dates and decimal formats for financial accuracy.

**Feature Engineering:** Created a Price_Bucket (Low/Medium/High) and data_issue_flag for quality control.

**2. Schema Definition (Tables.sql & Indexes.sql)**

Defined Primary and Foreign key relationships to maintain Referential Integrity.

Implemented B-Tree Indexes on frequently joined columns (e.g., location_id, date_id) to optimize query performance.

**3. ETL & Data Seeding (Seed_Data.sql)**

Populated Dimension tables using SELECT DISTINCT from the raw dataset.

Loaded the Fact table by joining the cleaned raw data with newly created dimensions to map surrogate keys.

**4. Advanced Analytics (Analysis.sql & Exploration.sql)**

This is the core of the project, focusing on four key areas:

**Time Intelligence:** Month-over-Month (MoM) growth, Running Totals, and Weekend vs. Weekday performance.

**Geospatial Analysis:** Revenue contribution % by State and identifying the top-performing city in each region.

**Restaurant Insights:** Ranking top 3 restaurants per state using RANK().

**Food Preferences:** Analyzing "Low Performance Dishes" (high orders but low ratings) and category-wise revenue.

**5. Programmability & Automation**

**Indexes** (Indexes.sql): Created indexes on foreign keys and frequently used columns, Used composite indexes for multi-dimensional analysis and Improved query execution time 

**Stored Procedures** (Stored_Procedures.sql): Created modular scripts for dynamic reporting (e.g., sp_top_dishes allowing a user to input a variable N for top results).

**Triggers** (Triggers.sql): Automated data validation (preventing ratings without counts) and an audit log for price updates.

**Views** (Views.sql): Abstracted complex joins into simple views for stakeholders (e.g., vw_state_analysis).

## 📊 Key Business Insights Derived

**Revenue Trends:** 

**Peak Performance:** January 2025 was the highest revenue month **(6.82M)**.

**Revenue Stability:** Revenue remained remarkably stable throughout the year, fluctuating between **6.2M** and **6.8M** per month.

**Growth Trends:** After a slight dip in **February (-8.1%**), the platform saw a recovery in **March (+4.8%**) and maintained steady growth through May.

**Cumulative Success:** By August 2025, the platform achieved a total cumulative revenue of **53M+**.

**Restaurant & Category InsightsQuery**

**Volume vs. Value:**  McDonald's is the leader in order volume (**13,528 orders**).KFC is the leader in total revenue **(4.24M)**, indicating a higher average order value (AOV) compared to other chains.
 
**Menu Engineering:** The "Recommended" category is the single largest revenue driver **(7.18M)**, proving that Swiggy's algorithm and promotional placements significantly influence customer buying behavior.
 
 **Top Dish Preferences:** Burger and McSaver combos are high-performing categories with both high volume and high average ratings **(4.4+)**

**Customer Behavior:**

Segmented orders into "Price Buckets" to understand the dominant spending tier.

**Market Sensitivity:** 92.05% of all orders fall into the "Low" price bucket (<500 INR).

**Premium Segment:** Only 1.17% of orders are categorized as "High" price ($>1000$ INR), highlighting that Swiggy is primarily used for affordable, everyday meals rather than high-end dining.

**Weekend vs. Weekday:** Weekday revenue contributes significantly more to the total (37.5M) due to the 5-day cycle, but the revenue density on weekends suggests that customers place higher-value orders during their time off.

**Operational Efficiency:**

Tracked "Data Issues" (invalid rating counts) and flaged to improve future data collection.

## 🛠️ Tech Stack

**Database:** Microsoft SQL Server / T-SQL

**Concepts:** Star Schema, CURD Operations, CTEs, Window Functions (LAG, RANK, SUM OVER), Stored Procedures, Triggers, Views, and Indexing.

## How to Run the Project

Import Swiggy Raw Data into SQL server and Perfrom Data Cleaning 

Run Tables.sql to create schema

Insert data 

Run Indexes.sql for optimization

Run Views.sql for analysis layer

Run Procedures.sql, Triggers.sql

Use Analysis.sql for advanced queries 
