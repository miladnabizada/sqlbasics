-- Comments are important for demonstration of skills so please read them
-- First execute the create-databases.sql file

-- e.g. 1
USE sql_store; -- Selects the database of interest
SELECT name, -- Specifies the columns of interest -- SELECT * can be used to choose all columns 
unit_price,
(unit_price + 5) * 1.1 AS updated_price -- Uses updated_price as the alias for the arithmetic expression (unit_price + 5) * 1.1
FROM products -- Specifies the table of interest
WHERE unit_price >= 1 -- Only returns records the have a product unit_price greater than or equal to 1 -- Other operators include > (greater than), < (less than), <= (less than or equal to), = (equal to), != (not equal to), <> (not equal to)
ORDER BY name, updated_price DESC -- Orders records alphabetically in ascending order by name, and then in descending order by updated_price
LIMIT 2, 3; -- Skips the first 2 records and returns only 3 records -- Useful for paginating results and also limiting to top items when sorting is also used

-- e.g. 2
USE sql_store;
SELECT *
FROM orders
WHERE order_date >= '2019-01-01'; -- Returns all records with orders placed this year 

-- e.g. 3
USE sql_store;
SELECT *, unit_price * quantity AS total_price -- Specifies all columns and also includes a column for total_price
FROM order_items
WHERE order_id = 6 AND unit_price * quantity > 30; -- Returns all records with order_id 6 and total_price greater than 30

-- e.g. 4
USE sql_store;
SELECT *
FROM products
WHERE quantity_in_stock = 49 OR quantity_in_stock = 38 OR quantity_in_stock = 72; -- Returns all records with product quantity_in_stock = 49 or 38 or 72
-- The expression above can be simplified using the IN operator: WHERE quantity_in_stock IN (49,38,72)

-- e.g. 5
USE sql_store;
SELECT *
FROM customers
WHERE  birth_date >= '1990-01-01' AND birth_date <= '2000-01-01'; -- Returns all records with customer birth_date between 1990 and 2000
-- The expression above can be simiplified using the BETWEEN operator: WHERE birth_date BETWEEN '1990-01-01','2000-01-01'

-- e.g. 6
USE sql_store;
SELECT *
FROM customers
WHERE address LIKE '%trail%' OR address LIKE '%avenue%'; -- Returns all records where customer address contains trail or avenue anywhere in the address field
-- The expression above can be simplified by using the REGEXP operator: WHERE address REGEXP 'trail|avenue'
-- When using REGEXP, ^ can be used to indicate the beginning of a string, $ to indicate the end, | as a logical or, [abcd] for a list of characters, and [a-f] for a range 

-- e.g. 7
USE sql_store;
SELECT *
FROM customers
WHERE phone NOT LIKE '%9';  -- Returns all records where customer phone number does not end with 9

-- e.g. 8
USE sql_store;
SELECT *
FROM orders
WHERE shipped_date IS NULL; -- Returns all records where orders have no shipped date -- Useful for identifying missing data

-- e.g. 9
USE sql_store;
SELECT order_id, oi.product_id, quantity, oi.unit_price -- Selects the following columns -- Products_id appears in both order_items and products tables so the prefix oi. must be used
FROM order_items oi -- Sets oi as the alias for order_items
JOIN products p -- Joins the order_items table with the products table and sets p as the alias for products
	ON oi.product_id = p.product_id; -- Joins the tables based on product_id

-- e.g. 10
USE sql_store;
SELECT *
FROM order_items oi
JOIN sql_inventory.products p -- Joins the order_items table from the sql_store database with the products table from the sql_inventory database
	ON oi.product_id = p.product_id;
    
-- e.g. 11
USE sql_invoicing;
SELECT p.date, p.invoice_id, p.amount, c.name, pm.name
FROM payments p
JOIN clients c -- Joins the payments table with the clients table
	ON p.client_id = c.client_id
JOIN payment_methods pm -- Joins the two tables above with the payment_methods table
	ON p.payment_method = pm.payment_method_id;
    
-- e.g. 12
USE sql_hr;
SELECT e.employee_id, e.first_name, m.first_name AS manager
FROM employees e
JOIN employees m -- Joins the employees table with itself
	ON e.reports_to = m.employee_id;

