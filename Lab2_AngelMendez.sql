-- Checkpoint 1:
-- instructor (instructor_id, name, specialty) PK: instructor_id
-- member (member_id, name, email, join_date) PK: member_id
-- fitness_class (class_id, class_name, instructor_id, capacity, day_of_week) PK: class_id
-- booking (member_id, class_id, booking_date, attended) PK: (member_id, class_id, booking_date)
-- 
-- Checkpoint 2:
-- fitness_class.instructor_id to instructor(instructor_id)
-- booking.member_id to member(member_id)
-- booking.class_id to fitness_class(class_id)
-- Extra rule: CHECK (capacity > 0) on fitness_class.
--
create table Instructor (
    instructor_id int generated always as identity primary key,
    name text not null,
    specialty text
);

create table member (
    member_id int generated always as identity primary key,
    name text,
    email text,
    join_date date not null default current_date
);

create table fitness_class (
    class_id int generated always as identity primary key,
    class_name text not null,
    instructor_id int references Instructor(instructor_id),
    capacity int not null,
    day_of_week text
);

-- Checkpoint 5: instructor_id is the foreign key. It points to instructor(instructor_id).

insert into instructor (name, specialty)
values ('Jordan Lee', 'Yoga')
returning instructor_id;

insert into fitness_class (class_name, instructor_id, capacity, day_of_week)
values ('Sunrise Yoga', 1, 20, 'Monday');
 
select * from fitness_class;

-- Checkpoint 7: It works because instructor 1 now exists, so the foreign key is satisfied.
 
create table booking (
    member_id int NOT NULL REFERENCES member (member_id),
    class_id int NOT NULL REFERENCES fitness_class (class_id),
    booking_date date NOT NULL DEFAULT current_date,
    attended boolean NOT NULL DEFAULT false,
    primary key (member_id, class_id, booking_date)
);

-- Checkpoint 8: member_id points to member(member_id) | class_id points to fitness_class(class_id).

alter table member ADD COLUMN phone text;

-- Checkpoint 9: 

alter table fitness_class rename column day_of_week to class_day;

-- Checkpoint 10: 

alter table member alter column email type varchar(255);

-- Checkpoint 11: Yes it could fail if an existing email were longer than 255 characters,
-- because that value wouldn't fit in varchar(255).


insert into member (name, email) values
    ('Priya Shah',   'priya@example.com'),
    ('Ben Ortiz',    'ben@example.com'),
    ('Carla Nguyen', 'carla@example.com');
 
insert into fitness_class (class_name, instructor_id, capacity, class_day)
values ('Power Lifting', 1, -5, 'Wednesday');
 
select * from member;
select * from fitness_class;

-- Checkpoint 12: there is no constraint yet so -5 would be the constraint thats auto set

alter table fitness_class add constraint chk_capacity check (capacity > 0);

-- error

-- Checkpoint 13: 

alter table fitness_class
ADD constraint chk_capacity check (capacity > 0) not valid;
 
insert into fitness_class (class_name, instructor_id, capacity, class_day)
values ('Test Class', 1, -1, 'Friday');

-- Checkpoint 14: NOT VALID skips checking existing rows but still checks new inserts and updates

alter table fitness_class validate constraint chk_capacity;

--- Checkpoint 15:
-- ERROR: check constraint "chk_capacity" of relation "fitness_class" is violated by some row

update fitness_class set capacity = 15 where class_name = 'Power Lifting';
alter table fitness_class validate constraint chk_capacity;
 
select * from fitness_class;

-- Checkpoint 16: On a large table, NOT VALID adds the rule instantly and blocks new bad data





 