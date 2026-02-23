/*
    Advanced SQL Assignment
    Student Submission
*/

-- SETUP (Dataset creation)
CREATE DATABASE IF NOT EXISTS AdvancedSQLAssignment;
USE AdvancedSQLAssignment;

DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS ProductArchive;
DROP VIEW IF EXISTS vw_CategorySummary;
DROP VIEW IF EXISTS vw_ProductPriceUpdate;
DROP PROCEDURE IF EXISTS GetProductsByCategory;

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

INSERT INTO Products VALUES
(1, 'Keyboard', 'Electronics', 1200),
(2, 'Mouse', 'Electronics', 800),
(3, 'Chair', 'Furniture', 2500),
(4, 'Desk', 'Furniture', 5500);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    SaleDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products (ProductID)
);

INSERT INTO Sales VALUES
(1, 1, 4, '2024-01-05'),
(2, 2, 10, '2024-01-06'),
(3, 3, 2, '2024-01-10'),
(4, 4, 1, '2024-01-11');

-- THEORETICAL ANSWERS

/*
Q1. What is a Common Table Expression (CTE), and how does it improve SQL query readability?
Answer: A CTE is a named temporary result set that exists only during the query execution. It improves readability by breaking down complex logic into linear, named steps, avoiding messy nested subqueries.

Q2. Why are some views updatable while others are read-only? Explain with an example.
Answer: A view is updatable if it has a direct 1-to-1 mapping to the underlying table rows. It becomes read-only if it uses aggregates (SUM, COUNT), DISTINCT, or GROUP BY, because the DB can't map a single view row back to a specific table row.
Example: `SELECT ID, Name FROM Users` is updatable. `SELECT Count(*) FROM Users` is read-only.

Q3. What advantages do stored procedures offer compared to writing raw SQL queries repeatedly?
Answer: They offer better performance (pre-compiled/cached), security (prevents SQL injection), and maintainability (logic is central, not scattered in app code).

Q4. What is the purpose of triggers in a database? Mention one use case where a trigger is essential.
Answer: Triggers automatically run code in response to INSERT/UPDATE/DELETE events. An essential use case is "Audit Logging"—automatically saving old values to a history table when a record is changed.

Q5. Explain the need for data modelling and normalization when designing a database.
Answer: Data modelling ensures the database structure actually fits the business needs. Normalization is required to eliminate duplicate data (redundancy) and prevent anomalies during updates or insertions.
*/

-- PRACTICAL ANSWERS

-- Q6. CTE for total revenue per product, filtering for revenue > 3000
WITH ProductRevenue_CTE AS (
    SELECT 
        P.ProductName, 
        P.Category, 
        (P.Price * S.Quantity) AS TotalRevenue
    FROM Products P
    JOIN Sales S ON P.ProductID = S.ProductID
)
SELECT * FROM ProductRevenue_CTE
WHERE TotalRevenue > 3000;


-- Q7. View vw_CategorySummary (Category, TotalProducts, AveragePrice)
CREATE VIEW vw_CategorySummary AS
SELECT 
    Category, 
    COUNT(ProductID) AS TotalProducts, 
    AVG(Price) AS AveragePrice
FROM Products
GROUP BY Category;

-- Select to verify
SELECT * FROM vw_CategorySummary;


-- Q8. Updatable view for ProductID, ProductName, Price. Update ID 1.
CREATE VIEW vw_ProductPriceUpdate AS
SELECT ProductID, ProductName, Price
FROM Products;

UPDATE vw_ProductPriceUpdate
SET Price = 1300
WHERE ProductID = 1;


-- Q9. Stored Procedure to get products by category
DELIMITER //
CREATE PROCEDURE GetProductsByCategory(IN categoryInput VARCHAR(50))
BEGIN
    SELECT * FROM Products 
    WHERE Category = categoryInput;
END //
DELIMITER ;

-- Calling the procedure
CALL GetProductsByCategory('Electronics');


-- Q10. AFTER DELETE trigger to archive deleted products
CREATE TABLE ProductArchive (
    ArchiveID INT AUTO_INCREMENT PRIMARY KEY,
    ProductID INT,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    DeletedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER trg_AfterDeleteProduct
AFTER DELETE ON Products
FOR EACH ROW
BEGIN
    INSERT INTO ProductArchive (ProductID, ProductName, Category, Price)
    VALUES (OLD.ProductID, OLD.ProductName, OLD.Category, OLD.Price);
END //
DELIMITER ;