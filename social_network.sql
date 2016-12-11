/* Q1: Find the names of all students who are friends with someone named Gabriel. */ 

select h1.name
from friend, highschooler h1, highschooler h2 
where friend.ID1 = h1.ID 
and friend.ID2 = h2.ID
and h2.name = 'Gabriel'
order by h1.name;

/* Q2: For every student who likes someone 2 or more grades younger than themselves, 
return that student's name and grade, and the name and grade of the student they like. */ 

select h1.name, h1.grade, h2.name, h2.grade
from likes, highschooler h1, highschooler h2
where likes.ID1 = h1.ID 
and likes.ID2 = h2.ID
and h1.grade >= h2.grade+2;

/* Q3: For every pair of students who both like each other, return the name and grade 
of both students. Include each pair only once, with the two names in alphabetical order. */

select h1.name, h1.grade, h2.name, h2.grade
from likes l1, likes l2, highschooler h1, highschooler h2 
where l1.ID1 = l2.ID2 
and l2.ID1 = l1.ID2 
and l1.ID1 = h1.ID 
and l1.ID2 = h2.ID
and h1.name < h2.name
order by h1.name;

/* Q4: Find all students who do not appear in the Likes table (as a student who likes or is liked) 
and return their names and grades. Sort by grade, then by name within each grade. */

select name, grade from highschooler 
where ID not in (select ID1 from likes) 
and ID not in (select ID2 from likes)
order by grade, name;

/* Q5: For every situation where student A likes student B, but we have no information about whom B likes 
(that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades. */

select h1.name, h1.grade, h2.name, h2.grade
from likes, highschooler h1, highschooler h2 
where ID2 not in (select ID1 from likes)
and h1.ID = likes.ID1 and h2.ID = likes.ID2
order by h1.name, h2.name;

/* Q6: Find names and grades of students who only have friends in the same grade. Return the result sorted 
by grade, then by name within each grade. */

select name, grade 
from highschooler 
where ID not in
(select friend.ID1
from friend, highschooler h1, highschooler h2 
where friend.ID1 = h1.ID and friend.ID2 = h2.ID 
and h1.grade <> h2.grade)
order by grade, name;

/* Q7: For each student A who likes a student B where the two are not friends, find if they have a friend C 
in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C. */

SELECT distinct h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade
FROM likes, friend f1, highschooler h1, highschooler h2, highschooler h3
where likes.ID1 = h1.ID and likes.ID2 = h2.ID
and f1.ID1 = h3.ID
and not exists 
(select * 
from friend f2 
where likes.ID1 = f2.ID1 
and likes.ID2 = f2.ID2)
and exists 
(select * from friend f2 where f2.ID1 = f1.ID1 and f2.ID2 = h1.ID)
and exists
(select * from friend f2 where f2.ID1 = f1.ID1 and f2.ID2 = h2.ID)
;

/* Q8: Find the difference between the number of students in the school and the number 
of different first names. */

select count(*) - count(distinct name) as diff from highschooler;

/* Q9: Find the name and grade of all students who are liked by more than one other student. */

select name, grade 
from likes, highschooler 
where ID2 = ID 
group by ID2 
having count(ID2) > 1
order by name;