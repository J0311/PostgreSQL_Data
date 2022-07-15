/*
* select <project> from <table_name> <filter> <grouping> <ordering> <offset>
* 
* SELECT [ALL | DISTINCT]
    select_expr [, select_expr] ...
    [into_option]
    [FROM table_ref]
    [WHERE where_condition]
    [GROUP BY {col_name | expr | position}]
    [HAVING having_condition]
    [ORDER BY {col_name | expr | position}]
        [ASC | DESC]
    [LIMIT {[offset,] row_count | row_count OFFSET offset}];
*/
select * from my_new_table;

select my_value, my_other_value from my_new_table;

select my_value as value1, my_other_value as value2 from my_new_table;


create table if not EXISTS produce ( id serial primary key, name varchar(20) not null unique, price decimal(3,2), type varchar(10) not null);
insert into produce (name, price, type) values ('navel orange', 1.99, 'citrus'), ('mandarin orange', 0.75, 'citrus'), ('tangerine', 0.50, 'citrus'), ('red delicious', 2.00, 'apple'), ('jona gold', 2.50, 'apple'), ('granny smith', 1.00, 'apple'), ('blueberry', 0.40, 'berry'), ('raspberry', 0.35, 'berry'), ('kiwi', 0.75, 'berry'), ('watermelon', 3.99, 'melon'), ('cantaloupe', 2.99, 'melon'), ('honeydew', 2.00, 'melon'), ('lettuce', 2.99, 'leafy'), ('spinach', 1.99, 'leafy'), ('pumpkin', 4.99, 'marrow'), ('cucumber', 0.99, 'marrow'), ('potato', 0.45, 'root'), ('yam', 0.25, 'root'), ('sweet potato', 0.50, 'root'), ('onion', 0.33, 'allium'), ('garlic', 0.25, 'allium'), ('shallot', 0.60, 'allium');

select * from produce;

/*
 * AND operator
(TRUE AND TRUE) AND (TRUE AND TRUE)	TRUE
(TRUE AND TRUE) AND (FALSE AND FALSE)	false
*/
select name, price, type from produce where type='apple' and price>1.00;


/*
* or operator
* 
*/
select name, price, type from produce where type='citrus' or type='berry';

/*
 * In operator
 *  'cat' in ('cat', 'dog', 'goat')	TRUE
	1 in (100, 25, 17, 10000)	FALSE
 */
select name, price, type from produce where type in ('apple', 'root', 'berry', 'allium');


/*
 * NOT operator
 */
select name, price, type from produce where not (type='apple') and not (type='allium');

/*
 * Like operator

	% (percent)	match any string of zero or more characters
	_ (underscore)	match any single character
 */
select name, price, type from produce where type like 'a%';
select name, price, type from produce where type like '_e%';
select name, price, type from produce where type like '_____';

/*
 * Between
 * 
 */
select name, price, type from produce where price between 0.50 and 1.00;

/*
 * Grouping
 */
select type, avg(price) from produce group by type;

/*
 * Having
 */
select type, avg(price) as group_avg, (select avg(price) from produce) as gross_avg from produce group by type having avg(price) > (select avg(price) from produce);

/* 
 * Ordering
 */
select name, price, type from produce order by name asc;

/*
 * Offset -- Limit
 */
select name, price, type from produce order by name asc limit 5;

/*
 * Offset -- offset
 */
select name, price, type from produce order by name asc limit 5 offset 5;


/*
 * Subquery -- Nested Queries
 */

create table if not exists students(
    id int primary key,
    name varchar(40) not null unique
);
create table if not exists evals (
    id int primary key,
    studentId int not null,
    evalName varchar(10) not null,
    mark int default 0,
    foreign key(studentId) references students(id),
    constraint mark_check check(mark >= 0), check(mark <= 100)
);

insert into students (id, name) values (1, 'Steve'), (2, 'Jane'), (3, 'Casey');
insert into evals (id, studentId, evalName, mark) values (1, 1, 'quiz 1', 98), (2, 2, 'quiz 1', 80), (3, 3, 'quiz 1', 95), (4, 1, 'test 1', 72), (5, 2, 'test 1', 100), (6, 3, 'test 1', 68);

--  find all students that scored higher than Jane (2) on quiz 1.


-- first find Jane's score on quiz 1
select studentId, evalName, mark  from evals where studentId = 2 and evalName = 'quiz 1';

-- second query for all quiz scores greater than Jane's
select studentId, evalName, mark from evals where evalName = 'quiz 1' and mark > 80;

-- Better solution Nested Query
select a.id, a.name, b.evalName, b.mark from students a, evals b where a.id = b.studentId
    and b.evalName = 'quiz 1'
    and b.mark > (select mark from evals where evalName = 'quiz 1' and studentId = 2);
   
   
-- Inline Views
select a.name, b.evalName, b.mark from students a, (select studentId, evalName, mark from evals where mark > 90) b where a.id = b.studentId;

-- Inner Query
select a.id, a.name, (select avg(mark) from evals where studentId = a.id group by studentId) avg from students a;


insert into students (id, name) values (4, 'Mike');
-- Joins

-- Kinds of Joins
-- * LEFT (OUTER) JOIN -- All data from left side, left side replicated to accompany any matching data
							-- right side may be null if there are no matching records
-- * RIGHT (OUTER) JOIN -- Same, but the opposite directionality
-- * FULL OUTER JOIN -- Select all data from both sides replicating as necessary, allowing null values 
-- 							on either side of no matching records are found for a given row
-- * INNER JOIN -- Selects only matching rows, replicated as necessary to show all relationships
-- * CROSS JOIN - Joining all rows to all other rows - Their is no matching clause, everything is joined.
-- * NATURAL JOIN - Joining two tables using equality of like column names as the implicit condition
-- * SELF JOIN - Joining a table to itself
-- * UNEQUAL JOIN - Any join in which the applied condition for joining is not equality


--cross join
select * from students s, evals e;

--inner join
select s.name, e.evalName, e.mark from students s
	join evals e on s.id = e.studentid;

-- left join
select s.name, e.evalName, e.mark from students s
	left join evals e on s.id = e.studentid;

-- right join
select s.name, e.evalName, e.mark from students s
	right join evals e on s.id = e.studentid;
	
	
