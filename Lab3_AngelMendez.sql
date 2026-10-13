-- Part A: 
set search_path to books;


-- Checkpoint 1: 

select title, retail, 
(retail - cost) as profit
from books;

--BODYBUILD IN 10 MINUTES A DAY	30.95	12.20
--REVENGE OF MICKEY	22.00	7.80
--BUILDING A CAR WITH TOOTHPICKS	59.95	22.15
--DATABASE IMPLEMENTATION	55.95	24.55
--COOKING WITH MUSHROOMS	19.95	7.45
--HOLY GRAIL OF ORACLE	75.95	28.70
--HANDCRANKED COMPUTERS	25.00	3.20
--E-BUSINESS THE EASY WAY	54.50	16.60
--PAINLESS CHILD-REARING	89.95	41.95
--THE WOK WAY TO COOK	28.75	9.75
--BIG BEAR AND LITTLE DOVE	8.95	3.63
--HOW TO GET FASTER PIZZA	29.95	12.10
--HOW TO MANAGE THE MANAGER	31.95	16.55
--SHORTEST POEMS	39.95	18.10

-- "As" assigns an alias for a given output

-- Checkpoint 2: 

select distinct category
from books;

--COMPUTER
--COOKING
--FITNESS
--BUSINESS
--LITERATURE
--SELF HELP
--CHILDREN
--FAMILY LIFE

-- 14 orignally and 8 distinct, this tells me that several fall into different categories
-- but arent distinct books themselves all books are divided into their respective category

-- Checkpoint 3: 

select title, retail 
from books
where retail between 20 and 40;

--BODYBUILD IN 10 MINUTES A DAY	30.95
--REVENGE OF MICKEY	22.00
--HANDCRANKED COMPUTERS	25.00
--THE WOK WAY TO COOK	28.75
--HOW TO GET FASTER PIZZA	29.95
--HOW TO MANAGE THE MANAGER	31.95
--SHORTEST POEMS	39.95

select title, retail
from books
where (retail >= 20 and retail <= 40);

--BODYBUILD IN 10 MINUTES A DAY	30.95
--REVENGE OF MICKEY	22.00
--HANDCRANKED COMPUTERS	25.00
--THE WOK WAY TO COOK	28.75
--HOW TO GET FASTER PIZZA	29.95
--HOW TO MANAGE THE MANAGER	31.95
--SHORTEST POEMS	39.95

-- Checkpoint 4: 

select title, category
from books
where category in('COMPUTER', 'COOKING', 'CHILDREN');

--BUILDING A CAR WITH TOOTHPICKS	CHILDREN
--DATABASE IMPLEMENTATION	COMPUTER
--COOKING WITH MUSHROOMS	COOKING
--HOLY GRAIL OF ORACLE	COMPUTER
--HANDCRANKED COMPUTERS	COMPUTER
--E-BUSINESS THE EASY WAY	COMPUTER
--THE WOK WAY TO COOK	COOKING
--BIG BEAR AND LITTLE DOVE	CHILDREN

select title, category
from books
where category = 'COMPUTER' or category = 'COOKING' or category = 'CHILDREN';

--BUILDING A CAR WITH TOOTHPICKS	CHILDREN
--DATABASE IMPLEMENTATION	COMPUTER
--COOKING WITH MUSHROOMS	COOKING
--HOLY GRAIL OF ORACLE	COMPUTER
--HANDCRANKED COMPUTERS	COMPUTER
--E-BUSINESS THE EASY WAY	COMPUTER
--THE WOK WAY TO COOK	COOKING
--BIG BEAR AND LITTLE DOVE	CHILDREN

-- in makes it to where I don't have to check category each time where as or I have to check it each time 
-- as if it's a true or false boolean or else it will not compile

-- Checkpoint 5: 

select title
from books
where title ilike '%how%';

--HOW TO GET FASTER PIZZA
--HOW TO MANAGE THE MANAGER

select title
from books
where title like '%how%';

-- you get nothing in the second because like is case sensitive

-- Checkpoint 6: 

select title, category, retail
from books
where retail > 40 and category = 'COMPUTER' or category = 'FAMILY LIFE';

--REVENGE OF MICKEY	FAMILY LIFE	22.00
--DATABASE IMPLEMENTATION	COMPUTER	55.95
--HOLY GRAIL OF ORACLE	COMPUTER	75.95
--E-BUSINESS THE EASY WAY	COMPUTER	54.50
--PAINLESS CHILD-REARING	FAMILY LIFE	89.95