-- e.g. 13
USE sql_store;
SELECT *
FROM order_items oi
JOIN order_item_notes oin
	ON oi.order_id = oin.order_id
    AND oi.product_id = oin.product_id; -- Because order_items contains a composite primary key, it must be joint on both the conditions stated

-- e.g. 14
USE sql_store;
SELECT c.customer_id, c.first_name, o.order_id, sh.name AS shipper
FROM customers c
LEFT JOIN orders o -- A left outer join is used to ensure that all customer records are included even if they have not placed an order -- A right join could also be used if customers c and orders o were switched
	ON c.customer_id = o.customer_id
LEFT JOIN shippers sh -- A left outer join is used to ensure that all customer records are included even if they have no shipper id
	ON o.shipper_id = sh.shipper_id
ORDER BY c.customer_id;

-- e.g. 15
USE sql_store;
SELECT o.order_id, c.first_name
FROM orders o
JOIN customers c 
	USING (customer_id); -- If the join condition column in two tables has the same name then the USING clause can be used instead of: ON c.customer_id = o.customer_id 

-- e.g. 16
USE sql_store;
SELECT o.order_id, c.first_name
FROM orders o
NATURAL JOIN customers c; -- A NATURAL JOIN can also be used to join two tables based on a common column name, but this may lead to unexpected results because the database engine determines how to join the tables
	
-- e.g. 17
USE sql_store;
SELECT *
FROM customers c
CROSS JOIN products p; -- A CROSS JOIN can be used to list out all combinations of customers and products -- A cross join can also be done using the implicit syntax: FROM customers c, products p

-- e.g. 18
USE sql_store;
SELECT order_id, order_date, 'Active' AS status
FROM orders
WHERE order_date >= '2019-01-01'
UNION -- The UNION operator is used to combine table rows -- The number of columns from queries being joint together must be the same 
SELECT order_id, order_date, 'Archived' AS status
FROM orders
WHERE order_date < '2019-01-01';

-- e.g. 18
USE sql_store;
INSERT INTO customers (first_name, last_name, birth_date, address, city, state) -- INSERT INTO is used to add rows to a table -- Columns are listed (first_name, last_name...), for which values are specified below ('John', 'Smith'...)
VALUES ('John', 'Smith', '1990-01-01', 'address', 'city', 'CA');

-- e.g. 19
USE sql_store;
INSERT INTO shippers (name)
VALUES ('Shipper1'), ('Shipper2'), ('Shipper3'); -- Multiple rows can be inserted using this syntax

-- e.g. 20
USE sql_store;
INSERT INTO orders (customer_id, order_date, status)
VALUES (1, '2019-01-02', 1); -- Executing this insert creates an order ID for this new record because the order_id column of orders is set to auto increment
INSERT INTO order_items
VALUES (LAST_INSERT_ID(), 1, 1,2.95), (LAST_INSERT_ID(), 2, 1, 3.95); -- We can use LAST_INSERT_ID to call the order ID created earlier and use it in another expression

-- e.g. 21
USE sql_store;
CREATE TABLE orders_archived AS
SELECT * FROM orders; -- Creates a table named orders_archived and fills this with the data from the orders table -- Note that table settings are not transferred
-- Make sure to truncate the orders_archived table now
USE sql_store;
INSERT INTO orders_archived
SELECT *
FROM orders
WHERE order_date < '2019-01-01'; -- Only records from the orders table before 2019 are included in this new table

-- e.g. 22
USE sql_invoicing;
UPDATE invoices -- UPDATE is used to replace values in a table
SET payment_total = invoice_total * 0.5, payment_date = due_date -- Replaces values for payment_total and payment_date 
WHERE client_id = 3; -- Will update multiple records because there are multiple records with client_id = 3 but note that safe updates must be turned off in MySQL Workbench settings
               
-- e.g. 23
USE sql_invoicing;
UPDATE invoices
SET payment_total = invoice_total * 0.5, payment_date = due_date
WHERE client_id IN
				(SELECT client_id
                FROM clients
                WHERE state IN ('CA', 'NY')); -- Uses a subquery to insert a client ID based on the value returned for California and New York
                
-- e.g. 24
USE sql_invoicing;
DELETE FROM invoices -- DELETE FROM is used to delete records from a table
WHERE client_id = (
			SELECT client_id
            FROM clients
            WHERE name = 'Myworks'); -- Uses a subquery to delete records where client name is Myworks
            
-- To reset databases, execute the create-databases.sql file once more
