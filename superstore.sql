use project;
select * from superstore;

ALTER TABLE superstore
ADD COLUMN `Shipping Days` INT;

SET SQL_SAFE_UPDATES = 0;



UPDATE superstore
SET `Shipping Days` = DATEDIFF(`Ship Date`,`Order Date`);

-- A. Sales Performance Analysis

-- Q1. Find total sales, total profit, and total quantity sold.
SELECT
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity
FROM superstore;

-- Q2. Find total number of orders and unique customers.
SELECT
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    COUNT(DISTINCT `Customer ID`) AS Total_Customers
FROM superstore;

-- Q3. Calculate the overall profit margin percentage.
SELECT
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2)
        AS Profit_Margin_Percentage
FROM superstore;

-- Q4. Find the top 10 orders based on total sales.
SELECT
    `Order ID`,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM superstore
GROUP BY `Order ID`
ORDER BY Total_Sales DESC
LIMIT 10;

-- B. Product and Category Analysis
-- Q5. Find total sales and profit for each category.
SELECT
    Category,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM superstore
GROUP BY Category
ORDER BY Total_Sales DESC;

-- Q6. Find the top 10 sub-categories based on profit.
SELECT
    `Sub-Category`,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM superstore
GROUP BY `Sub-Category`
ORDER BY Total_Profit DESC
LIMIT 10;

-- Q7. Find the top 10 products based on sales.
SELECT
    `Product Name`,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM superstore
GROUP BY `Product Name`
ORDER BY Total_Sales DESC
LIMIT 10;

-- Q8. Find the 10 products generating the highest losses.
SELECT
    `Product Name`,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM superstore
GROUP BY `Product Name`
HAVING SUM(Profit) < 0
ORDER BY Total_Profit ASC
LIMIT 10;

-- C. Customer and Regional Analysis
-- Q9. Find the top 10 customers based on total sales.
SELECT
    `Customer ID`,
    `Customer Name`,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM superstore
GROUP BY `Customer ID`, `Customer Name`
ORDER BY Total_Sales DESC
LIMIT 10;

-- Q10. Find total sales and profit for each region.
SELECT
    Region,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM superstore
GROUP BY Region
ORDER BY Total_Sales DESC;

-- Q11. Find the top 10 states based on sales.
SELECT
    State,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM superstore
GROUP BY State
ORDER BY Total_Sales DESC
LIMIT 10;

-- Q12. Compare sales and profit across customer segments.
SELECT
    Segment,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM superstore
GROUP BY Segment
ORDER BY Total_Sales DESC;

-- D. Time-Based Analysis
-- Q13. Find yearly sales and profit.
SELECT
    YEAR(`Order Date`) AS Order_Year,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM superstore
GROUP BY YEAR(`Order Date`)
ORDER BY Order_Year;

-- Q14. Find monthly sales trends for each year.
SELECT
    YEAR(`Order Date`) AS Order_Year,
    MONTH(`Order Date`) AS Order_Month,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM superstore
GROUP BY
    YEAR(`Order Date`),
    MONTH(`Order Date`)
ORDER BY Order_Year, Order_Month;

-- Q15. Find the month and year with the highest sales.
SELECT
    YEAR(`Order Date`) AS Order_Year,
    MONTHNAME(`Order Date`) AS Order_Month,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM superstore
GROUP BY
    YEAR(`Order Date`),
    MONTH(`Order Date`),
    MONTHNAME(`Order Date`)
ORDER BY Total_Sales DESC
LIMIT 1;

-- E. Discount and Shipping Analysis
-- Q16. Find average discount and total profit for each category.
SELECT
    Category,
    ROUND(AVG(Discount) * 100, 2) AS Average_Discount_Percentage,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM superstore
GROUP BY Category;

-- Q17. Analyze the relationship between discount and profit.
SELECT
    Discount,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(AVG(Profit), 2) AS Average_Profit
FROM superstore
GROUP BY Discount
ORDER BY Discount;

-- Q18. Find average shipping days for each shipping mode.
SELECT
    `Ship Mode`,
    ROUND(
        AVG(DATEDIFF(`Ship Date`, `Order Date`)), 2
    ) AS Average_Shipping_Days
FROM superstore
GROUP BY `Ship Mode`
ORDER BY Average_Shipping_Days;

select * from superstore;

-- F. Advanced SQL Analysis
-- Q19. Calculate each region's percentage contribution to total sales.
SELECT
    Region,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(
        SUM(Sales) * 100 /
        (SELECT SUM(Sales) FROM superstore),
        2
    ) AS Sales_Contribution_Percentage
FROM superstore
GROUP BY Region
ORDER BY Total_Sales DESC;

-- Q20. Rank the top 3 profitable sub-categories within each category.
WITH Ranked_Products AS (
    SELECT
        Category,
        `Sub-Category`,
        ROUND(SUM(Profit), 2) AS Total_Profit,
        DENSE_RANK() OVER (
            PARTITION BY Category
            ORDER BY SUM(Profit) DESC
        ) AS Profit_Rank
    FROM superstore
    GROUP BY Category, `Sub-Category`
)
SELECT *
FROM Ranked_Products
WHERE Profit_Rank <= 3
ORDER BY Category, Profit_Rank;