/* Q1: Find the titles of all movies directed by Steven Spielberg. */
select title 
from movie 
where director = 'Steven Spielberg';

/* Q2: Find all years that have a movie that received a rating of 4 or 5, and sort them 
in increasing order. */
select distinct year
from movie, rating
where movie.mid = rating.mid 
and (stars = 4 or stars = 5)
order by year;

/* Q3: Find the titles of all movies that have no ratings.*/
select title from movie 
where mid not in (select mid from rating);

/* Q4: Some reviewers didn't provide a date with their rating. Find the names of all 
reviewers who have ratings with a NULL value for the date. */
select name 
from reviewer 
where rid in 
(select rid 
from rating 
where ratingDate is null);

/* Q5: Write a query to return the ratings data in a more readable format: reviewer name, 
movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, 
then by movie title, and lastly by number of stars. */
select name, title, stars, ratingDate 
from rating, movie, reviewer 
where movie.mid = rating.mid 
and rating.rid = reviewer.rid 
order by name, title, stars;

/* Q6: For all cases where the same reviewer rated the same movie twice and gave it a higher
rating the second time, return the reviewer's name and the title of the movie. */
select name, title
from rating r1, movie, reviewer 
where r1.rid in 
(select rid 
from rating r2 
where r1.mid = r2.mid 
and r2.stars>r1.stars 
and r2.ratingDate>r1.ratingDate)
and r1.rid = reviewer.rid 
and movie.mid = r1.mid;

/* Q7: For each movie that has at least one rating, find the highest number of stars that 
movie received. Return the movie title and number of stars. Sort by movie title. */
select title, max(stars) as stars 
from rating r1, movie 
where r1.mid = movie.mid 
group by movie.mid order by title;

/* Q8: For each movie, return the title and the 'rating spread', that is, the difference 
between highest and lowest ratings given to that movie. Sort by rating spread 
from highest to lowest, then by movie title. */
select title, (max(stars)-min(stars)) as rating_spread
from movie, rating where movie.mid = rating.mid 
group by movie.mid 
order by rating_spread desc, title;


/* Q9: Find the difference between the average rating of movies released before 1980 
and the average rating of movies released after 1980. (Make sure to calculate 
the average rating for each movie, then the average of those averages for movies before 1980 
and movies after. Don't just calculate the overall average rating before and after 1980.) */
select  
(select avg(average) 
	from (select avg(stars) as average 
		from rating, movie 
		where rating.mid = movie.mid 
		and year < 1980 
		group by movie.mid) as pre1980)-
(select avg(average) 
	from (select avg(stars) 
		as average from rating, movie 
		where rating.mid = movie.mid 
		and year > 1980 
		group by movie.mid) as post1980) as difference;
