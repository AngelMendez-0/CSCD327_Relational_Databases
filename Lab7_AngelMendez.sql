  set search_path to sales;

select * from salesreps;
select * from customers;
select * from orders;
select * from products;
select * from offices;


-- Checkpoint 1: 

select quota, name
from salesreps
where quota < 
(select avg(quota) from salesreps);

-- 3 rows

--275000.00	Sam Clark
--200000.00	Bob Smith
--275000.00	Paul Cruz

-- no the where doesn't evaluate for a null instance
-- if we were to include it then the average would change based on a null value


-- Checkpoint 2: 

-- No join: 
select company
from customers
where cust_rep in 
(select empl_num
from salesreps
where rep_office = 12);

-- 7 rows 

--JCP Inc.
--First Corp.
--Smithson Corp.
--QMA Assoc.
--Ian & Schmidt
--Chen Associates
--AAA Investments

-- Join: 

select c.company 
from customers c
join salesreps s on c.cust_rep = s.empl_num
where s.rep_office = 12;

-- 7 rows

--JCP Inc.
--First Corp.
--Smithson Corp.
--QMA Assoc.
--Ian & Schmidt
--Chen Associates
--AAA Investments

-- Checkpoint 3: 

select mfr_id, product_id, description
from products
where (mfr_id, product_id) not in (select mfr, product from orders)
order by mfr_id, product_id;

-- 8 rows

--BIC	41627	Plate
--IMM	887H 	Brace Holder
--IMM	887P 	Brace Pin
--IMM	887X 	Brace Retainer
--QSA	XK48 	Reducer
--QSA	XK48A	Reducer

-- not null makes not in safe cause not in means x is not equal to every value in the subquery
-- so if the subquery returned a NULL, x <> NULL would be uknown and not in could never be true
-- Because mfr and product are NOT NULL, every comparison is true or false, so the result is correct.

-- Checkpoint 4: 

-- A: 

select name, sales
from salesreps
where sales > 
any( select sales 
from salesreps
where rep_office = 21)
order by sales desc;

-- 3 rows

--Sue Smith	474050.00
--Mary Jones	392725.00
--Bill Adams	367911.00

-- B: 

select name, sales
from salesreps
where sales > 
all (select sales
from salesreps
where rep_office = 21)
order by sales desc;

-- 0 rows

-- all means greater than the largest value in the set to beat every value x 
-- b returns no rows because the company top seller sue smith works at office 21 that makes her the largest
-- value in the set


-- Checkpoint 5: 

SELECT name, sales
FROM salesreps
WHERE sales > ALL (SELECT quota FROM salesreps);

-- returns 0 rows

-- its empty because all is ttue only when every comparison in the set is true 
-- that means the null quota is contained in the set making it false

-- Fixed: 

select name, sales
from salesreps
where sales > 
all( select quota 
from salesreps
where quota is not null);

-- 4 rows

--Mary Jones	392725.00
--Larry Fitch	361865.00
--Bill Adams	367911.00
--Sue Smith	474050.00


-- Checkpoint 6: 

select s.name
from salesreps s
where s.sales >
(select m.sales 
from salesreps m
where m.empl_num = s.manager);

--Mary Jones
--Larry Fitch
--Bill Adams
--Sue Smith
--Dan Roberts
--Paul Cruz

-- the outer rows s.manager column connects to the outer row
-- no the vp is sam clark and his manager is null


-- Checkpoint 7: 

select c.company
from customers c
where exists
(select 1
from orders o
where o.cust = c.cust_num
and o.amount > 20000);

-- 6 rows

--Acme Mfg.
--Ace International
--Zetacorp
--J.P. Sinclair
--Ian & Schmidt
--Chen Associates

-- No the SELECT list doesn’t matter
-- exists only checks whether the subquery returns at least one row and never looks at the values
--  so select 1, select * and select o.order_num all give the same result


-- Checkpoint 8: 

SELECT name
FROM salesreps
WHERE empl_num NOT IN (SELECT manager FROM salesreps);

-- 0 rows

-- Yes sam clark is the vp and has no manager so his manager is null

--empl_num NOT IN (set) means empl_num <> every value in the set 

-- Fixed: 

select s.name 
from salesreps s
where not exists
(select 1 
from salesreps r
where r.manager = s.empl_num);

-- 6 rows

--Mary Jones
--Sue Smith
--Nancy Angelli
--Tom Snyder
--Paul Cruz
--Bill Adams

-- no texists only asks whether any row  matches so sam clarks null manager
-- makes the query upnknown and where drops that row inside the subquery


-- Checkpoint 9: 

select t.mfr, t.total
from (select mfr, sum(amount) as total
from orders
group by mfr) as t
where t.total > 30000;

-- 3 rows 

--IMM	43650.00
--REI	103628.00
--ACI	82315.00

-- if you leave the name off the query failes with error in from since it must have alias

-- Checkpoint 10: 

select s.name, avg(o.amount) as avg_order
from orders o
join salesreps s on o.rep = s.empl_num
group by s.empl_num, s.name
having avg(o.amount) > (select avg(amount) from orders);

-- 5 rows

--Nancy Angelli	11477.3333333333333333
--Tom Snyder	11566.0000000000000000
--Dan Roberts	8876.0000000000000000
--Larry Fitch	8376.1428571428571429
--Sam Clark	16479.000000000000

-- where filters individual rows before goruping so at that point no reps average
-- exists yet. that also is why aggregate functions like avg aren't allowed in where so having
-- filters after the group by


-- Checkpoint 11: 

with office_totals as(
select o.office, o.city, sum(ord.amount) as total
from offices o
join salesreps s on s.rep_office = o.office
join orders ord on ord.rep = s.empl_num
group by o.office, o.city)
select office, city, total
from office_totals
where total < (select avg(total) from office_totals)
order by total;

-- 4 rows

--12	Chicago	29328.00
--22	Denver	34432.00
--13	Atlanta	39327.00
--11	New York	40063.00

-- the CTE saves from repeating three table join and group by twice

-- Checkpoint 12: 

create view rep_performance as
select name, quota, sales, sales - quota as variance
from salesreps;

select name, quota, sales, variance
from rep_performance
where variance < 0;

-- 2 rows

--Nancy Angelli	300,000.00	186,042.00	−113,958.00
--Bob Smith	200,000.00	142,594.00	−57,406.00

-- tom snyders quota is null so his variance is 75,985 to null which is null

-- yes he has no quoto so over or under quota isn't defined for him


-- Checkpoint 13: 

-- Caught by the shape check: = expects one value, but the subquery returns many rows

-- ERROR: more than one row returned by subquery used as an expression

-- Fixed: 

select name 
from salesreps
where empl_num in( select cust_rep
from customers
where credit_limit > 40000);

-- 7 rows 

--Paul Cruz
--Dan Roberts
--Bill Adams
--Sam Clark
--Larry Fitch
--Mary Jones
--Sue Smith

-- yes a join returns one row per matching customer not one per rep, four reps have 
-- two qualifying customers each so a join returns 11