select title, category, retail
from books
where retail > 40 and (category = 'COMPUTER' or category = 'FAMILY LIFE');

--DATABASE IMPLEMENTATION	COMPUTER	55.95
--HOLY GRAIL OF ORACLE	COMPUTER	75.95
--E-BUSINESS THE EASY WAY	COMPUTER	54.50
--PAINLESS CHILD-REARING	FAMILY LIFE	89.95

-- they differ because the first one checks the retail and computer category together and the last or seperate
-- the other checks the reetail and both categories together

-- Checkpoint 7: 

select title, isbn, discount
from books
where discount is null; 

--BODYBUILD IN 10 MINUTES A DAY	1059831198	
--REVENGE OF MICKEY	0401140733	
--DATABASE IMPLEMENTATION	8843172113	
--COOKING WITH MUSHROOMS	3437212490	
--HANDCRANKED COMPUTERS	1915762492	
--E-BUSINESS THE EASY WAY	9959789321	
--THE WOK WAY TO COOK	0299282519	
--BIG BEAR AND LITTLE DOVE	8117949391	
--HOW TO MANAGE THE MANAGER	9247381001	
--SHORTEST POEMS	2147428890	

select title, isbn, discount
from books
where discount = null; 

-- nothing in query

-- is null checks if its non existant and = checks if it is the value of null which is why they differ

-- Checkpoint 8: 

select title, discount, (discount is not null and discount >= 0) as discount_or_zero
from books;

--BODYBUILD IN 10 MINUTES A DAY		false
--REVENGE OF MICKEY		false
--BUILDING A CAR WITH TOOTHPICKS	3.00	true
--DATABASE IMPLEMENTATION		false
--COOKING WITH MUSHROOMS		false
--HOLY GRAIL OF ORACLE	3.80	true
--HANDCRANKED COMPUTERS		false
--E-BUSINESS THE EASY WAY		false
--PAINLESS CHILD-REARING	4.50	true
--THE WOK WAY TO COOK		false
--BIG BEAR AND LITTLE DOVE		false
--HOW TO GET FASTER PIZZA	1.50	true
--HOW TO MANAGE THE MANAGER		false
--SHORTEST POEMS		false

select title, discount , coalesce(discount, 0) as discount_or_zero
from books; 

--BODYBUILD IN 10 MINUTES A DAY		0
--REVENGE OF MICKEY		0
--BUILDING A CAR WITH TOOTHPICKS	3.00	3.00
--DATABASE IMPLEMENTATION		0
--COOKING WITH MUSHROOMS		0
--HOLY GRAIL OF ORACLE	3.80	3.80
--HANDCRANKED COMPUTERS		0
--E-BUSINESS THE EASY WAY		0
--PAINLESS CHILD-REARING	4.50	4.50
--THE WOK WAY TO COOK		0
--BIG BEAR AND LITTLE DOVE		0
--HOW TO GET FASTER PIZZA	1.50	1.50
--HOW TO MANAGE THE MANAGER		0
--SHORTEST POEMS		0

-- math doesn't populate the values and simply returns true or false 
-- whereas coalesce does populate the discount values

-- Checkpoint 9: 

select title, category, retail
from books
order by category, retail;

select title, category, retail
from books
order by category, retail desc;

--BIG BEAR AND LITTLE DOVE	CHILDREN	8.95
--BODYBUILD IN 10 MINUTES A DAY	FITNESS	30.95
--BUILDING A CAR WITH TOOTHPICKS	CHILDREN	59.95
--COOKING WITH MUSHROOMS	COOKING	19.95
--DATABASE IMPLEMENTATION	COMPUTER	55.95
--E-BUSINESS THE EASY WAY	COMPUTER	54.50
--HANDCRANKED COMPUTERS	COMPUTER	25.00
--HOLY GRAIL OF ORACLE	COMPUTER	75.95
--HOW TO GET FASTER PIZZA	SELF HELP	29.95
--HOW TO MANAGE THE MANAGER	BUSINESS	31.95
--PAINLESS CHILD-REARING	FAMILY LIFE	89.95
--REVENGE OF MICKEY	FAMILY LIFE	22.00
--SHORTEST POEMS	LITERATURE	39.95
--THE WOK WAY TO COOK	COOKING	28.75

--it just sorts by the title when I don't specicy and ignores the second argument. when i specify it changes

-- Checkpoint 10: 
-- Q1: 

select isbn, title, retail
from books
where retail > 25;

