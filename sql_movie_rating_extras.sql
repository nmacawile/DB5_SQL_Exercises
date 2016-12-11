/* Q1: Find the names of all reviewers who rated Gone with the Wind. */
select distinct name 
from rating, movie, reviewer 
where title = 'Gone with the Wind' 
and movie.mid = rating.mid 
and reviewer.rid = rating.rid;

/* Q2: For any rating where the reviewer is the same as the director of the movie, 
return the reviewer name, movie title, and number of stars. */
select name, title, stars 
from rating, movie, reviewer
where rating.rid = reviewer.rid 
and movie.mid = rating.mid 
and name = director;

/* Q3: Return all reviewer names and movie names together in a single list, alphabetized. 
(Sorting by the first name of the reviewer and first word in the title is fine; no need 
for special processing on last names or removing "The".) */
select name 
from reviewer union
select title as name 
from movie 
order by name;

/* Q4: Find the titles of all movies not reviewed by Chris Jackson. */
select title 
from movie 
where mid not in 
(select rating.mid 
	from rating, movie, reviewer 
	where reviewer.rid = rating.rid 
	and rating.mid = movie.mid 
	and name = 'Chris Jackson');

/* Q5: For all pairs of reviewers such that both reviewers gave a rating 
to the same movie, return the names of both reviewers. Eliminate duplicates, 
don't pair reviewers with themselves, and include each pair only once. For each pair, 
return the names in the pair in alphabetical order. */
select distinct v1.name as reviewer1, v2.name as reviewer2 
from rating r1, rating r2, reviewer v1, reviewer v2 
where v1.name < v2.name 
and r1.mid = r2.mid 
and r1.rid = v1.rid 
and r2.rid = v2.rid
order by reviewer1;

/* Q6: For each rating that is the lowest (fewest stars) currently in the database, 
return the reviewer name, movie title, and number of stars. */
select name, title, stars 
from rating r1, movie, reviewer 
where not exists 
(select stars 
	from rating r2 
	where r1.stars > r2.stars) 
and r1.rid = reviewer.rid 
and movie.mid = r1.mid
order by name, title;

/* Q7: List movie titles and average ratings, from highest-rated to lowest-rated. 
If two or more movies have the same average rating, list them in alphabetical order. */
select title, avg(stars) as score 
from rating, movie 
where rating.mid = movie.mid 
group by movie.mid 
order by score desc, title;

/* Q8: Find the names of all reviewers who have contributed three or more ratings. 
(As an extra challenge, try writing the query without HAVING or without COUNT.) */
select distinct name from rating r1, reviewer 
where r1.rid = reviewer.rid
and exists 
(select * from rating r2 where r1.rid = r2.rid
	and (r1.mid <> r2.mid or r1.stars <> r2.stars or r1.ratingDate <> r2.ratingDate)
	and exists 
	(select * from rating r3 
		where r3.rid = r2.rid 
		and (r3.mid <> r2.mid or r3.stars <> r2.stars or r3.ratingDate <> r2.ratingDate)
		and (r3.mid <> r1.mid or r3.stars <> r1.stars or r3.ratingDate <> r1.ratingDate)
	)
)
order by name;

/* Q9: Some directors directed more than one movie. For all such directors, 
return the titles of all movies directed by them, along with the director name. 
Sort by director name, then movie title. (As an extra challenge, try writing 
the query both with and without COUNT.) */
/* Without COUNT */
select title, director 
from movie m1 
where exists 
(select * 
	from movie m2 
	where m2.director = m1.director 
	and m1.mid <> m2.mid
)
order by director, title;
/* With COUNT */
select title, director 
from movie 
where director in
(select director 
	from movie 
	group by director 
	having count(director) > 1)
order by director, title;

/* Q10: Find the movie(s) with the highest average rating. Return the movie title(s)
and average rating. (Hint: This query is more difficult to write in SQLite 
than other systems; you might think of it as finding the highest average rating 
and then choosing the movie(s) with that average rating.) */
select title, avg(stars) as score
from rating r1, movie 
where r1.mid = movie.mid
group by r1.mid
having score = 
(select max(score2) 
	from (select avg(stars) as score2 
		from rating r2 
		group by mid));

/* Q11: Find the movie(s) with the lowest average rating. Return the movie title(s) 
and average rating. (Hint: This query may be more difficult to write in SQLite than 
other systems; you might think of it as finding the lowest average rating and then 
choosing the movie(s) with that average rating.) */
select title, avg(stars) as score
from rating r1, movie 
where r1.mid = movie.mid
group by r1.mid
having score = (select min(score2) 
	from (select avg(stars) as score2 
		from rating r2 
		group by mid));

/* Q12: For each director, return the director's name together with the title(s) of 
the movie(s) they directed that received the highest rating among all of their movies, 
and the value of that rating. Ignore movies whose director is NULL. */
select distinct director, title, stars
from movie m1, rating r1 
where m1.mid = r1.mid 
and r1.stars = 
(select max(stars) 
	from movie m2, rating r2 
	where m2.mid = r2.mid
	and m1.director = m2.director)
order by director;