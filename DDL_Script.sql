-- SQL script using DDL <Data Definition Language>

-- here we create new database:

create database library;

create table if not exists books(

-- here we insert column names, datatypes, constraints, etc.

id int primary key,
title varchar(100) not null,
author varchar(50) not null
);

alter table books add column publication_date timestamp not null;

alter table books add constraint title_unique unique (title);

-- DML commands

-- inserting books into our books table:

insert into books (id, title, author) values (1, 'Deep Work', 'Cal Newport published 01-01-16'), 
(2, 'Hard Times Create Strong Men', 'Stefan Aarnio published 01-01-18'),
(3, 'Be Obsessed Or Be Average', 'Grant Cardone published 01-01-16');

-- next we insert a book for forgot initially:		

insert into books (id, title, author) values (4, 'Learn SQL in a Snap', 'Jim Dandy published 01-01-01');

-- Modifying author of the first book inserted into our database table

update books set author = 'Cal published 01-01-16' where id = 1;

-- Now, we DELETE tuples<records> 2 & 3

delete from books where id = 2;
delete from books where id = 3;

