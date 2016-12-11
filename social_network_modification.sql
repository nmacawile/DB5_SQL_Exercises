/* Q1: It's time for the seniors to graduate. Remove all 12th graders 
from Highschooler. */

delete FROM highschooler 
where grade = 12;

/* Q2: If two students A and B are friends, and A likes B but not 
vice-versa, remove the Likes tuple. */

delete from likes 
where exists 
(select * from friend 
where likes.ID1 = friend.ID1 
and likes.ID2 = friend.ID2)
and not exists 
(select * from likes l2 
where l2.ID1 = likes.ID2 
and l2.ID2 = likes.ID1);

/* Q3: For all cases where A is friends with B, and B is friends with C, 
add a new friendship for the pair A and C. Do not add duplicate friendships, 
friendships that already exist, or friendships with oneself. 
(This one is a bit challenging; congratulations if you get it right.) */

insert into friend
select distinct h1.id, h2.id from highschooler h1, highschooler h2, highschooler h3 
where h1.id <> h2.id
and not exists 
(select * from friend f1 where h1.id = f1.id1 and h2.id = f1.id2)
and exists (select * from friend f3 where f3.id1 = h1.id and f3.id2 = h3.id)
and exists (select * from friend f3 where f3.id1 = h2.id and f3.id2 = h3.id);
