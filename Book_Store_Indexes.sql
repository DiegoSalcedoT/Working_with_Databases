-- Exploration of the tables
SELECT * FROM customers LIMIT 10;
SELECT * FROM orders LIMIT 10;
SELECT * FROM books LIMIT 10;

-- Exploration of indexes from each table
SELECT * FROM pg_indexes WHERE tablename = 'customers';
SELECT * FROM pg_indexes WHERE tablename = 'orders';
SELECT * FROM pg_indexes WHERE tablename = 'books';

-- First indexes creation
CREATE INDEX orders_customer_id ON orders (customer_id);
CREATE INDEX orders_book_id ON orders (book_id);

-- Query analysis (before index creation)
EXPLAIN ANALYZE
SELECT original_language, title, sales_in_millions
FROM books
WHERE original_language = 'French';

-- books table's size (before index creation)
SELECT pg_size_pretty (pg_total_relation_size('books'));

-- Multicolumn index creation to find books
CREATE INDEX books_original_language_title_sales_in_millions_idx
ON books (original_language, title, sales_in_millions);

-- Query analysis (after index creation)
EXPLAIN ANALYZE
SELECT original_language, title, sales_in_millions
FROM books
WHERE original_language = 'French';

-- books table's size (after index creation)
SELECT pg_size_pretty (pg_total_relation_size('books'));

-- Dropping of unefficient index
DROP INDEX books_original_language_title_sales_in_millions_idx;

SELECT NOW();
-- DROP orders' indexes
DROP INDEX orders_customer_id;
DROP INDEX orders_book_id;

-- Addition of new orders
SELECT NOW(); -- timestapm (before)

\COPY orders FROM 'orders_add.txt' DELIMITER ',' CSV HEADER;

SELECT NOW(); -- timestapm (after)

-- Indexes recreation
CREATE INDEX orders_customer_id ON orders (customer_id);
CREATE INDEX orders_book_id ON orders (book_id);

-- size before customers_idx
SELECT pg_size_pretty (pg_total_relation_size('customers'));

-- customers table's index
CREATE INDEX customers_first_name_email_address_idx ON customers (first_name, email_address);

-- size after customers_idx
SELECT pg_size_pretty (pg_total_relation_size('customers'));

-- Check of indexes
SELECT * FROM pg_indexes WHERE tablename = 'customers';
SELECT * FROM pg_indexes WHERE tablename = 'orders';
SELECT * FROM pg_indexes WHERE tablename = 'books';











