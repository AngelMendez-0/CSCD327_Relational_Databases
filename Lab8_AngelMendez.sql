set search_path to "$user";

-- Checkpoint 1:

insert into department (dept_name, building, budget)
values('Env. Sci.', 'Watson', 75000);

-- 1 row

insert into instructor (ID, name, dept_name, salary)
values ('99999', 'Ada Lovelace', 'Env. Sci.', 78000);

-- 1 row

insert into instructor (ID, name, dept_name, salary)
values ('99998', 'Ada Lovelace', 'Marine Biology', 78000);

-- ERROR: insert or update on table "instructor" violates foreign key constraint "instructor_dept_name_fkey"
-- Detail: Key (dept_name)=(Marine Biology) is not present in table "department".

-- The foreign key constraint instructor_dept_name_fkey rejected it because there is no department named "Marine Biology"


-- Checkpoint 2:

create table never_offered_spring(
course_id varchar(8),
title varchar(50)
);

select * from never_offered_spring;

-- 0 rows

insert into never_offered_spring
select course_id, title
from course
where course_id not in (select course_id from section where semester = 'Spring');

select * from never_offered_spring;

-- 5 rows


-- Checkpoint 3:

-- A:

select count(*) as affected_students
from student
where dept_name = 'Biology';

-- 1 student

update student
set tot_cred = tot_cred + 5
where dept_name = 'Biology';

-- 1 row

select name, tot_cred from student
where dept_name = 'Biology';

--Tanaka	125

-- B:

update course
set title = 'Computer Vision',
credits = 4
where course_id  = 'CS-319';

-- 1 row

select * from course where course_id = 'CS-319';

--CS-319	Computer Vision	Comp. Sci.	4


-- Checkpoint 4:

-- A:
select avg(salary) as avg_salary from instructor;

-- 75076.92

-- B:

select count(*) as affected_instructors
from instructor
where salary < (select avg(salary) from instructor);

-- 6 rows

update instructor
set salary = salary * 1.05
where salary < (select avg(salary) from instructor);

-- 6 rows

-- C:

select avg(salary) as new_avg from instructor;

-- New average: 76515.38


-- Checkpoint 5:

select count(*) as affected_instructors
from instructor, department
where instructor.dept_name = department.dept_name
  and department.budget > 80000;

-- 7 instructors

update instructor
set salary = salary + 1000
from department
where instructor.dept_name = department.dept_name
and department.budget > 80000;

-- 7 rows affected


-- Checkpoint 6:

select count(*) as teaches_rows
from teaches
where course_id = 'CS-190' and sec_id = '2'
and semester = 'Spring' and year = 2017;

-- 1 row

select count(*) as takes_rows
from takes
where course_id = 'CS-190' and sec_id = '2'
and semester = 'Spring' and year = 2017;

-- 2 rows

delete from section
where course_id = 'CS-190' and sec_id = '2'
and semester = 'Spring' and year = 2017;

-- 1 row affected

select count(*) as teaches_rows
from teaches
where course_id = 'CS-190' and sec_id = '2'
and semester = 'Spring' and year = 2017;

-- 0 rows

select count(*) as takes_rows
from takes
where course_id = 'CS-190' and sec_id = '2'
and semester = 'Spring' and year = 2017;

-- 0 rows

-- teaches and takes both have a foreign key to section with on delete cascade,
-- so deleting the section automatically deleted the teaches and takes rows that referenced it


-- Checkpoint 7:
select count(*) as affected_rows
from takes, student
where takes.id = student.ID
and student.dept_name = 'Physics'
and takes.grade = 'F';

-- 1 row


delete from takes
using student
where takes.id = student.ID
and student.dept_name = 'Physics'
and takes.grade = 'F';

-- 1 row affected


-- Checkpoint 8:

-- 1.
insert into course values ('CS-988', 'Bad Creds', 'Comp. Sci.', -3);

-- ERROR: new row for relation "course" violates check constraint "course_credits_check"
--  Detail: Failing row contains (CS-988, Bad Creds, Comp. Sci., -3).
-- Constraint type: CHECK

-- 2.

insert into instructor values ('222', null, 'Comp. Sci.', 78000);

