set search_path to university;
select * from student;
select * from course;
select * from takes;
select * from prereq;
select * from instructor;
select * from teaches;


-- Checkpoint 1:


-- SQL:
select title, credits
from course
where credits > 3;


--Intro. to Biology	4
--Genetics	4
--Intro. to Computer Science	4
--Game Design	4
--Physical Principles	4


-- RA:
π{title, credits}(σ{credits > 3}(course))


--Intro. to Biology	4
--Genetics	4
--Intro. to Computer Science	4
--Game Design	4
--Physical Principles	4
-- σ changes the number of rows whilst π changes the number of columns




-- Checkpoint 2:


-- SQL:
select name, dept_name, tot_cred
from student
where dept_name = 'Comp. Sci.' and tot_cred > 50;


--Zhang	Comp. Sci.	102
--Williams	Comp. Sci.	54
--Brown	Comp. Sci.	58


-- RA:
π{name, dept_name, tot_cred}(σ{dept_name = 'Comp. Sci.' and tot_cred > 50}(student))


--Zhang	Comp. Sci.	102
--Williams	Comp. Sci.	54
--Brown	Comp. Sci.	58


-- RA is procedural because an expression spells out the sequence of operations to apply
-- SQL is declarative because the query only describes the properties the result must have




-- Checkpoint 3:


-- student × course has 169 rows (13 × 13) and 8 columns (4 + 4)
-- almost all the rows are meaningless because the product matches rows without
-- checking if they are related or not




-- Checkpoint 4:


-- SQL:
select s.name, c.title
from student s
join takes t on s.ID = t.ID
join course c on t.course_id = c.course_id
where c.dept_name = 'Biology';


--Tanaka	Intro. to Biology
--Tanaka	Genetics


-- RA:
π{s.name, c.title}(σ{c.dept_name = 'Biology'}((ρs(student) ⋈{s.ID = t.ID} ρt(takes)) ⋈{t.course_id = c.course_id} ρc(course)))


--Tanaka	Intro. to Biology
--Tanaka	Genetics


-- dept_name is kept apart because the theta joins only match on s.ID = t.ID and
-- t.course_id = c.course_id, so the two dept_name columns are never compared
-- Counts: natural join = 17, explicit join = 22
-- lost enrollments: Levy’s and Bourikas’s 5 CS courses are lost, because the natural
-- join also requires the student’s major to equal the course’s department


-- Checkpoint 5:


-- Shared columns: ID, course_id, sec_id, semester, year
-- The extra column, ID, forces the student's ID to equal the instructor's ID
-- That's wrong because the student and instructor are different people


-- Natural join:
SELECT COUNT(*) FROM takes NATURAL JOIN teaches;


-- Row count: 0
-- SQL:
select *
from takes t
join teaches te
 on t.course_id = te.course_id
and t.sec_id = te.sec_id
and t.semester = te.semester
and t.year = te.year;


-- Row count: 22


-- RA:
ρt(takes) ⋈{t.course_id = te.course_id and t.sec_id = te.sec_id and t.semester = te.semester and t.year = te.year} ρte(teaches)


--128	CS-101	1	Fall	2017	A	10101	CS-101	1	Fall	2017
--128	CS-347	1	Fall	2017	A-	10101	CS-347	1	Fall	2017
--12345	CS-101	1	Fall	2017	C	10101	CS-101	1	Fall	2017
--12345	CS-190	2	Spring	2017	A	83821	CS-190	2	Spring	2017
--12345	CS-315	1	Spring	2018	A	10101	CS-315	1	Spring	2018
--12345	CS-347	1	Fall	2017	A	10101	CS-347	1	Fall	2017
--19991	HIS-351	1	Spring	2018	B	32343	HIS-351	1	Spring	2018
--23121	FIN-201	1	Spring	2018	C+	12121	FIN-201	1	Spring	2018
--44553	PHY-101	1	Fall	2017	B-	22222	PHY-101	1	Fall	2017
--45678	CS-101	1	Fall	2017	F	10101	CS-101	1	Fall	2017
--45678	CS-101	1	Spring	2018	B+	45565	CS-101	1	Spring	2018
--45678	CS-319	1	Spring	2018	B	45565	CS-319	1	Spring	2018
--54321	CS-101	1	Fall	2017	A-	10101	CS-101	1	Fall	2017
--54321	CS-190	2	Spring	2017	B+	83821	CS-190	2	Spring	2017
--55739	MU-199	1	Spring	2018	A-	15151	MU-199	1	Spring	2018
--76543	CS-101	1	Fall	2017	A	10101	CS-101	1	Fall	2017
--76543	CS-319	2	Spring	2018	A	83821	CS-319	2	Spring	2018
--76653	EE-181	1	Spring	2017	C	98345	EE-181	1	Spring	2017
--98765	CS-101	1	Fall	2017	C-	10101	CS-101	1	Fall	2017
--98765	CS-315	1	Spring	2018	B	10101	CS-315	1	Spring	2018
--98988	BIO-101	1	Summer	2017	A	76766	BIO-101	1	Summer	2017
--98988	BIO-301	1	Summer	2018	NULL	76766	BIO-301	1	Summer	2018




