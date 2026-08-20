USE Chocolate_sales;
GO

SELECT *
FROM Chocolate_Sales;

-- 1. Shows all Chocolate Sales data
SELECT *
FROM Chocolate_Sales;

-- 2. Shows only important columns like Order ID, Product, Country, Amount
SELECT 
    Order_ID,
    Product,
    Country,
    Amount
FROM Chocolate_Sales;

-- 3. Shows sales from a specific country
SELECT *
FROM Chocolate_Sales
WHERE Country = 'Australia';

-- 4. Finds high/low-value orders based on Amount
SELECT *
FROM Chocolate_Sales
WHERE Amount > 1000;

/* ALSO USE 
WHERE Amount >= 1000
WHERE Amount < 1000
WHERE Amount <= 1000
WHERE Amount <> 1000*/

-- 5. AND / OR – Finds data that matches multiple conditions.
SELECT *
FROM Chocolate_Sales
WHERE Country = 'Australia'
  AND Amount > 1000;

SELECT * 
FROM Chocolate_Sales
WHERE country =  'Brazil'
OR Amount < 1000;

-- 6. ORDER BY / TOP – Finds the highest or lowest sales and Top 10 orders.
SELECT Product, Amount
FROM Chocolate_Sales
ORDER BY Amount DESC;
   -- TOP TO
SELECT TOP 10 *
FROM Chocolate_Sales
ORDER BY Amount DESC;   

-- 7. DISTINCT – Shows unique countries, products, or sales channels.
SELECT DISTINCT Country
FROM Chocolate_Sales;
   --ALSO CHECCH CHANNALS
SELECT DISTINCT Channel
FROM Chocolate_Sales;

/* 8. Aggregate Functions – Gives Total Sales, Average Sales, Minimum Sale, Maximum
Sale, and Total Orders.*/
SELECT
    SUM(Amount) AS Total_Sales,
    AVG(Amount) AS Average_Sales,
    MIN(Amount) AS Minimum_Sale,
    MAX(Amount) AS Maximum_Sale,
    COUNT(*) AS Total_Orders
FROM Chocolate_Sales;

-- 9. GROUP BY Country – Shows total sales for each country.
SELECT
    Country,
    SUM(Amount) AS Total_Sales
FROM Chocolate_Sales
GROUP BY Country
ORDER BY Total_Sales DESC;

-- 10. HAVING – Finds countries whose total sales are above a specific amount.
SELECT
    Country,
    SUM(Amount) AS Total_Sales
FROM Chocolate_Sales
GROUP BY Country
HAVING SUM(Amount) > 10000000
ORDER BY Total_Sales DESC;

/* 11. GROUP BY Product – Shows total sales for each product and identifies 
best-selling products.*/
SELECT
    Product,
    SUM(Amount) AS Total_Sales
FROM Chocolate_Sales
GROUP BY Product
ORDER BY Total_Sales DESC;

/* 12. GROUP BY Channel – Shows sales performance of Retail, Wholesale, 
and Online channels.*/
SELECT
    Channel,
    SUM(Amount) AS Total_Sales
FROM Chocolate_Sales
GROUP BY Channel
ORDER BY Total_Sales DESC;

/*13. GROUP BY Salesperson – Shows total sales and total orders handled by 
each salesperson.*/
SELECT
    Salesperson,
    SUM(Amount) AS Total_Sales,
    COUNT(*) AS Total_Orders
FROM Chocolate_Sales
GROUP BY Salesperson
ORDER BY Total_Sales DESC;

-- 14. Monthly Sales – Shows total sales for each month.
SELECT
    MONTH(Order_Date) AS Sales_Month,
    SUM(Amount) AS Total_Sales
FROM Chocolate_Sales
GROUP BY MONTH(Order_Date)
ORDER BY Sales_Month;

-- 15. Year and Month Analysis – Shows sales performance by year and month.
SELECT
    YEAR(Order_Date) AS Sales_Year,
    MONTH(Order_Date) AS Sales_Month,
    SUM(Amount) AS Total_Sales
FROM Chocolate_Sales
GROUP BY 
    YEAR(Order_Date),
    MONTH(Order_Date)
ORDER BY 
    Sales_Year,
    Sales_Month;

-- 16. CASE – Classifies orders into High Value, Medium Value, and Low Value.
SELECT
    Order_ID,
    Amount,
    CASE
        WHEN Amount >= 1000 THEN 'High Value'
        WHEN Amount >= 500 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS Order_Category
FROM Chocolate_Sales;

-- 17. Subquery – Finds products whose sales are above the average product sales.
SELECT
    Product,
    SUM(Amount) AS Total_Sales
FROM Chocolate_Sales
GROUP BY Product
HAVING SUM(Amount) >
(
    SELECT AVG(Product_Sales)
    FROM
    (
        SELECT SUM(Amount) AS Product_Sales
        FROM Chocolate_Sales
        GROUP BY Product
    ) AS ProductData
)
ORDER BY Total_Sales DESC;

-- 18. RANK() – Ranks salespersons from highest to lowest based on total sales.
SELECT
    Salesperson,
    SUM(Amount) AS Total_Sales,
    RANK() OVER (
        ORDER BY SUM(Amount) DESC
    ) AS Sales_Rank
FROM Chocolate_Sales
GROUP BY Salesperson;

-- 19. CTE + RANK() – Finds the Top 3 products in each country.
WITH ProductSales AS
(
    SELECT Country,Product,SUM(Amount) AS Total_Sales
    FROM Chocolate_Sales
    GROUP BY Country, Product
),
RankedProducts AS
(
    SELECT Country, Product, Total_Sales,
        RANK() OVER
        (
            PARTITION BY Country
            ORDER BY Total_Sales DESC
        ) AS Product_Rank
    FROM ProductSales
)
SELECT Country, Product, Total_Sales, Product_Rank
FROM RankedProducts
WHERE Product_Rank <= 3
ORDER BY Country, Product_Rank;

/* 20. Business Summary – Gives important KPIs such as Total Orders, 
Total Sales, Total Boxes Shipped, Average Order Value, Average Discount,
and Average Marketing Spend. */
SELECT
    COUNT(*) AS Total_Orders,
    SUM(Amount) AS Total_Sales,
    SUM(Boxes_Shipped) AS Total_Boxes_Shipped,
    AVG(Amount) AS Average_Order_Value,
    AVG(Discount_Pct) AS Average_Discount,
    AVG(Marketing_Spend) AS Average_Marketing_Spend
FROM Chocolate_Sales;