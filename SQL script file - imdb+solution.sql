USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT 
    COUNT(*) AS Total_rows_director_mapping
FROM
    director_mapping;
-- Total number of rows in director_mapping table = 3867

SELECT 
    COUNT(*) AS Total_rows_genre
FROM
    genre;
-- Total number of rows in genre table = 14662

SELECT 
    COUNT(*) AS Total_rows_movie
FROM
    movie;
-- Total number of rows in movie table = 7997

SELECT 
    COUNT(*) AS Total_rows_names
FROM
    names;
-- Total number of rows in names table = 25735

SELECT 
    COUNT(*) AS Total_rows_ratings
FROM
    ratings;
-- Total number of rows in ratings table = 7997

SELECT 
    COUNT(*) AS Total_rows_role_mapping
FROM
    role_mapping;
-- Total number of rows in role_mapping table = 15615




-- Q2. Which columns in the movie table have null values?
-- Type your code below:

/* The movie table contains:
id, title, year, date_published, duration, country, worldwide_gross_income, 
languages and production_company columns so we need to check for null in all of them. */

SELECT 
    SUM(CASE WHEN id             		IS NULL THEN 1 ELSE 0 END) AS null_in_id,
    SUM(CASE WHEN title          		IS NULL THEN 1 ELSE 0 END) AS null_in_title,
    SUM(CASE WHEN year           		IS NULL THEN 1 ELSE 0 END) AS null_in_year,
    SUM(CASE WHEN date_published 		IS NULL THEN 1 ELSE 0 END) AS null_in_published,
    SUM(CASE WHEN duration       		IS NULL THEN 1 ELSE 0 END) AS null_in_duration,
    SUM(CASE WHEN country 		 		IS NULL THEN 1 ELSE 0 END) AS null_in_country,
    SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS null_in_worlwide_gross_income,
    SUM(CASE WHEN languages 			IS NULL THEN 1 ELSE 0 END) AS null_in_languages,
    SUM(CASE WHEN production_company 	IS NULL THEN 1 ELSE 0 END) AS null_in_production_company
FROM
    movie;

-- Answer: The columns-> country (20), worlwide_gross_income(3724), languages(194), production_company(528) have null values.



-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- part 1: total number of movies released each year
SELECT 
    Year, 
    COUNT(ID) AS number_of_movies
FROM
    movie
GROUP BY Year;

/* In 2017, 3052 movies were released
   In 2018,	2944 movies were released
   In 2019,	2001 movies were released */

-- part 2: month wise trend
SELECT 
    MONTH(date_published) AS month_num,
    COUNT(ID) number_of_movies
FROM
    movie
GROUP BY MONTH(date_published)
ORDER BY MONTH(date_published); 

/* From the above obtained results we can say that the higest number of movies were 
produced in the month of March. Evry year between 2017 to 2019 there has been decrease in number of movie release */




/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT 
    COUNT(ID) AS movie_count_USA_INDIA, Year
FROM
    movie
WHERE  ( country LIKE '%INDIA%'
		OR country LIKE '%USA%' )
		AND Year = 2019;
-- In the year 2019, 1059 movies were produced either in USA or INDIA.



/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT 
		DISTINCT (genre) AS unique_genres
FROM
    genre;

/* Output: The list of genre is: 
				Drama, Fantasy, Thriller, Comedy, Horror, Family, Romance, Adventure,
				Action, Sci-Fi, Crime, Mystery and Others (can be called miscellaneous category) */



/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT 
    genre, COUNT(m.ID) AS Higest__movie_count
FROM
    genre AS g
        INNER JOIN
    movie AS m ON g.movie_id = m.id
GROUP BY genre
ORDER BY COUNT(m.ID) DESC
LIMIT 1;

-- The genre "Drama" produced highest number (4285) of movies overall.

