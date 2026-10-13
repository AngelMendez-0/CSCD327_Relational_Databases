set search_path to products;

select * from categories;
select * from products;
select * from customers;
select * from orders;
select * from order_items;

-- Checkpoint 1: 

-- A: products.category_id points to  categories.category_id

-- B: order_items.order_id points to orders.order_id
--    order_items.product_id points to products.product_id

-- C: orders.customer_id points to customers.customer_id


-- Checkpoint 2: 

select p.product_name, c.category_name
from products as p
join categories as c on p.category_id = c.category_id 
order by c.category_name, p.product_name;

--Fender Precision	Basses
--Hofner Icon	Basses
--Ludwig 5-piece Drum Set with Cymbals	Drums
--Tama 5-Piece Drum Set with Cymbals	Drums
--Fender Stratocaster	Guitars
--Gibson Les Paul	Guitars
--Gibson SG	Guitars
--Rodriguez Caballero 11	Guitars
--Washburn D10S	Guitars
--Yamaha FG700S	Guitars

-- 10 rows the same as products
-- Each product has exactly one category_id and it matches exactly one category
-- so each product produces exactly one row

-- Checkpoint 3: 

select p.product_name, c.category_name, p.list_price
from products as p
join categories as c on p.category_id = c.category_id 
where c.category_name  = 'Guitars'
and p.list_price > 500
order by p.list_price desc;

-- Gibson SG	Gibson Les Paul	Fender Stratocaster
-- Guitars	Guitars	Guitars
-- 2517.00	1199.00	699.00

-- -- 3 rows
-- The JOIN / ON line connects the tables
--  the WHERE/AND lines filter the rows
-- For over 1000 I would change only the filter line to
--  and p.list_price > 1000


-- Checkpoint 4: 

select oi.order_id, p.product_name, c.category_name
from order_items as oi
join products as p on oi.product_id = p.product_id
join categories as c on p.category_id = c.category_id 
order by oi.order_id; 

--1	Gibson Les Paul	Guitars
--2	Yamaha FG700S	Guitars
--3	Gibson SG	Guitars
--3	Rodriguez Caballero 11	Guitars
--4	Gibson Les Paul	Guitars
--5	Washburn D10S	Guitars
--6	Washburn D10S	Guitars
--7	Fender Stratocaster	Guitars
--7	Fender Precision	Basses
--7	Ludwig 5-piece Drum Set with Cymbals	Drums
--8	Tama 5-Piece Drum Set with Cymbals	Drums
--9	Fender Stratocaster	Guitars

-- Joining them takes two on conditions because each on links 2 tables
-- that means that the first link is now a new table and finally you link the remaining table so you only need two

-- The row count matches order_items with 12 rows each item points to exactly one product
-- and each product to exactly one category, so every item becomes exactly one row.
-- orders 3 and 7 appear more than once because they contain multiple items.


-- Checkpoint 5: 

select c.category_name, p.product_name
from categories as c
join products as p on c.category_id = p.category_id
order by c.category_name;

--Basses	Fender Precision
--Basses	Hofner Icon
--Drums	Ludwig 5-piece Drum Set with Cymbals
--Drums	Tama 5-Piece Drum Set with Cymbals
--Guitars	Washburn D10S
--Guitars	Fender Stratocaster
--Guitars	Rodriguez Caballero 11
--Guitars	Gibson Les Paul
--Guitars	Gibson SG
--Guitars	Yamaha FG700S

-- 10 rows with only 3 categories

select c.category_name, p.product_name
from categories as c
left join products as p on c.category_id = p.category_id
order by c.category_name;

--Drums	Tama 5-Piece Drum Set with Cymbals
--Guitars	Washburn D10S
--Guitars	Rodriguez Caballero 11
--Guitars	Fender Stratocaster
--Guitars	Gibson Les Paul
--Guitars	Gibson SG
--Guitars	Yamaha FG700S
--Keyboards	

-- 11 rows

-- Keyboards now appears and it has no products so a JOIN finds no match and
-- drops it and LEFT JOIN keeps every category and fills product_name with NULL


-- Checkpoint 6: 

select p.product_name
from products as p
left join order_items as oi on p.product_id = oi.product_id
where oi.item_id is null;

-- Hofner Icon

-- LEFT JOIN keeps every product so products with no order_items get NULL in all
-- oi columns so WHERE oi.item_id IS NULL keeps only the never ordered ones

-- Checkpoint 7: 

select c.category_name, p.product_name
from categories as c
right join products as p on c.category_id = p.category_id
order by c.category_name;

-- 10 rows and Keyboards does not appear
-- RIGHT JOIN keeps every row from the right table and no product
-- points to Keyboards

-- It's the same result as a normal JOIN 
--  You'd use FULL OUTER JOIN when you need unmatched rows from both tables

-- Checkpoint 8: 

-- starter 

SELECT c.first_name, c.last_name, o.order_id 
FROM customers AS c 
JOIN orders AS o ON c.customer_id = o.customer_id 
ORDER BY c.last_name; 


-- corrected 

select c.first_name, c.last_name, o.order_id
from customers AS c
left join orders as o on c.customer_id = o.customer_id
order by c.last_name;

--Christine	Brown	4
--Heather	Esway	
--David	Goldstein	9
--David	Goldstein	5
--Gary	Hernandez	8
--Allan	Sherwood	1
--Allan	Sherwood	3
--Erin	Valentino	6
--Frank Lee	Wilson	7
--Barry	Zimmer	2

--- question 4 catches this since the question needs unmatched customers
-- but JOIN drops them
-- LEFT JOIN keeps every customer with NULL for order_id
-- if they have no orders.
-- The customer who now appears is Heather Eswaynwith a NULL order_id

-- Checkpoint 9: 

-- starter 

SELECT customer_id, order_id, last_name 
FROM orders AS o 
JOIN customers AS c ON o.customer_id = c.customer_id; 

--SQL Error [42702]: ERROR: column reference "customer_id" is ambiguous
--  Position: 8

-- it broke because it has customer id in both so it can't tell which to use 

-- corrected 
 
select o.customer_id, o.order_id, c.last_name
from orders as o
join customers as c on o.customer_id = c.customer_id;

-- 1	1	Sherwood
--2	2	Zimmer
--1	3	Sherwood
--3	4	Brown
--4	5	Goldstein
--5	6	Valentino
--6	7	Wilson
--7	8	Hernandez
--4	9	Goldstein

-- Checkpoint 10: 

-- starter

SELECT oi.order_id, p.product_name 
FROM order_items AS oi 
JOIN products AS p ON oi.item_price = p.list_price; 

-- corrected 

select oi.order_id, p.product_name
from order_items as oi
join products AS p on oi.product_id = p.product_id
order by oi.order_id;

-- item_price equals what was paid for the item on that order
-- list_price is the product's catalog price
-- equal prices don't mean it's the same product two products cost
-- 799.99, so one item can match both, creating wrong or duplicate rows
-- also change. The real foreign key is order_items.product_id -> products.product_id.

-- Checkpoint 11: 

-- starter 

SELECT order_id, last_name 
FROM orders 
NATURAL JOIN customers; 

-- corrected 

select o.order_id, c.last_name
from orders as o
join customers as c using (customer_id);

-- Shared columns: customer_id and billing_address_id
-- natural join matches on both so orders whose billing address differs
-- from the customer's are dropped. using joins only the customer_id

set search_path to default;