--1059831198	BODYBUILD IN 10 MINUTES A DAY	30.95
--4981341710	BUILDING A CAR WITH TOOTHPICKS	59.95
--8843172113	DATABASE IMPLEMENTATION	55.95
--3957136468	HOLY GRAIL OF ORACLE	75.95
--9959789321	E-BUSINESS THE EASY WAY	54.50
--2491748320	PAINLESS CHILD-REARING	89.95
--0299282519	THE WOK WAY TO COOK	28.75
--0132149871	HOW TO GET FASTER PIZZA	29.95
--9247381001	HOW TO MANAGE THE MANAGER	31.95
--2147428890	SHORTEST POEMS	39.95

-- the fourth question catches it because it needs greater than 25 not exactly 25 and it 
-- was retail >= 25 instead of >

-- Q2: 

select title, retail
from books;

--BODYBUILD IN 10 MINUTES A DAY	30.95
--REVENGE OF MICKEY	22.00
--BUILDING A CAR WITH TOOTHPICKS	59.95
--DATABASE IMPLEMENTATION	55.95
--COOKING WITH MUSHROOMS	19.95
--HOLY GRAIL OF ORACLE	75.95
--HANDCRANKED COMPUTERS	25.00
--E-BUSINESS THE EASY WAY	54.50
--PAINLESS CHILD-REARING	89.95
--THE WOK WAY TO COOK	28.75
--BIG BEAR AND LITTLE DOVE	8.95
--HOW TO GET FASTER PIZZA	29.95
--HOW TO MANAGE THE MANAGER	31.95
--SHORTEST POEMS	39.95

-- you get caught on step 2 because it selected it from orders not from books like its meant to


-- Checkpoint 12: 

-- Perdiciton: it wont work because customer_num doesnt exist

select isbn, title 
from books

union 

select customer_num, lastname 
from customers;

-- it didn't work because they are different data types

-- Checkpoint 13: 

select lname 
from author

union 

select lastname
from customers;

--MORALES
--THOMPSON
--SMITH
--PIERSON
--GIRARD
--CRUZ
--GIANA
--JONES
--PEREZ
--LUCAS
--MCGOVERN
--MCKENZIE
--NGUYEN
--LEE
--SCHELL
--DAUM
--NELSON
--MONTIASA
--SMITH
--FALAH

select lname
from author

union all 

select lastname
from customers;

--MORALES
--THOMPSON
--SMITH
--PIERSON
--GIRARD
--CRUZ
--GIANA
--JONES
--PEREZ
--LUCAS
--MCGOVERN
--MCKENZIE
--NGUYEN
--LEE
--SCHELL
--DAUM
--NELSON
--MONTIASA
--SMITH
--FALAH

-- union combines both results and removes duplicates while union all keeps them

-- Checkpoint 14: 

select lname 
from author

intersect

select lastname 
from customers;

--MORALES
--THOMPSON
--SMITH
--PIERSON
--GIRARD
--CRUZ
--GIANA
--JONES
--PEREZ
--LUCAS
--MCGOVERN
--MCKENZIE
--NGUYEN
--LEE
--SCHELL
--DAUM
--NELSON
--MONTIASA
--SMITH
--FALAH

-- No it doesn't mean they're an author it just means that they have a distinct name that isn't 
-- shared by someone else amongst both tables

-- Checkpoint 15: 

select lname 
from author

except 

select lastname 
from customers
order by 1;

--CRUZ
--DAUM
--FALAH
--GIANA
--GIRARD
--JONES
--LEE
--LUCAS
--MCGOVERN
--MCKENZIE
--MONTIASA
--MORALES
--NELSON
--NGUYEN
--PEREZ
--PIERSON
--SCHELL
--SMITH
--SMITH
--THOMPSON

select lastname 
from customers

except

select lname 
from author
order by 1;

--ADAMS
--AUSTIN
--BAKER
--FIELDS
--JONES
--KZOCHSKY
--MARTINEZ
--PETERSON
--PORTER
--ROBINSON
--SMITH
--WHITE
--WHITE
--WILKINSON

-- the row counts are different being 17 vs 11 
--  order matters here because swapping them returns different tables base on how they intersect
-- except returns the distinct rows that only show up in the first and not the second query

-- Checkpoint 16:

select customer_num 
from orders where shipdate is not null

except

select customer_num 
from orders where shipdate is null
order by customer_num;

--1001
--1003
--1008
--1017
--1018
--1020

--I'm subtracting the customers with unshipped orders where shipdate is null from the customers 
--with shipped orders where shipped is not null, what's left is customers with only shipped orders
-- order by goes once at the very end because it sorts the final combined result



