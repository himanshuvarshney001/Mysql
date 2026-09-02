-- LEFT JOIN
--  if returns all records from the left table and only the matching records from the right table.
-- if no match exist in the right table, NULL values will be returns from the right tables's columns

CREATE DATABASE left_join_tutorial;
use left_join_tutorial;

-- Basic LEFT JOIN syntax
/*
SELECT columns
FROM table1
LEFT JOIN table2
ON table1.column = table2.column;
*/

-- Create customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    city VARCHAR(50)
);


-- Create orders table with foreign key
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

show tables;

-- Insert sample customer data
INSERT INTO customers (customer_id, customer_name, email, city)
VALUES 
    (1, 'John Smith', 'john@example.com', 'New York'),
    (2, 'Jane Doe', 'jane@example.com', 'Los Angeles'),
    (3, 'Robert Johnson', 'robert@example.com', 'Chicago'),
    (4, 'Emily Davis', 'emily@example.com', 'Houston'),
    (5, 'Michael Brown', 'michael@example.com', 'Phoenix');

-- Insert sample order data
INSERT INTO orders (order_id, customer_id, order_date, total_amount)
VALUES 
    (101, 1, '2023-01-15', 150.75),
    (102, 3, '2023-01-16', 89.50),
    (103, 1, '2023-01-20', 45.25),
    (104, 2, '2023-01-25', 210.30),
    (105, 3, '2023-02-01', 75.00);

-- Give all data    
SELECT *FROM customers
LEFT JOIN orders
on customers.customer_id=orders.customer_id;

-- Give selected columns
SELECT c.customer_id,c.customer_name,c.email,c.city,o.order_date,o.total_amount
FROM customers c
LEFT JOIN orders o
ON c.customer_id=o.customer_id;

-- Filtering data
SELECT c.customer_id,c.customer_name,c.email,c.city,o.order_date,o.total_amount
FROM customers c
LEFT JOIN orders o
ON c.customer_id=o.customer_id
where o.order_id is null;

-- total order by custumer each
SELECT c.customer_id,c.customer_name,c.email,c.city,IFNULL(sum(o.total_amount),0) as total_spent,count(o.order_id) as order_count
FROM customers c
LEFT JOIN orders o
ON c.customer_id=o.customer_id
group by c.customer_id;

-- Create shipping table for multiple joins example
CREATE TABLE shipping (
    shipping_id INT PRIMARY KEY,
    order_id INT,
    shipping_date DATE,
    carrier VARCHAR(50),
    tracking_number VARCHAR(50),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Insert sample shipping data
INSERT INTO shipping (shipping_id, order_id, shipping_date, carrier, tracking_number)
VALUES 
    (1001, 101, '2023-01-16', 'FedEx', 'FDX123456789'),
    (1002, 104, '2023-01-26', 'UPS', 'UPS987654321'),
    (1003, 105, '2023-02-02', 'USPS', 'USPS456789123');

-- Get customers, their orders, and shipping information
SELECT 
	c.customer_name,
    o.order_id,
    o.order_date,
    o.total_amount,
    s.carrier,
    s.tracking_number
FROM customers c
LEFT JOIN orders o
on c.customer_id=o.customer_id
LEFT JOIN shipping s
ON
o.order_id=s.order_id;

-- Analysis New york customers and their order history
-- this is good but not optimize 
SELECT 
	c.customer_name,
    o.order_id,
    o.order_date,
    o.total_amount
FROM customers c
LEFT JOIN orders o
on c.customer_id=o.customer_id
where c.city="New York";

-- Optimize query 
SELECT 
	c.customer_name,
    o.order_id,
    o.order_date,
    o.total_amount
FROM 
	(SELECT * From customers where city= "New York") c
LEFT JOIN orders o
on c.customer_id=o.customer_id
where c.city="New York";

-- Find customers who haven't ordered in the past 30 days
-- Have never placed an order, or
-- have placed orders, but more within the last 30 days

SELECT 
	c.customer_name
FROM customers c
LEFT JOIN orders o
on c.customer_id=o.customer_id
where day((curdate())-day(o.order_date)>30;