SELECT genre, COUNT(movie_id) as Higest_movie_count
FROM genre
GROUP BY genre
ORDER BY COUNT(movie_id) DESC
LIMIT 1;
-- The genre "Drama" produced highest number (4285) of movies overall.


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH one_genre_movie_count AS 
							(SELECT COUNT(movie_id) AS movie_count
							FROM genre
							GROUP BY movie_id
							HAVING COUNT(DISTINCT genre) = 1)
SELECT COUNT(*) AS one_genre_movie_count
FROM one_genre_movie_count;

-- 3289 movies belong to only one Genre.


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    genre, ROUND(AVG(duration),2) AS avg_duration
FROM
    genre g
	INNER JOIN
    movie m ON g.movie_id = m.id
GROUP BY genre
ORDER BY ROUND(AVG(duration),2) DESC;

/* 
The genre Action has higest duration (112.88) and horror has least avg_duration (92.72)
*/




/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
WITH thriller_rank AS (
			SELECT genre, COUNT(movie_id) AS movie_count,
			DENSE_RANK () OVER(ORDER BY COUNT(movie_id) DESC) AS genre_rank
			FROM genre
			GROUP BY genre)
SELECT * 
FROM thriller_rank
WHERE genre = "Thriller";

-- output: The rank of "Thriller" genre is 3 in terms of movies produced (1484 movies are of Thriller genre)



/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT ROUND(MIN(avg_rating)) AS min_avg_rating,
	   ROUND(MAX(avg_rating)) AS max_avg_rating,
	   MIN(total_votes) AS min_total_votes,
	   MAX(total_votes) AS max_total_votes,
	   MIN(median_rating) AS min_median_rating,
	   MAX(median_rating) AS max_median_rating
FROM ratings;



    
/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
WITH top_10_movies AS (
					SELECT title, 
						   avg_rating,
					       DENSE_RANK() OVER(ORDER BY avg_rating DESC) AS movie_rank
					FROM movie m 
					INNER JOIN ratings r 
					ON m.id = r.movie_id)
SELECT * FROM top_10_movies
WHERE movie_rank<=10;

-- Kirket, Love in Kilnerry, Gini Helida Kathe, Runam, Fan etc.. fall in top 10 movies based on average rating.




/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:
+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT median_rating, 
	   COUNT(movie_id) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY COUNT(movie_id) DESC;

-- movie with median rating of 7 has higest count.




/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
WITH most_hit_movies_company AS (
				SELECT m.production_company, 
					   COUNT(id) AS movie_count,
					   DENSE_RANK() OVER(ORDER BY COUNT(m.id) DESC) AS prod_company_rank
				FROM movie m
				INNER JOIN ratings r
				ON m.id = r.movie_id
                WHERE avg_rating >8 AND m.production_company IS NOT NULL
                GROUP BY m.production_company)
SELECT * 
FROM most_hit_movies_company
WHERE prod_company_rank = 1;

/* Dream Warrior Pictures and National Theatre Live are the two production house those have
 produced the most number of hit movies with average rating > 8.
*/




-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:
+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT g.genre, COUNT(g.movie_id) AS movie_count
FROM genre g 
	INNER JOIN movie m ON g.movie_id = m.id
    INNER JOIN ratings r ON m.id = r.movie_id
WHERE year = 2017 AND
	  MONTH(date_published) = 3 AND
	  country LIKE "%USA%" AND
      total_votes > 1000
GROUP BY genre
ORDER BY COUNT(movie_id) DESC;

/* 24 drama, 9 comedy, 8 action , 8 thriller, 7 sci-fi, 6 crime, 6 horror,  
4 mystery, 4 Romance, 3 Fantasy, 3 Adventure and a Family genre have released
 during March 2017 in the USA had more than 1,000 votes */





-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT m.title, r.avg_rating, g.genre
FROM movie AS m 
			INNER JOIN ratings AS r ON m.id = r.movie_id
            INNER JOIN genre AS g ON m.id= g.movie_id
