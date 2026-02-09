Create database P;
use p;

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    City VARCHAR(50)
);
Select * From customers;


INSERT INTO Customers VALUES
(1, 'John Smith', 'New York'),
(2, 'Mary Johnson', 'Chicago'),
(3, 'Peter Adams', 'Los Angeles'),
(4, 'Robert White', 'Houston'),
(5, 'Nancy Miller', 'Miami');

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    Amount INT
);

Select * From customers;

INSERT INTO Orders VALUES
(101, 1, '2024-10-01', 250),
(102, 2, '2024-10-05', 300),
(103, 1, '2024-10-07', 150),
(104, 3, '2024-10-10', 450),
(105, 6, '2024-10-12', 400);

CREATE TABLE Payments (
    PaymentID VARCHAR(10) PRIMARY KEY,
    CustomerID INT,
    PaymentDate DATE,
    Amount INT
);
## Que.1 Retrieve all customers who have placed at least one order
SELECT DISTINCT c.CustomerID, c.CustomerName
FROM Customers c
INNER JOIN Orders o
ON c.CustomerID = o.CustomerID;

## Que.2 Retrieve all customers and their orders, including customers with no orders
SELECT c.CustomerID, c.CustomerName, o.OrderID, o.Amount
FROM Customers c
LEFT JOIN Orders o
ON c.CustomerID = o.CustomerID;

## Que.3 Retrieve all orders and their corresponding customers, including unknown customers
SELECT c.CustomerName, o.OrderID, o.Amount
FROM Customers c
RIGHT JOIN Orders o
ON c.CustomerID = o.CustomerID;

##Que.4 Display all customers and orders, whether matched or not
SELECT c.CustomerID, c.CustomerName, o.OrderID
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID

UNION

SELECT c.CustomerID, c.CustomerName, o.OrderID
FROM Customers c
RIGHT JOIN Orders o ON c.CustomerID = o.CustomerID;

## Que.5 Find customers who have not placed any orders
SELECT c.CustomerID, c.CustomerName
FROM Customers c
LEFT JOIN Orders o
ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

## Que.6 Retrieve customers who made payments but did not place any orders
SELECT c.CustomerID, c.CustomerName
FROM Customers c
INNER JOIN Payments p ON c.CustomerID = p.CustomerID
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

## Que.7 Generate all possible combinations between Customers and Orders
SELECT c.CustomerName, o.OrderID
FROM Customers c
CROSS JOIN Orders o;

## Que.8 Show all customers with order and payment amounts
SELECT c.CustomerName,
       o.Amount AS OrderAmount,
       p.Amount AS PaymentAmount
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
LEFT JOIN Payments p ON c.CustomerID = p.CustomerID;

## Que.9 Retrieve customers who placed orders AND made payments
SELECT DISTINCT c.CustomerID, c.CustomerName
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN Payments p ON c.CustomerID = p.CustomerID;







