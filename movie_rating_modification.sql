/* Q1: Add the reviewer Roger Ebert to your database, with an rID of 209. */

INSERT INTO reviewer
  VALUES (209, 'Roger Ebert');

/* Q2: Insert 5-star ratings by James Cameron for all movies in the database. 
Leave the review date as NULL. */

INSERT INTO rating
  SELECT
    reviewer.rid,
    movie.mid,
    5,
    NULL
  FROM movie,
       reviewer
  WHERE reviewer.name = 'James Cameron';

/* Q3: For all movies that have an average rating of 4 stars or higher, 
add 25 to the release year. 
(Update the existing tuples; don't insert new tuples.) */

UPDATE movie
SET year = year + 25
WHERE mid IN (SELECT
  mid
FROM rating
GROUP BY mid
HAVING AVG(stars) >= 4);

/* Q4: Remove all ratings where the movie's year is before 1970 or after 2000, 
and the rating is fewer than 4 stars. */

DELETE FROM rating
WHERE stars < 4
  AND mid IN (SELECT
    mid
  FROM movie
  WHERE year < 1970
  OR year > 2000);