WHERE m.title LIKE "The%" 
	  AND
      r.avg_rating >8
ORDER BY r.avg_rating;

-- One movie may belong to different genre and thats why we can see a few movies with same ratings are repeated but definitely they belong to different genre.


/* check hereonwards */
-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT COUNT(m.id) AS Movie_count
FROM movie m 
		INNER JOIN ratings r ON m.id = r.movie_id
WHERE median_rating = 8 AND
	date_published BETWEEN "2018-04-01" AND "2019-04-01"
GROUP BY median_rating;

-- 361 movies were released between 1 April 2018 and 1 April 2019 with median rating of 8.


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

WITH German_movie_votes AS( 
					SELECT SUM(total_votes) as German_vote_count
					FROM ratings r 
						INNER JOIN movie m ON r.movie_id = m.id
					WHERE languages LIKE "%German%"),
	Italian_movie_votes AS ( 
					SELECT SUM(total_votes) as Italian_vote_count
					FROM ratings r 
						INNER JOIN movie m ON r.movie_id = m.id
					WHERE languages LIKE "%Italian%")
	SELECT German_vote_count, Italian_vote_count,
		CASE 
			WHEN German_vote_count > Italian_vote_count THEN "Yes" ELSE "No" END AS votes_result
	FROM German_movie_votes, Italian_movie_votes;

/* Yes, the German movies got more votes than Italian movies. The German movies got 4421525 votes and the Italian movies got 2559540 votes.




-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT  SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
		SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
		SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
	    SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;

/* The columns height_nulls (null count: 17335), date_of_birth_nulls (null count: 13431) and 
known_for_movies_nulls (null count: 15226) have null values in them. */





/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
WITH top_3_genres AS (
           SELECT genre,
				  COUNT(m.id) AS movie_count,
				  RANK() OVER(ORDER BY COUNT(m.id) DESC) AS genre_rank
           FROM movie AS m
			   INNER JOIN genre AS g ON g.movie_id = m.id
			   INNER JOIN ratings AS r ON r.movie_id = m.id
           WHERE avg_rating > 8
           GROUP BY genre LIMIT 3)
SELECT n.name AS director_name ,
	   COUNT(d.movie_id) AS movie_count
FROM director_mapping  AS d
	INNER JOIN genre g using(movie_id)
	INNER JOIN names AS n ON n.id = d.name_id
	INNER JOIN top_3_genres using(genre)
	INNER JOIN ratings using (movie_id)
WHERE  avg_rating > 8
GROUP BY name
ORDER BY movie_count DESC 
LIMIT 3;

/* The top three directors in the top three genres whose movies have an average rating > 8 are:
James Mangold , Anthony Russo, Soubin Shahir */



/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT n.name AS actor_name, COUNT(r_map.movie_id) AS movie_count
FROM names n
	INNER JOIN role_mapping as r_map ON r_map.name_id = n.id
    INNER JOIN ratings r USING (movie_id)
WHERE median_rating >=8
GROUP BY n.name
ORDER BY COUNT(r_map.movie_id) DESC
LIMIT 2;


-- The top two actors whose movies have a median rating >= 8 are Mammootty and Mohanlal





/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH top_productions AS (
		SELECT production_company, SUM(total_votes) AS vote_count,
			DENSE_RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
		FROM movie m
		INNER JOIN ratings r ON m.id = r.movie_id
		WHERE production_company IS NOT NULL
		GROUP BY production_company
        )
SELECT * 
FROM top_productions
WHERE prod_comp_rank <4;

-- The top 3 productionn companies are Marvel Studios, Twentieth Century Fox and Warner Bros.





