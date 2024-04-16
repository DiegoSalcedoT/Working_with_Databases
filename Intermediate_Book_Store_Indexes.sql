SELECT * FROM customers LIMIT 10;
SELECT * FROM orders LIMIT 10;
SELECT * FROM books LIMIT 10;

SELECT *
FROM pg_Indexes
WHERE tablename IN ('orders', 'books', 'customers');

EXPLAIN ANALYZE 
SELECT *
FROM orders
WHERE quantity > 18;

CREATE INDEX orders_customer_id_quantity ON orders (customer_id, quantity) WHERE quantity > 18;

EXPLAIN ANALYZE 
SELECT *
FROM orders
WHERE quantity > 18;

EXPLAIN ANALYZE 
SELECT *
FROM customers
WHERE customer_id < 200;

ALTER TABLE customers
ADD CONSTRAINT customers_pkey
PRIMARY KEY (customer_id);

EXPLAIN ANALYZE 
SELECT *
FROM customers
WHERE customer_id < 200;

CLUSTER customers USING customers_pkey;
SELECT * FROM customers LIMIT 10;

CREATE INDEX orders_customer_id_book_id_idx ON orders (customer_id, book_id);

DROP INDEX orders_customer_id_book_id_idx;

EXPLAIN ANALYZE 
SELECT customer_id, book_id, quantity
FROM orders
WHERE customer_id < 200;

CREATE INDEX orders_customer_id_book_id_quantity_idx ON orders (customer_id, book_id, quantity);

EXPLAIN ANALYZE 
SELECT customer_id, book_id, quantity
FROM orders
WHERE customer_id < 200;

CREATE INDEX books_author_title_idx ON books (author, title);

EXPLAIN ANALYZE 
SELECT *
FROM orders
WHERE quantity * price_base > 100;

CREATE INDEX orders_total_price_idx ON orders ((quantity * price_base));

EXPLAIN ANALYZE 
SELECT *
FROM orders
WHERE quantity * price_base > 100;

DROP INDEX IF EXISTS books_author_idx;

DROP INDEX IF EXISTS orders_customer_id_quantity;

CREATE INDEX customers_last_name_first_name_email_address ON customers (last_name, first_name, email_address);

-----------------------------------

SELECT *
FROM pg_Indexes
WHERE tablename IN ('orders', 'books', 'customers')
ORDER BY tablename, indexname; 
