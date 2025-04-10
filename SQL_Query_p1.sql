-- SQL RETAIL SALES ANALYSIS - P1
CREATE DATABASE sql_project_p2;

-- CREATE TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
            (
                transaction_id int PRIMARY KEY,	
                sale_date date,	 
                sale_time time,	
                customer_id	int,
                gender	varchar(15),
                age	int,
                category varchar(15),	
                quantity	int,
                price_per_unit float,	
                cogs	float,
                total_sale float
            );

SELECT * FROM retail_sales
LIMIT 10

SELECT 
    COUNT(*) 
FROM retail_sales

-- Data cleaning
SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE sale_time IS NULL

SELECT * FROM RETAIL_SALES
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- 
DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

	-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales

-- How many uniuque customers we have ?

SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales

SELECT DISTINCT category FROM retail_sales

-- Data Analysis & Business Key Problems & Answers
-- My Analysis & Findings

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT * FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND 
	quantity >= 4
	
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT
	category,
	SUM(total_sale) AS net_sale,
	COUNT(*) AS total_orders
FROM retail_sales
GROUP BY 1

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT
	round(AVG(age), 2)
FROM retail_sales
WHERE 
category = 'beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT 
transaction_id
FROM retail_sales
WHERE total_sale >1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category, gender,
COUNT(*) AS total_trans
FROM retail_sales
GROUP BY category, gender

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT * FROM
(
SELECT
EXTRACT(YEAR FROM sale_date) AS YEAR,
EXTRACT(MONTH FROM sale_date) AS MONTH,
AVG(total_sale) AS total_sale,
RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS RANK
FROM retail_sales
GROUP BY 1,2
)
AS T1
WHERE RANK = 1
--order by 1,3 desc

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT
customer_id,
SUM(total_sale) AS total_sale
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT * FROM retail_sales

SELECT 
	category,
	COUNT(DISTINCT customer_id) AS unique_customer
--unique(customer_id) as unique_customer_id
FROM retail_sales
GROUP BY 1

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(SELECT sale_time,
CASE 
	WHEN EXTRACT(HOUR FROM sale_time) <=12 THEN 'morning'
	WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'afternoon'
	WHEN EXTRACT(HOUR FROM sale_time) >=17 THEN 'evening'
	END AS shift
--count(quantity) as no_of_orders
FROM retail_sales)
SELECT shift, COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift
--select extract (hour from current_time

--end of project