/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH top_actor
	AS(
		SELECT n.name AS actor_name, 
			   SUM(total_votes) AS total_votes, 
			   COUNT(r_map.movie_id) AS movie_count,
			   ROUND(SUM(avg_rating * total_votes)/SUM(total_votes),2) AS actor_avg_rating

		FROM names n  
			INNER JOIN role_mapping r_map ON r_map.name_id = n.id 
            INNER JOIN movie m ON r_map.movie_id = m.id 
            INNER JOIN ratings r ON m.id = r.movie_id 

		WHERE country LIKE "%INDIA%" AND 
			  category = "actor"
		
        GROUP BY name_id, NAME 
        HAVING Count(r_map.movie_id) >= 5)

SELECT *,
	DENSE_Rank() OVER (ORDER BY actor_avg_rating DESC) AS actor_rank 
FROM top_actor;
 -- Actor Vijay Sethupathi is on the top of the list with avgerage rating of 8.42



-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH top_actress 
		AS( SELECT n.name AS actress_name,
				   SUM(total_votes) AS total_votes,
				   COUNT(m.id) AS movie_count,
				   ROUND(SUM(avg_rating * total_votes)/SUM(total_votes),2) AS actress_avg_rating
			FROM names n
				INNER JOIN role_mapping r_map  ON r_map.name_id = n.id
				INNER JOIN movie m ON r_map.movie_id = m.id
                INNER JOIN ratings r ON m.id = r.movie_id
                
			WHERE country LIKE "%India%" AND
				  languages LIKE "%Hindi%" AND
                  category = "actress"
                  
            GROUP BY n.name
			HAVING Count(m.id) >= 3)
SELECT *,
DENSE_RANK() OVER(ORDER BY actress_avg_rating DESC) AS actress_rank
FROM top_actress
LIMIT 5;

/* The top 5 actress are: Taapsee Pannu, Kriti Sanon, Divya Dutta, Shraddha Kapoor, Kriti Kharbanda 
Amongst these Tapsee Pannu has weighted average rating of 7.74 */




/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT title AS Movie_title,
	CASE WHEN avg_rating > 8 Then "Superhit movies"
		 WHEN avg_rating BETWEEN 7 AND 8 THEN "Hit movies" 
         WHEN avg_rating BETWEEN 5 AND 7 THEN "One-time-watch movies"
         WHEN avg_rating < 5 THEN "Flop movies"
	END AS avg_rating_category
FROM movie m 
	INNER JOIN ratings r ON m.id = r.movie_id
    INNER JOIN genre g ON g.movie_id = m.id
WHERE genre = "Thriller";

/* As stated in comments above the question:
-- Part 2: Counting the number of above avgerage rating categories:

SELECT CASE  WHEN avg_rating > 8 Then "Superhit movies"
				 WHEN avg_rating BETWEEN 7 AND 8 THEN "Hit movies" 
				 WHEN avg_rating BETWEEN 5 AND 7 THEN "One-time-watch movies"
				 WHEN avg_rating < 5 THEN "Flop movies"
	END AS avg_rating_category, COUNT(m.id)
FROM movie m 
	INNER JOIN ratings r ON m.id = r.movie_id
    INNER JOIN genre g ON g.movie_id = m.id
WHERE genre = "Thriller"
GROUP BY avg_rating_category
ORDER BY COUNT(m.id) DESC; */


