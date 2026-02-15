CREATE DATABASE pwskills_subqueries;
USE pwskills_subqueries;

## Employee Table 

CREATE TABLE employee (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    department_id VARCHAR(5),
    salary INT
);

## Insert Data

INSERT INTO employee VALUES
(101, 'Abhishek', 'D01', 62000),
(102, 'Shubham', 'D01', 58000),
(103, 'Priya', 'D02', 67000),
(104, 'Rohit', 'D02', 64000),
(105, 'Neha', 'D03', 72000),
(106, 'Aman', 'D03', 55000),
(107, 'Ravi', 'D04', 60000),
(108, 'Sneha', 'D04', 75000),
(109, 'Kiran', 'D05', 70000),
(110, 'Tanuja', 'D05', 65000);

## Department Table 

CREATE TABLE department (
    department_id VARCHAR(5) PRIMARY KEY,
    department_name VARCHAR(50),
    location VARCHAR(50)
);
 
 ## Sales Table 
 
 CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    emp_id INT,
    sale_amount INT,
    sale_date DATE,
    FOREIGN KEY (emp_id) REFERENCES employee(emp_id)
);

## Insert Table 

INSERT INTO sales VALUES
(201, 101, 4500, '2025-01-05'),
(202, 102, 7800, '2025-01-10'),
(203, 103, 6700, '2025-01-14'),
(204, 104, 12000, '2025-01-20'),
(205, 105, 9800, '2025-02-02'),
(206, 106, 10500, '2025-02-05'),
(207, 107, 3200, '2025-02-09'),
(208, 108, 5100, '2025-02-15'),
(209, 109, 3900, '2025-02-20'),
(210, 110, 7200, '2025-03-01');

## Verify Tables

SELECT * FROM employee;
SELECT * FROM department;
SELECT * FROM sales;

## Ques 1. Retrieve the names of employees who earn more than the average salary of all employees. */
SELECT name
FROM employee
WHERE salary > (SELECT AVG(salary) FROM employee);

## Ques2. Find the employees who belong to the department with the highest average salary.*/
SELECT name
FROM employee
WHERE department_id = (
    SELECT department_id
    FROM employee
    GROUP BY department_id
    ORDER BY AVG(salary) DESC
    LIMIT 1
);

## Ques3. List all employees who have made at least one sale.*/
SELECT name
FROM employee
WHERE emp_id IN (SELECT DISTINCT emp_id FROM sales);

## Ques4. Find the employee with the highest sale amount.*/
SELECT employee.name
FROM employee
JOIN sales ON employee.emp_id = sales.emp_id
ORDER BY sales.sale_amount DESC
LIMIT 1;

## Ques5. Retrieve the names of employees whose salaries are higher than Shubham’s salary.*/
SELECT name
FROM employee
WHERE salary > (SELECT salary FROM employee WHERE name = 'Shubham');


-- Intermediate Level Queries

## Ques6. Find employees who work in the same department as Abhishek.*/
SELECT name
FROM employee
WHERE department_id = (
    SELECT department_id
    FROM employee
    WHERE name = 'Abhishek'
)
AND name != 'Abhishek';

## Ques7. List departments that have at least one employee earning more than ₹60,000.*/
SELECT DISTINCT department.department_name
FROM department
JOIN employee ON department.department_id = employee.department_id
WHERE employee.salary > 60000;
 
## Ques8. Find the department name of the employee who made the highest sale.*/
SELECT department_name
FROM department
WHERE department_id = (
    SELECT department_id
    FROM employee
    WHERE emp_id = (
        SELECT emp_id
        FROM sales
        ORDER BY sale_amount DESC
        LIMIT 1
    )
);

## Ques9. Retrieve employees who have made sales greater than the average sale amount.*/
SELECT DISTINCT employee.name
FROM employee 
JOIN sales ON employee.emp_id = sales.emp_id
WHERE sales.sale_amount > (SELECT AVG(sale_amount) FROM sales);

## Ques10. Find the total sales made by employees who earn more than the average salary.*/
SELECT SUM(sale_amount) AS total_sales
FROM sales
WHERE emp_id IN (
    SELECT emp_id FROM employee
    WHERE salary > (SELECT AVG(salary) FROM employee)
);

-- Advanced Level
## Ques11. Find employees who have not made any sales.*/
SELECT name
FROM employee
WHERE emp_id NOT IN (SELECT DISTINCT emp_id FROM sales);

## Ques.12 List departments where the average salary is above ₹55,000.*/
SELECT department.department_name
FROM department
JOIN employee ON department.department_id = employee.department_id
GROUP BY department.department_name
HAVING AVG(employee.salary) > 55000;
 
## Ques13. Retrieve department names where the total sales exceed ₹10,000.*/
SELECT department.department_name
FROM department
JOIN employee ON department.department_id = employee.department_id
JOIN sales ON employee.emp_id = sales.emp_id
GROUP BY department.department_name
HAVING SUM(sales.sale_amount) > 10000;

## Ques14. Find the employee who has made the second-highest sale.*/
SELECT employee.name
FROM employee
JOIN sales ON employee.emp_id = sales.emp_id
ORDER BY sales.sale_amount DESC
LIMIT 1 OFFSET 1;

## Ques15 Retrieve the names of employees whose salary is greater than the highest sale amount recorded.*/
SELECT name
FROM employee
WHERE salary > (SELECT MAX(sale_amount) FROM sales);