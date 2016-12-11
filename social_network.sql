/* Q1: Find the names of all students who are friends with someone named Gabriel. */

SELECT
  h1.name
FROM friend,
     highschooler h1,
     highschooler h2
WHERE friend.ID1 = h1.ID
AND friend.ID2 = h2.ID
AND h2.name = 'Gabriel'
ORDER BY h1.name;

/* Q2: For every student who likes someone 2 or more grades younger than themselves, 
return that student's name and grade, and the name and grade of the student they like. */

SELECT
  h1.name,
  h1.grade,
  h2.name,
  h2.grade
FROM likes,
     highschooler h1,
     highschooler h2
WHERE likes.ID1 = h1.ID
AND likes.ID2 = h2.ID
AND h1.grade >= h2.grade + 2;

/* Q3: For every pair of students who both like each other, return the name and grade 
of both students. Include each pair only once, with the two names in alphabetical order. */

SELECT
  h1.name,
  h1.grade,
  h2.name,
  h2.grade
FROM likes l1,
     likes l2,
     highschooler h1,
     highschooler h2
WHERE l1.ID1 = l2.ID2
AND l2.ID1 = l1.ID2
AND l1.ID1 = h1.ID
AND l1.ID2 = h2.ID
AND h1.name < h2.name
ORDER BY h1.name;

/* Q4: Find all students who do not appear in the Likes table (as a student who likes or is liked) 
and return their names and grades. Sort by grade, then by name within each grade. */

SELECT
  name,
  grade
FROM highschooler
WHERE ID NOT IN (SELECT
  ID1
FROM likes)
AND ID NOT IN (SELECT
  ID2
FROM likes)
ORDER BY grade, name;

/* Q5: For every situation where student A likes student B, but we have no information about whom B likes 
(that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades. */

SELECT
  h1.name,
  h1.grade,
  h2.name,
  h2.grade
FROM likes,
     highschooler h1,
     highschooler h2
WHERE ID2 NOT IN (SELECT
  ID1
FROM likes)
AND h1.ID = likes.ID1
AND h2.ID = likes.ID2
ORDER BY h1.name, h2.name;

/* Q6: Find names and grades of students who only have friends in the same grade. Return the result sorted 
by grade, then by name within each grade. */

SELECT
  name,
  grade
FROM highschooler
WHERE ID NOT IN (SELECT
  friend.ID1
FROM friend,
     highschooler h1,
     highschooler h2
WHERE friend.ID1 = h1.ID
AND friend.ID2 = h2.ID
AND h1.grade <> h2.grade)
ORDER BY grade, name;

/* Q7: For each student A who likes a student B where the two are not friends, find if they have a friend C 
in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C. */

SELECT DISTINCT
  h1.name,
  h1.grade,
  h2.name,
  h2.grade,
  h3.name,
  h3.grade
FROM likes,
     friend f1,
     highschooler h1,
     highschooler h2,
     highschooler h3
WHERE likes.ID1 = h1.ID
AND likes.ID2 = h2.ID
AND f1.ID1 = h3.ID
AND NOT EXISTS (SELECT
  *
FROM friend f2
WHERE likes.ID1 = f2.ID1
AND likes.ID2 = f2.ID2)
AND EXISTS (SELECT
  *
FROM friend f2
WHERE f2.ID1 = f1.ID1
AND f2.ID2 = h1.ID)
AND EXISTS (SELECT
  *
FROM friend f2
WHERE f2.ID1 = f1.ID1
AND f2.ID2 = h2.ID);

/* Q8: Find the difference between the number of students in the school and the number 
of different first names. */

SELECT
  COUNT(*) - COUNT(DISTINCT name) AS diff
FROM highschooler;

/* Q9: Find the name and grade of all students who are liked by more than one other student. */

SELECT
  name,
  grade
FROM likes,
     highschooler
WHERE ID2 = ID
GROUP BY ID2
HAVING COUNT(ID2) > 1
ORDER BY name;