set search_path to books;

select * from books;
select * from orderitems;
select * from author;
select * from bookauthor;

-- Checkpoint 1: 

select 
MAX(retail) as max_retail,
MIN(retail) as min_retail, 
round(AVG(retail),2) as avg_retail,
COUNT(*) as book_count
from books;

--89.95	8.95	40.98	14
-- the row is a summary of all the books together
-- no specific book so its an overall average, low, high, and count

-- Checkpoint 2: 

select category, 
count(*) as book_count, 
round(avg(retail), 2) as avg_retail
from books
group by category
order by book_count desc, category;

--COMPUTER	4	52.85
--CHILDREN	2	34.45
--COOKING	2	24.35
--FAMILY LIFE	2	55.98
--BUSINESS	1	31.95
--FITNESS	1	30.95
--LITERATURE	1	39.95
--SELF HELP	1	29.95

-- 8 rows. The number of distinct categories decides 
-- the row count, not the number of books.

-- Checkpoint 3: 

select pubid, category, 
count(*) as count
from books
group by category, pubid
order by pubid, category;

--1	BUSINESS	1
--1	FAMILY LIFE	1
--2	CHILDREN	1
--2	COMPUTER	1
--3	COMPUTER	3
--4	COOKING	2
--4	FITNESS	1
--4	SELF HELP	1
--5	CHILDREN	1
--5	FAMILY LIFE	1
--5	LITERATURE	1

-- 11 rows
-- grouping by two gives more rows because pubid alone would
-- give one row per publisher but grouping by category as well breaks each 
-- publisher into one row for every category as well

-- Checkpoing 4: 

select category,
round(avg(retail), 2) as avg_retail
from books
where retail > 20
group by category
having avg(retail) >= 40;

--COMPUTER	52.85
--CHILDREN	59.95
--FAMILY LIFE	55.98

-- where eremoed anything with retail less than 20 
-- having removed anything that had an average of less than 40

-- Checkpoint 5: 

select  
count(*) as total_books,
count(discount) as discounted_books
from books;

--14	4

-- this tells me that only 4 of 14 books are dicounted while the rest
-- have no value as their discount meaning the discount field can be null
-- they differ by 10, meaning 10 books have a NULL discount (no discount)

-- Checkpoint 6: 

select 
count(distinct category) as dist_book_cat
from books;

-- 8 

select 
count(category) as book_category
from books;

-- 14

-- COUNT(category) would return 14 because it counts every book that
-- has a category, even when books share the same one.
-- COUNT(DISTINCT category) counts each category only once, 
-- so it returns 8

-- Checkpoint 7: 

select title, 
(retail - cost) as profit
from books
where profit > 20;

-- SQL Error [42703]: ERROR: column "profit" does not exist

-- fixed: 

select title, 
(retail - cost) as profit
from books
where (retail - cost) > 20
order by profit desc;

--PAINLESS CHILD-REARING	41.95
--HOLY GRAIL OF ORACLE	28.70
--DATABASE IMPLEMENTATION	24.55
--BUILDING A CAR WITH TOOTHPICKS	22.15

-- the database doesn't run the query in the writen order
-- that means the alias isn't created before the where runs so it doesn't exist yet
-- ORDER BY runs after SELECT, so the alias exists by then

-- Checkpoint 8: 

SELECT title, retail
FROM books
WHERE retail = MAX(retail);

--  ERROR: aggregate functions are not allowed in WHERE

-- fixed: 

select title, retail
from books
where retail = (select MAX(retail) from books);

--PAINLESS CHILD-REARING	89.95
-- WHERE checks one row at a time, before aggregates are calculated, 
-- so MAX(retail) doesn't exist yet at that point

-- Checkpoint 9: 

SELECT category, COUNT(*) AS book_count
FROM books;

-- ERROR: column "books.category" must appear in the GROUP BY clause or be used in an aggregate function

-- fixed: 

select category, 
count(*) as book_count
from books
group by category;

--COMPUTER	4
--COOKING	2
--FITNESS	1
--BUSINESS	1
--LITERATURE	1
--SELF HELP	1
--CHILDREN	2
--FAMILY LIFE	2

-- 8 Rows
-- the GROUP BY is missing

-- Checkpoint 10: 

SELECT category, COUNT(*) AS book_count
FROM books
WHERE COUNT(*) > 1
GROUP BY category;

-- fixed: 

select category, 
count(*) as book_count
from books
group by category
having count(*) > 1;

--COMPUTER	4
--COOKING	2
--CHILDREN	2
--FAMILY LIFE	2

-- where filters rows before group by so the group doesn't exist yet
-- having filters the whole groups after its been grouped

-- Checkpoint 11:

select b.title,
sum(oi.quantity) as total_qty
from orderitems oi
join books b on oi.isbn = b.isbn
group by b.isbn, b.title
order by total_qty desc;

--COOKING WITH MUSHROOMS	8
--DATABASE IMPLEMENTATION	7
--PAINLESS CHILD-REARING	6
--REVENGE OF MICKEY	5
--BIG BEAR AND LITTLE DOVE	4
--HOLY GRAIL OF ORACLE	3
--HANDCRANKED COMPUTERS	2
--E-BUSINESS THE EASY WAY	2
--HOW TO MANAGE THE MANAGER	1
--SHORTEST POEMS	1
--BODYBUILD IN 10 MINUTES A DAY	1

-- 11 rows

-- some books are missing because an inner join only keep srows that 
-- match in both tables and a book that was never ordered has no rows so it drops

-- Fix: 

select b.title,
coalesce(sum(oi.quantity), 0) as total_qty
from books b
left join orderitems oi on b.isbn = oi.isbn
group by b.isbn, b.title
order by total_qty desc;

--COOKING WITH MUSHROOMS	8
--DATABASE IMPLEMENTATION	7
--PAINLESS CHILD-REARING	6
--REVENGE OF MICKEY	5
--BIG BEAR AND LITTLE DOVE	4
--HOLY GRAIL OF ORACLE	3
--HANDCRANKED COMPUTERS	2
--E-BUSINESS THE EASY WAY	2
--HOW TO MANAGE THE MANAGER	1
--SHORTEST POEMS	1
--BODYBUILD IN 10 MINUTES A DAY	1
--THE WOK WAY TO COOK	0
--HOW TO GET FASTER PIZZA	0
--BUILDING A CAR WITH TOOTHPICKS	0

-- this includes books that have null since they were never ordered

-- Checkpoint 12: 

select b.category, 
sum(oi.quantity * oi.paideach) as revenue
from orderitems oi
join books b on oi.isbn = b.isbn
group by b.category
order by revenue desc;

--COMPUTER	767.10
--FAMILY LIFE	622.70
--COOKING	159.60
--LITERATURE	39.95
--CHILDREN	35.80
--BUSINESS	31.95
--FITNESS	30.95

-- Computer earned the most
-- the number being added up with sum comes from orderitmes, the group label
-- category comes from books and the join is what connects each sale to its category

-- Checkpoint 13: 

select a.fname, a.lname,
count(*) as book_count
from author a
join bookauthor ba on a.authorid = ba.authorid
group by a.authorid, a.fname, a.lname
having count(*) >= 2;

--LISA	WHITE	2
--ROBERT	ROBINSON	2
--JANICE	JONES	2
--JAMES	AUSTIN	2
--JACK	BAKER	2
--SAM	SMITH	3
--WILLIAM	WHITE	2

-- join connects each author to the book they wrote giving one row per pair
-- group by collapses those rows into one row per author and counts the books
-- having keeps only the authors whose count is 2 or more

set search_path to default;
