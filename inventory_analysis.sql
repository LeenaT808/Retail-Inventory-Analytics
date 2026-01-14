CREATE DATABASE retail_inventory;
USE retail_inventory;
CREATE TABLE products (
 product_id INT PRIMARY KEY,
 product_name VARCHAR(100),
 category VARCHAR(50),
 cost_price DECIMAL(10,2),
 selling_price DECIMAL(10,2)
);

CREATE TABLE stores (
 store_id INT PRIMARY KEY,
 store_name VARCHAR(50),
 city VARCHAR(50)
);

CREATE TABLE inventory (
 inventory_id INT PRIMARY KEY,
 product_id INT,
 store_id INT,
 stock_quantity INT,
 reorder_level INT,
 last_updated DATE
);

CREATE TABLE sales (
 sale_id INT PRIMARY KEY,
 product_id INT,
 store_id INT,
 sale_date DATE,
 quantity_sold INT
);
INSERT INTO products VALUES
(101,'Rice 5kg','Grocery',250,320),
(102,'Sugar 1kg','Grocery',35,45),
(103,'Shampoo','Personal Care',120,180),
(104,'Soap','Personal Care',25,40),
(105,'Biscuit','Snacks',20,30);

INSERT INTO stores VALUES
(1,'Store Delhi','Delhi'),
(2,'Store Mumbai','Mumbai'),
(3,'Store Bangalore','Bangalore');

INSERT INTO inventory VALUES
(1,101,1,120,50,'2025-12-01'),
(2,102,1,30,40,'2025-12-01'),
(3,103,2,15,25,'2025-12-01'),
(4,104,3,200,60,'2025-12-01'),
(5,105,2,300,80,'2025-12-01');

INSERT INTO sales VALUES
(1,101,1,'2025-11-20',20),
(2,101,1,'2025-11-21',25),
(3,102,1,'2025-11-22',10),
(4,103,2,'2025-11-23',8),
(5,104,3,'2025-11-24',5),
(6,105,2,'2025-11-25',12);
-- Low Stock Alert
SELECT p.product_name, s.store_name,
       i.stock_quantity, i.reorder_level
FROM inventory i
JOIN products p ON i.product_id = p.product_id
JOIN stores s ON i.store_id = s.store_id
WHERE i.stock_quantity < i.reorder_level;
-- Slow Moving Products
SELECT p.product_name,
       SUM(sa.quantity_sold) AS total_sold
FROM sales sa
JOIN products p ON sa.product_id = p.product_id
GROUP BY p.product_name
HAVING SUM(sa.quantity_sold) < 20;
-- Inventory Turnover
SELECT p.product_name,
 ROUND(SUM(sa.quantity_sold)/AVG(i.stock_quantity),2)
 AS inventory_turnover
FROM sales sa
JOIN inventory i ON sa.product_id = i.product_id
JOIN products p ON p.product_id = sa.product_id
GROUP BY p.product_name;
-- Store-wise Revenue
SELECT st.store_name,
 SUM(sa.quantity_sold * p.selling_price) AS revenue
FROM sales sa
JOIN products p ON sa.product_id = p.product_id
JOIN stores st ON sa.store_id = st.store_id
GROUP BY st.store_name;






