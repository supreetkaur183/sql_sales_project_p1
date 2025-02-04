-- SQL Retail Sales Analysis - P1

-- 1. DATABASE SETUP

-- Database Creation: The project starts by creating a database 
CREATE DATABASE Sql_project_p1;

-- Table Creation: A table named retail_sales is created to store the sales data.

DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

-- 2.DATA EXPLORATION AND CLEANING

SELECT 
    COUNT(*)
FROM
    retail_sales;

-- Null Value Check: Check for any null values in the dataset and delete records with missing data.
SELECT 
    *
FROM
    retail_sales
WHERE
    sale_date IS NULL OR sale_time IS NULL
        OR customer_id IS NULL
        OR gender IS NULL
        OR age IS NULL
        OR category IS NULL
        OR quantity IS NULL
        OR price_per_unit IS NULL
        OR cogs IS NULL;


DELETE FROM retail_sales 
WHERE
    sale_date IS NULL OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL;
    
-- 3. DATA EXPLORATION AND FINDINGS

-- Category Count: Identify all unique product categories in the dataset.
SELECT DISTINCT
    category
FROM
    retail_sales;
    
-- How many sales we have?
SELECT 
   SUM(total_sale) AS total_sales
FROM
    retail_sales;

-- How many cutsomers we have?
SELECT 
    COUNT(DISTINCT customer_id) AS total_customer
FROM
    retail_sales;
    
-- Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT 
    *
FROM
    retail_sales
WHERE
    sale_date = '2022-11-05';

-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 2 in the month of Nov-2022:
SELECT *
FROM
    retail_sales
WHERE
    category = 'Clothing' 
    AND quantity > 2
	AND MONTH(sale_date) = 11 
	AND YEAR(sale_date) = 2022;
    
-- Write a SQL query to calculate the total sales (total_sale) for each category.:
SELECT 
    category,
    SUM(total_sale) AS net_sales,
    COUNT(*) AS total_orders
FROM
    retail_sales
GROUP BY 1;

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT 
    ROUND(AVG(age), 2)
FROM
    retail_sales
WHERE
    category = 'beauty';

-- Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT 
    *
FROM
    retail_sales
WHERE
    total_sale > 1000;
    
-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT 
    category, gender, COUNT(transactions_id) AS total_transaction
FROM
    retail_sales
GROUP BY 1, 2
ORDER BY 1;

-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT year, month, average_sales
FROM
(
SELECT 
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS month,
    ROUND(AVG(total_sale), 2) AS average_sales,
    RANK() OVER(PARTITION BY YEAR(sale_date) order by ROUND(AVG(total_sale), 2) DESC) AS ranking
FROM
    retail_sales
GROUP BY 1 , 2) as t1
where ranking = 1;
-- ORDER BY 1 , 3 DESC;

-- Write a SQL query to find the top 5 customers based on the highest total sales
SELECT 
    customer_id, SUM(total_sale) AS total_sale
FROM
    retail_sales
GROUP BY 1
ORDER BY total_sale DESC
LIMIT 5;

-- Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT 
    category, COUNT(DISTINCT customer_id) AS cnt_unique_cs
FROM
    retail_sales
GROUP BY category;

-- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
With hourly_sales
As
(
select * ,
	CASE 
		WHEN hour(sale_time) < 12 THEN 'Morning'
		WHEN hour(sale_time) BETWEEN 12 and 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift
FROM retail_sales
)
Select shift, count(*) as total_orders from hourly_sales
group by shift