-- There are 786 One-time-watch movies, 493-Flop movies, 166 Hit movies and 39 Superhit movies


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT genre, 
	   ROUND(AVG(duration)) AS avg_duration,
       SUM(ROUND(AVG(duration),1)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
       ROUND(AVG(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS 10 PRECEDING),2) AS moving_avg_duration
       
FROM genre g
	INNER JOIN movie m ON m.id = g.movie_id
GROUP BY genre;
    
-- Note: The rounding is considered as per the output fromat.







-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


-- Top 3 Genres based on most number of movies
WITH Top_3_genre AS( 
			SELECT genre, COUNT(movie_id) AS movie_count,
			RANK() OVER(ORDER BY count(movie_id) DESC) AS genre_rank
			FROM genre
			GROUP BY genre
			LIMIT 3),
	world_wide_gross_income_convert AS (
			SELECT g.genre, 
				   m.year, 
                   m.title as movie_name, 
					 ROUND((CASE 
							WHEN m.worlwide_gross_income LIKE "%INR%" THEN (1/82) * CAST(REPLACE(worlwide_gross_income, "INR","")AS DECIMAL) 
                            WHEN m.worlwide_gross_income LIKE  "%$%"  THEN CAST(REPLACE(worlwide_gross_income, "$","")AS DECIMAL)
					  END),0) AS world_wide_gross_income
		FROM genre g 
				INNER JOIN movie m ON m.id = g.movie_id
			WHERE genre IN (SELECT genre FROM Top_3_genre) 
            ),
	final AS (
		SELECT *,
				DENSE_RANK() OVER(PARTITION BY year ORDER BY world_wide_gross_income DESC) AS movie_rank
		FROM world_wide_gross_income_convert 
        ORDER BY year)
SELECT genre, year, movie_name, CONCAT("$",world_wide_gross_income) AS world_wide_gross_income, movie_rank
FROM final
WHERE movie_rank <=5; 





-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which  (median rating >= 8) among multilingual movies?
/* Outputare the top two production houses that have produced the highest number of hits format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH top_production_houses AS(
						SELECT production_company, 
							   COUNT(id) AS movie_count, 
							   DENSE_RANK() OVER(ORDER BY COUNT(id) DESC) AS prod_comp_rank
						FROM movie m INNER JOIN ratings r ON m.id = r.movie_id
						WHERE production_company IS NOT NULL AND
							  POSITION("," IN languages)>0 AND
                              median_rating >=8
						GROUP BY production_company)

SELECT * 
FROM top_production_houses
WHERE prod_comp_rank <=2;

/* Star Cinema and Twentieth Century Fox are the top two production houses that have produced the highest 
number of hits */



-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT n.name AS actress_name, 
		SUM(total_votes) AS total_votes,
		COUNT(r.movie_id) AS movie_count,
		ROUND(SUM(avg_rating * total_votes)/SUM(total_votes),2) AS actress_avg_rating,
		DENSE_RANK() OVER(ORDER BY COUNT(r.movie_id) DESC) AS actress_rank
FROM names n 
		INNER JOIN role_mapping AS r_map ON n.id = r_map.name_id
		INNER JOIN ratings r USING (movie_id) 
		INNER JOIN genre USING (movie_id)
WHERE category = "actress" AND
		avg_rating > 8     AND
		genre LIKE "%drama%"
GROUP BY n.name
LIMIT 3;                        

-- The top 3 actresses based on number of Super Hit movies in Drama genre are Parvathy Thiruvothu, Susan Brown, Amanda Lawrence



/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH next_date_published_summary AS(
					   SELECT d.name_id,
							  name,
							  d.movie_id,
							  duration,
							  r.avg_rating,
							  total_votes,
							  m.date_published,
							  LEAD(date_published,1) OVER(partition BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
					   FROM director_mapping d
							INNER JOIN names n ON n.id = d.name_id
							INNER JOIN movie m ON m.id = d.movie_id
							INNER JOIN ratings AS r ON r.movie_id = m.id ),
	top_director_summary AS (
		   SELECT *, DATEDIFF(next_date_published, date_published) AS date_difference
		   FROM   next_date_published_summary )

SELECT   name_id AS director_id,
         name AS director_name,
         COUNT(movie_id) AS number_of_movies,
         ROUND(Avg(date_difference),2) AS avg_inter_movie_days,
         ROUND(Avg(avg_rating),2) AS avg_rating,
         SUM(total_votes) AS total_votes,
         MIN(avg_rating) AS min_rating,
         MAX(avg_rating)  AS max_rating,
         SUM(duration) AS total_duration
FROM top_director_summary
GROUP BY director_id
ORDER BY Count(movie_id) DESC limit 9;