-- Checkpoint 6:


-- RA:
π c.title, r.title (ρc(course) ⋈ c.course_id = p.course_id ρp(prereq) ⋈ p.prereq_id = r.course_id ρr(course))


-- SQL:
select c.title as course_title, r.title as required_title
from prereq p
join course c on p.course_id = c.course_id
join course r on p.prereq_id = r.course_id;


-- Row count: 7


--Genetics	Intro. to Biology
--Computational Biology	Intro. to Biology
--Game Design	Intro. to Computer Science
--Robotics	Intro. to Computer Science
--Image Processing	Intro. to Computer Science
--Database System Concepts	Intro. to Computer Science
--Intro. to Digital Systems	Physical Principles


-- two are needed because course plays 2 roles
-- With only one name, course.title would be ambiguous, and both join conditions
-- would refer to the same row, That forces course_id = prereq_id,
-- meaning a course would have to be its own prerequisite, which returns nothing




-- Checkpoint 7:


--  A ∪ B
-- SQL:
select id
from student
where dept_name = 'Comp. Sci.'
union
select id
from takes
where course_id = 'CS-101';


-- RA:
π ID (σ dept_name = 'Comp. Sci.' (student)) ∪ π ID (σ course_id = 'CS-101' (takes))


--00128
--12345
--45678
--54321
--76543
--98765


-- A ∩ B


-- SQL:
select ID
from student
where dept_name = 'Comp. Sci.'
intersect
select ID
from takes
where course_id = 'CS-101';


-- RA:
π ID (σ dept_name = 'Comp. Sci.' (student)) ∩ π ID (σ course_id = 'CS-101' (takes))


--00128
--12345
--54321
--76543


-- A ∪ B: students are Comp. Sci. majors OR have taken CS-101
-- A ∩ B: students are Comp. Sci. majors AND have taken CS-101
-- Comparing A ∩ B to A:
-- A ∩ B has the same 4 IDs as A, so no Comp. Sci. major is missing from B
-- That means every Comp. Sci. major has taken CS-101




-- Checkpoint 8:


-- B - A


-- SQL:
select ID
from takes
where course_id = 'CS-101'
except
select ID
from student
where dept_name = 'Comp. Sci.';


-- RA:
π ID(σ course_id = 'CS-101' (takes)) − π ID (σ dept_name = 'Comp. Sci.' (student))


-- Row count: 2


-- 45678
-- 98765
-- A - B
-- Prediction: there will be no rows:


-- SQL:
select ID
from student
where dept_name = 'Comp. Sci.'
except
select ID
from takes
where course_id = 'CS-101';


-- Row count: 0


-- RA:


π ID (σ dept_name = 'Comp. Sci.' (student)) − π ID (σ course_id = 'CS-101' (takes))


-- This is because  A ∩ B = A in checkpoint 7, every ID in A is also in B
-- so this leaves nothing




-- Checkpoint 9:


-- RA:
π ID, course_id (takes) ÷ {('CS-101'), ('CS-347')}


-- R ÷ S answers: which students have taken both CS-101 and CS-347?


-- SQL:
select ID
from takes
where course_id in ('CS-101', 'CS-347')
group by ID
having count(distinct course_id) = 2;


--00128
--12345


-- Row count: 2


-- Count(*) counts rows so a student that took cs-101 twice would count as 2
-- without ever taking 347 but count distinct takes only one of the repeated outputs




-- Checkpoint 10:


-- SQL:
select distinct ID
from takes
where course_id in ('CS-101', 'CS-347');


-- RA:
π ID (σ course_id = 'CS-101' (takes)) ∪ π ID (σ course_id = 'CS-347' (takes))


-- Row count: 6


--00128
--12345
--45678
--54321
--76543
--98765


-- Returns 6 IDs vs 2 in Checkpoint 9. It computes union (∪), not ÷
-- or includes students who took at least one of the two classes
-- and requires a student to have taken both classes
-- in on its own only checks each row seperately so it gives or
-- having is what turns it into an and statement




-- Checkpoint 11:


-- π s.name, c.title
--   σ c.dept_name = 'Biology'
--     ⋈ t.course_id = c.course_id
--       ⋈ s.ID = t.ID
--         student (s)
--         takes (t)
--       course (c)




-- Checkpoint 12:


-- A: σ plus π for the columns to show
-- It picks out the rows of instructor where dept_name = 'Physics'


-- RA:
π name (σ dept_name = 'Physics' (instructor))


-- B: π and ∩
-- Projecting both tables down to name makes them compatible, and ∩ keeps
-- only the names that appear in both


-- RA:
π name (student) ∩ π name (instructor)


-- SQL:
select name
from student
intersect
select name
from instructor;


-- Brandt


-- No intersect compares only names not Id's student Brandt and instructor Brandt have different
-- ID's and departments so theyre two different people who happen to share names




set search_path to default;