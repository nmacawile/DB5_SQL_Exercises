/* Q1: Find the names of all reviewers who rated Gone with the Wind. */

SELECT DISTINCT
  name
FROM rating,
     movie,
     reviewer
WHERE title = 'Gone with the Wind'
AND movie.mid = rating.mid
AND reviewer.rid = rating.rid;

/* Q2: For any rating where the reviewer is the same as the director of the movie, 
return the reviewer name, movie title, and number of stars. */

SELECT
  name,
  title,
  stars
FROM rating,
     movie,
     reviewer
WHERE rating.rid = reviewer.rid
AND movie.mid = rating.mid
AND name = director;

/* Q3: Return all reviewer names and movie names together in a single list, alphabetized. 
(Sorting by the first name of the reviewer and first word in the title is fine; no need 
for special processing on last names or removing "The".) */

SELECT
  name
FROM reviewer
UNION
SELECT
  title AS name
FROM movie
ORDER BY name;

/* Q4: Find the titles of all movies not reviewed by Chris Jackson. */

SELECT
  title
FROM movie
WHERE mid NOT IN (SELECT
  rating.mid
FROM rating,
     movie,
     reviewer
WHERE reviewer.rid = rating.rid
AND rating.mid = movie.mid
AND name = 'Chris Jackson');

/* Q5: For all pairs of reviewers such that both reviewers gave a rating 
to the same movie, return the names of both reviewers. Eliminate duplicates, 
don't pair reviewers with themselves, and include each pair only once. For each pair, 
return the names in the pair in alphabetical order. */

SELECT DISTINCT
  v1.name AS reviewer1,
  v2.name AS reviewer2
FROM rating r1,
     rating r2,
     reviewer v1,
     reviewer v2
WHERE v1.name < v2.name
AND r1.mid = r2.mid
AND r1.rid = v1.rid
AND r2.rid = v2.rid
ORDER BY reviewer1;

/* Q6: For each rating that is the lowest (fewest stars) currently in the database, 
return the reviewer name, movie title, and number of stars. */

SELECT
  name,
  title,
  stars
FROM rating r1,
     movie,
     reviewer
WHERE NOT EXISTS (SELECT
  stars
FROM rating r2
WHERE r1.stars > r2.stars)
AND r1.rid = reviewer.rid
AND movie.mid = r1.mid
ORDER BY name, title;

/* Q7: List movie titles and average ratings, from highest-rated to lowest-rated. 
If two or more movies have the same average rating, list them in alphabetical order. */

SELECT
  title,
  AVG(stars) AS score
FROM rating,
     movie
WHERE rating.mid = movie.mid
GROUP BY movie.mid
ORDER BY score DESC, title;

/* Q8: Find the names of all reviewers who have contributed three or more ratings. 
(As an extra challenge, try writing the query without HAVING or without COUNT.) */

SELECT DISTINCT
  name
FROM rating r1,
     reviewer
WHERE r1.rid = reviewer.rid
AND EXISTS (SELECT
  *
FROM rating r2
WHERE r1.rid = r2.rid
AND (r1.mid <> r2.mid
OR r1.stars <> r2.stars
OR r1.ratingDate <> r2.ratingDate)
AND EXISTS (SELECT
  *
FROM rating r3
WHERE r3.rid = r2.rid
AND (r3.mid <> r2.mid
OR r3.stars <> r2.stars
OR r3.ratingDate <> r2.ratingDate)
AND (r3.mid <> r1.mid
OR r3.stars <> r1.stars
OR r3.ratingDate <> r1.ratingDate)))
ORDER BY name;

/* Q9: Some directors directed more than one movie. For all such directors, 
return the titles of all movies directed by them, along with the director name. 
Sort by director name, then movie title. (As an extra challenge, try writing 
the query both with and without COUNT.) */

/* Without COUNT */

SELECT
  title,
  director
FROM movie m1
WHERE EXISTS (SELECT
  *
FROM movie m2
WHERE m2.director = m1.director
AND m1.mid <> m2.mid)
ORDER BY director, title;

/* With COUNT */

SELECT
  title,
  director
FROM movie
WHERE director IN (SELECT
  director
FROM movie
GROUP BY director
HAVING COUNT(director) > 1)
ORDER BY director, title;

/* Q10: Find the movie(s) with the highest average rating. Return the movie title(s)
and average rating. (Hint: This query is more difficult to write in SQLite 
than other systems; you might think of it as finding the highest average rating 
and then choosing the movie(s) with that average rating.) */

SELECT
  title,
  AVG(stars) AS score
FROM rating r1,
     movie
WHERE r1.mid = movie.mid
GROUP BY r1.mid
HAVING score = (SELECT
  MAX(score2)
FROM (SELECT
  AVG(stars) AS score2
FROM rating r2
GROUP BY mid) AS maxaverage);


/* Q11: Find the movie(s) with the lowest average rating. Return the movie title(s) 
and average rating. (Hint: This query may be more difficult to write in SQLite than 
other systems; you might think of it as finding the lowest average rating and then 
choosing the movie(s) with that average rating.) */

SELECT
  title,
  AVG(stars) AS score
FROM rating r1,
     movie
WHERE r1.mid = movie.mid
GROUP BY r1.mid
HAVING score = (SELECT
  MIN(score2)
FROM (SELECT
  AVG(stars) AS score2
FROM rating r2
GROUP BY mid) AS minaverage);

/* Q12: For each director, return the director's name together with the title(s) of 
the movie(s) they directed that received the highest rating among all of their movies, 
and the value of that rating. Ignore movies whose director is NULL. */

SELECT DISTINCT
  director,
  title,
  stars
FROM movie m1,
     rating r1
WHERE m1.mid = r1.mid
AND r1.stars = (SELECT
  MAX(stars)
FROM movie m2,
     rating r2
WHERE m2.mid = r2.mid
AND m1.director = m2.director)
ORDER BY director;