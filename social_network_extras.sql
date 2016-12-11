/* Q1: For every situation where student A likes student B, but student B 
likes a different student C, return the names and grades of A, B, and C. */

SELECT h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade
FROM likes l1, likes l2,
highschooler h1, highschooler h2, highschooler h3
where l1.ID1 = h1.ID and l1.ID2 = h2.ID and l2.ID2 = h3.ID 
and l1.ID2 = l2.ID1 and l2.ID2 <> l1.ID1;

/* Q2: Find those students for whom all of their friends are in different 
grades from themselves. Return the students' names and grades. */

select h.name, h.grade from highschooler h 
where not exists 
(select * from friend, highschooler h1, highschooler h2 
where friend.ID1 = h1.ID 
and friend.ID2 = h2.ID and h.ID = friend.ID1 
and h.grade=h2.grade);

/* Q3: What is the average number of friends per student? (Your result 
should be just one number.) */

select ((select count(*) from friend) * 1.0 / 
	(select count(*) from highschooler) * 1.0) as average

/* Q4: Find the number of students who are either friends with Cassandra 
or are friends of friends of Cassandra. Do not count Cassandra, even though 
technically she is a friend of a friend. */

select count(*) from (
select *
from friend f, highschooler h
where f.ID1 = h.ID
and h.name = 'Cassandra'
union
select *
from friend f, highschooler h
where f.ID1 = h.ID and ID2 in 
(select f1.ID2
from friend f1, highschooler h1
where f1.ID1 = h1.ID
and h1.name = 'Cassandra')
and h.name <> 'Cassandra') as dtable
;

/* Q5: Find the name and grade of the student(s) with the greatest 
number of friends. */

select name, grade 
from (select ID1, count(ID1) as friendcount 
from friend 
group by ID1) as a, highschooler
where friendcount >= 
(select max(friendcount) 
	from (select ID1, count(ID1) as friendcount 
from friend group by ID1) as b)
and ID = ID1;
