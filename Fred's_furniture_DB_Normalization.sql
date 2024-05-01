-- First inspection of the table
SELECT *
FROM store
LIMIT 10
;

-- Distinct orders
SELECT COUNT(DISTINCT(order_id)) AS Num_orders
FROM store;

-- Dictinct customers
SELECT COUNT(DISTINCT(customer_id)) AS Num_customers
FROM store;

-- Orders of customer 1
SELECT customer_id, customer_email, customer_phone
FROM store
WHERE customer_id = 1;

--Order with item 4
SELECT item_1_id, item_1_name, item_1_price
FROM store
WHERE item_1_id = 4;

--              Normalization
-- customers table
CREATE TABLE customers AS
SELECT DISTINCT customer_id, customer_phone, customer_email
FROM store;

-- Designation of PK for customers table
ALTER TABLE customers
ADD PRIMARY KEY (customer_id);

-- items table
CREATE TABLE items AS
SELECT DISTINCT item_1_id AS item_id, item_1_name AS name, item_1_price AS price
FROM store
UNION 
SELECT DISTINCT item_2_id, item_2_name, item_2_price
FROM store
WHERE item_2_id IS NOT NULL
UNION 
SELECT DISTINCT item_3_id, item_3_name, item_3_price
FROM store
WHERE item_3_id IS NOT NULL;

-- Designation of PK for items table
ALTER TABLE items
ADD PRIMARY KEY (item_id);

-- orders_items table
CREATE TABLE orders_items AS
SELECT DISTINCT order_id, item_1_id AS item_id
FROM store
UNION
SELECT order_id, item_2_id
FROM store
WHERE item_2_id IS NOT NULL
UNION
SELECT order_id, item_3_id
FROM store
WHERE item_3_id IS NOT NULL;

--
CREATE TABLE orders AS
SELECT order_id, order_date, customer_id
FROM store;

-- Designation of PK for orders table
ALTER TABLE orders
ADD PRIMARY KEY (order_id);

-- Designation of Foreign Keys
ALTER TABLE orders
ADD FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

ALTER TABLE orders_items
ADD FOREIGN KEY (item_id) REFERENCES items(item_id);

ALTER TABLE orders_items
ADD FOREIGN KEY (order_id) REFERENCES orders(order_id);

--              Queries
-- Emails of customers who made an order after July 25, 2019
-- Old database
SELECT customer_email, order_date
FROM store
WHERE order_date > '2019-08-25'
ORDER BY order_date;

-- New database (Normalized)
SELECT customer_email, order_date
FROM customers, orders
WHERE orders.customer_id = customers.customer_id AND order_date > '2019-08-25'
ORDER BY order_date;

-- Most sold items
-- Old database
WITH all_items AS
(SELECT order_id, item_1_id AS item_id
FROM store
UNION
SELECT order_id, item_2_id
FROM store
WHERE item_2_id IS NOT NULL
UNION
SELECT order_id, item_3_id
FROM store
WHERE item_3_id IS NOT NULL
)

SELECT item_id, COUNT(*) AS num_orders
FROM all_items
GROUP BY item_id
ORDER BY num_orders DESC, item_id
LIMIT 15;

-- New database (Normalized)
SELECT item_id, COUNT(*) AS num_orders
FROM orders_items
GROUP BY item_id
ORDER BY num_orders DESC, item_id
LIMIT 15;

-- Final queries
-- How many customers made more than one order? What are their emails?
SELECT customer_email, COUNT(*)
FROM orders, customers
WHERE orders.customer_id = customers.customer_id
GROUP BY customer_email
HAVING COUNT(*) > 1;

-- Among orders that were made after August 15, 2019, how many included a 'lamp'?
SELECT COUNT(*) AS Lamps_after_Aug_15
FROM orders_items, items, orders
WHERE orders_items.item_id = items.item_id AND orders_items.order_id = orders.order_id AND name = 'lamp' AND order_date > '2019-08-15';

-- How many orders included a 'chair'?
SELECT COUNT(*) AS chair_orders
FROM orders_items, items
WHERE orders_items.item_id = items.item_id AND name = 'chair';

