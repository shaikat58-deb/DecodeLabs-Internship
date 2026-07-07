-- ============================================================
-- DecodeLabs Data Analytics Internship
-- Project 3: SQL Data Analysis
-- Dataset: Dataset_for_Data_Analytics.xlsx  (table: Orders)
-- ============================================================

-- Table schema used for this analysis
CREATE TABLE Orders (
    OrderID          TEXT,
    OrderDate        DATE,
    CustomerID       TEXT,
    Product          TEXT,
    Quantity         INTEGER,
    UnitPrice        REAL,
    ShippingAddress  TEXT,
    PaymentMethod    TEXT,
    OrderStatus      TEXT,
    TrackingNumber   TEXT,
    ItemsInCart      INTEGER,
    CouponCode       TEXT,
    ReferralSource   TEXT,
    TotalPrice       REAL
);

-- Q1: Total number of orders and revenue by Product
SELECT Product,
       COUNT(*) AS TotalOrders,
       SUM(TotalPrice) AS TotalRevenue,
       ROUND(AVG(TotalPrice),2) AS AvgOrderValue
FROM Orders
GROUP BY Product
ORDER BY TotalRevenue DESC;

-- Q2: Order count and revenue by OrderStatus
SELECT OrderStatus,
       COUNT(*) AS NumOrders,
       SUM(TotalPrice) AS Revenue,
       ROUND(AVG(TotalPrice),2) AS AvgValue
FROM Orders
GROUP BY OrderStatus
ORDER BY NumOrders DESC;

-- Q3: Revenue and order count by PaymentMethod
SELECT PaymentMethod,
       COUNT(*) AS NumOrders,
       SUM(TotalPrice) AS Revenue
FROM Orders
GROUP BY PaymentMethod
ORDER BY Revenue DESC;

-- Q4: All Cancelled orders paid via Credit Card, sorted by highest value
SELECT OrderID, Product, Quantity, TotalPrice, PaymentMethod, OrderStatus
FROM Orders
WHERE OrderStatus = 'Cancelled' AND PaymentMethod = 'Credit Card'
ORDER BY TotalPrice DESC;

-- Q5: High value orders (TotalPrice > 2000) placed in 2024
SELECT OrderID, OrderDate, Product, TotalPrice
FROM Orders
WHERE TotalPrice > 2000 AND OrderDate LIKE '2024%'
ORDER BY TotalPrice DESC;

-- Q6: Orders shipped to addresses starting with '9' on Main St (LIKE pattern matching)
SELECT OrderID, ShippingAddress, ItemsInCart, OrderStatus
FROM Orders
WHERE ShippingAddress LIKE '9%Main St'
ORDER BY ItemsInCart DESC
LIMIT 15;

-- Q7: Revenue by ReferralSource, only sources driving > 50000 in total revenue
SELECT ReferralSource,
       COUNT(*) AS NumOrders,
       SUM(TotalPrice) AS Revenue
FROM Orders
GROUP BY ReferralSource
HAVING SUM(TotalPrice) > 50000
ORDER BY Revenue DESC;

-- Q8: Products with average order value greater than 1050 (HAVING on aggregate)
SELECT Product,
       COUNT(*) AS NumOrders,
       ROUND(AVG(TotalPrice),2) AS AvgOrderValue
FROM Orders
GROUP BY Product
HAVING AVG(TotalPrice) > 1050
ORDER BY AvgOrderValue DESC;

-- Q9: Top 10 customers by total spend
SELECT CustomerID,
       COUNT(*) AS NumOrders,
       SUM(TotalPrice) AS TotalSpend
FROM Orders
GROUP BY CustomerID
ORDER BY TotalSpend DESC
LIMIT 10;

-- Q10: Coupon usage - orders and revenue with vs without coupon
SELECT COALESCE(CouponCode,'No Coupon') AS Coupon,
       COUNT(*) AS NumOrders,
       SUM(TotalPrice) AS Revenue,
       ROUND(AVG(TotalPrice),2) AS AvgOrderValue
FROM Orders
GROUP BY Coupon
ORDER BY Revenue DESC;

-- Q11: Monthly order volume and revenue trend
SELECT SUBSTR(OrderDate,1,7) AS OrderMonth,
       COUNT(*) AS NumOrders,
       SUM(TotalPrice) AS Revenue
FROM Orders
GROUP BY OrderMonth
ORDER BY OrderMonth;

-- Q12: Returned or Cancelled orders count and lost revenue by Product
SELECT Product,
       COUNT(*) AS ReturnedOrCancelled,
       SUM(TotalPrice) AS LostRevenue
FROM Orders
WHERE OrderStatus IN ('Returned','Cancelled')
GROUP BY Product
ORDER BY LostRevenue DESC;

-- Q13: Percentage revenue contribution of each Product to total revenue
SELECT Product,
       SUM(TotalPrice) AS Revenue,
       ROUND(100.0 * SUM(TotalPrice) / (SELECT SUM(TotalPrice) FROM Orders), 2) AS PctOfTotalRevenue
FROM Orders
GROUP BY Product
ORDER BY PctOfTotalRevenue DESC;

-- Q14: Overall summary aggregates (single-row KPI query)
SELECT COUNT(*) AS TotalOrders,
       COUNT(DISTINCT CustomerID) AS UniqueCustomers,
       SUM(TotalPrice) AS TotalRevenue,
       ROUND(AVG(TotalPrice),2) AS AvgOrderValue,
       SUM(Quantity) AS TotalUnitsSold
FROM Orders;
