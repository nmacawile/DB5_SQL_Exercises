/* Q1: For every situation where student A likes student B, but student B 
likes a different student C, return the names and grades of A, B, and C. */

SELECT
  h1.name,
  h1.grade,
  h2.name,
  h2.grade,
  h3.name,
  h3.grade
FROM likes l1,
     likes l2,
     highschooler h1,
     highschooler h2,
     highschooler h3
WHERE l1.ID1 = h1.ID
AND l1.ID2 = h2.ID
AND l2.ID2 = h3.ID
AND l1.ID2 = l2.ID1
AND l2.ID2 <> l1.ID1;

/* Q2: Find those students for whom all of their friends are in different 
grades from themselves. Return the students' names and grades. */

SELECT
  h.name,
  h.grade
FROM highschooler h
WHERE NOT EXISTS (SELECT
  *
FROM friend,
     highschooler h1,
     highschooler h2
WHERE friend.ID1 = h1.ID
AND friend.ID2 = h2.ID
AND h.ID = friend.ID1
AND h.grade = h2.grade);

/* Q3: What is the average number of friends per student? (Your result 
should be just one number.) */

SELECT
  ((SELECT
    COUNT(*)
  FROM friend)
  * 1.0 / (SELECT
    COUNT(*)
  FROM highschooler)
  * 1.0) AS average;

/* Q4: Find the number of students who are either friends with Cassandra 
or are friends of friends of Cassandra. Do not count Cassandra, even though 
technically she is a friend of a friend. */

SELECT
  COUNT(*)
FROM (SELECT
  *
FROM friend f,
     highschooler h
WHERE f.ID1 = h.ID
AND h.name = 'Cassandra'
UNION
SELECT
  *
FROM friend f,
     highschooler h
WHERE f.ID1 = h.ID
AND ID2 IN (SELECT
  f1.ID2
FROM friend f1,
     highschooler h1
WHERE f1.ID1 = h1.ID
AND h1.name = 'Cassandra')
AND h.name <> 'Cassandra') AS dtable;

/* Q5: Find the name and grade of the student(s) with the greatest 
number of friends. */

SELECT
  name,
  grade
FROM (SELECT
       ID1,
       COUNT(ID1) AS friendcount
     FROM friend
     GROUP BY ID1) AS a,
     highschooler
WHERE friendcount >= (SELECT
  MAX(friendcount)
FROM (SELECT
  ID1,
  COUNT(ID1) AS friendcount
FROM friend
GROUP BY ID1) AS b)
AND ID = ID1;