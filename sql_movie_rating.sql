/* Q1: Find the titles of all movies directed by Steven Spielberg. */

SELECT
  title
FROM movie
WHERE director = 'Steven Spielberg';

/* Q2: Find all years that have a movie that received a rating of 4 or 5, and sort them 
in increasing order. */

SELECT DISTINCT
  year
FROM movie,
     rating
WHERE movie.mid = rating.mid
AND (stars = 4
OR stars = 5)
ORDER BY year;

/* Q3: Find the titles of all movies that have no ratings.*/

SELECT
  title
FROM movie
WHERE mid NOT IN (SELECT
  mid
FROM rating);

/* Q4: Some reviewers didn't provide a date with their rating. Find the names of all 
reviewers who have ratings with a NULL value for the date. */

SELECT
  name
FROM reviewer
WHERE rid IN (SELECT
  rid
FROM rating
WHERE ratingDate IS NULL);

/* Q5: Write a query to return the ratings data in a more readable format: reviewer name, 
movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, 
then by movie title, and lastly by number of stars. */

SELECT
  name,
  title,
  stars,
  ratingDate
FROM rating,
     movie,
     reviewer
WHERE movie.mid = rating.mid
AND rating.rid = reviewer.rid
ORDER BY name, title, stars;

/* Q6: For all cases where the same reviewer rated the same movie twice and gave it a higher
rating the second time, return the reviewer's name and the title of the movie. */

SELECT
  name,
  title
FROM rating r1,
     movie,
     reviewer
WHERE r1.rid IN (SELECT
  rid
FROM rating r2
WHERE r1.mid = r2.mid
AND r2.stars > r1.stars
AND r2.ratingDate > r1.ratingDate)
AND r1.rid = reviewer.rid
AND movie.mid = r1.mid;

/* Q7: For each movie that has at least one rating, find the highest number of stars that 
movie received. Return the movie title and number of stars. Sort by movie title. */

SELECT
  title,
  MAX(stars) AS stars
FROM rating r1,
     movie
WHERE r1.mid = movie.mid
GROUP BY movie.mid
ORDER BY title;

/* Q8: For each movie, return the title and the 'rating spread', that is, the difference 
between highest and lowest ratings given to that movie. Sort by rating spread 
from highest to lowest, then by movie title. */

SELECT
  title,
  (MAX(stars) - MIN(stars)) AS rating_spread
FROM movie,
     rating
WHERE movie.mid = rating.mid
GROUP BY movie.mid
ORDER BY rating_spread DESC, title;

/* Q9: Find the difference between the average rating of movies released before 1980 
and the average rating of movies released after 1980. (Make sure to calculate 
the average rating for each movie, then the average of those averages for movies before 1980 
and movies after. Don't just calculate the overall average rating before and after 1980.) */

SELECT (SELECT
    AVG(average)
  FROM (SELECT
    AVG(stars) AS average
  FROM rating,
       movie
  WHERE rating.mid = movie.mid
  AND year < 1980
  GROUP BY movie.mid) AS pre1980)
  - (SELECT
    AVG(average)
  FROM (SELECT
    AVG(stars)
    AS average
  FROM rating,
       movie
  WHERE rating.mid = movie.mid
  AND year > 1980
  GROUP BY movie.mid) AS post1980)
  AS difference;