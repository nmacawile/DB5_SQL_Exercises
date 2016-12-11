/* Q1: It's time for the seniors to graduate. Remove all 12th graders 
from Highschooler. */

DELETE FROM highschooler
WHERE grade = 12;

/* Q2: If two students A and B are friends, and A likes B but not 
vice-versa, remove the Likes tuple. */

DELETE FROM likes
WHERE EXISTS (SELECT
    *
  FROM friend
  WHERE likes.ID1 = friend.ID1
  AND likes.ID2 = friend.ID2)
  AND NOT EXISTS (SELECT
    *
  FROM likes l2
  WHERE l2.ID1 = likes.ID2
  AND l2.ID2 = likes.ID1);

/* Q3: For all cases where A is friends with B, and B is friends with C, 
add a new friendship for the pair A and C. Do not add duplicate friendships, 
friendships that already exist, or friendships with oneself. 
(This one is a bit challenging; congratulations if you get it right.) */

INSERT INTO friend
  SELECT DISTINCT
    h1.id,
    h2.id
  FROM highschooler h1,
       highschooler h2,
       highschooler h3
  WHERE h1.id <> h2.id
  AND NOT EXISTS (SELECT
    *
  FROM friend f1
  WHERE h1.id = f1.id1
  AND h2.id = f1.id2)
  AND EXISTS (SELECT
    *
  FROM friend f3
  WHERE f3.id1 = h1.id
  AND f3.id2 = h3.id)
  AND EXISTS (SELECT
    *
  FROM friend f3
  WHERE f3.id1 = h2.id
  AND f3.id2 = h3.id);