-- ERROR: null value in column "name" of relation "instructor" violates not-null constraint
--  Detail: Failing row contains (222, null, Comp. Sci., 78000.00).
-- Constraint type: NOT NULL

-- 3.

insert into course values ('XYZ-101', 'Ghost Course', 'Astrology', 3);

-- ERROR: insert or update on table "course" violates foreign key constraint "course_dept_name_fkey"
--  Detail: Key (dept_name)=(Astrology) is not present in table "department".
-- Constraint type: FOREIGN KEY


-- Checkpoint 9:

alter table takes
add constraint chk_valid_grade
check (grade in ('A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-',
'D+', 'D', 'D-', 'F'));

select * from takes
where grade not in ('A','A-','B+','B','B-','C+','C','C-','D+','D','D-','F');

insert into takes values ('76653', 'CS-347', '1', 'Fall', 2017, 'Z');

-- ERROR: new row for relation "takes" violates check constraint "chk_valid_grade"
--  Detail: Failing row contains (76653, CS-347, 1, Fall, 2017, Z).

-- If takes already had a row with grade 'Z', the alter table would have failed with an error
-- and the constraint would not have been added


-- Checkpoint 10:

select course_id, title, dept_name from course where dept_name = 'Music';

-- MU-199	Music Video Production	Music

select ID, name, dept_name from instructor where dept_name = 'Music';

--15151	Mozart	Music

select ID, name, dept_name from student where dept_name = 'Music';

--55739	Sanchez	Music

-- Prediction: none of these rows will be deleted and the department will be set to null

delete from department where dept_name = 'Music';

-- 1 row affected

select course_id, title, dept_name from course where course_id = 'MU-199';
--MU-199	Music Video Production null

select ID, name, dept_name from instructor where ID = '15151';
-- 15151  Mozart  null

select ID, name, dept_name from student where ID = '55739';
-- 55739  Sanchez  null

select count(*) from course where dept_name = 'Music';      -- 0
select count(*) from instructor where dept_name = 'Music';  -- 0
select count(*) from student where dept_name = 'Music';     -- 0

-- No rows still point to Music

-- courses, instructors, and students can still exist without a department
-- and deleting them would lose real records like grades, so set null keeps them
-- A section can't exist without its course so when a course is deleted its sections are deleted too with cascade

-- Checkpoint 11:

-- A:
select count(*) from section where course_id = 'CS-101';
-- 2

select count(*) from teaches where course_id = 'CS-101';
-- 2

select count(*) from takes where course_id = 'CS-101';
-- 6

select course_id from prereq where prereq_id = 'CS-101';
-- CS-190, CS-315, CS-319, CS-347


-- B:
delete from course where course_id = 'CS-101';

--ERROR:  update or delete on table "course" violates foreign key constraint "prereq_prereq_id_fkey" on table "prereq"
--DETAIL:  Key (course_id)=(CS-101) is still referenced from table "prereq".

-- the foreign key prereq_prereq_id_fkey  blocked it
-- it has no on delete so its rule is the default to nothing


-- Checkpoint 12:

begin;

delete from section;

select count(*) as section_rows from section;
select count(*) as teaches_rows from teaches;
select count(*) as takes_rows   from takes;

-- Inside the transaction:
-- section 0
-- teaches 0
-- takes 0

rollback;

select count(*) as section_rows from section;
select count(*) as teaches_rows from teaches;
select count(*) as takes_rows   from takes;

-- After rollback:
-- section 14
-- teaches 14
-- takes 19

-- it was safe cause nothing inside the transaction was permanent until commit,
-- and rollback undid the delete and all of its cascades


-- Checkpoint 13:

-- A:

select dept_name, budget
from department
where dept_name IN ('History', 'Physics');

-- History	50000.00
-- Physics	70000.00
-- Total: 120000.00

-- B:
begin;

update department
set budget = budget - 3000
where dept_name = 'History';
-- 1 change

update department
set budget = budget + 3000
where dept_name = 'Physics';
-- 1 change

-- C:
select dept_name, budget
from department
where dept_name in ('History', 'Physics');
-- History | 47000.00
-- Physics | 73000.00
-- Total: 120000.00

-- yes, each budget changed by exactly 3000 and the total is still 120000.00 the same as before

-- D:
commit;

-- I chose commit because both checks passed