Movies with highest profit
select *,
gross-budget as profit_loss
from (
SELECT movie_title, gross, budget
FROM `inbound-guru-354704.movie_analysis.movie_list`
where gross is not null
and budget is not null)
order by profit_loss desc

Top 250 movies having highest IMDB rating
select row_number() over(order by top_rating_movie desc,num_voted_users desc) as movi
e_rank, *
from (
SELECT
movie_title,
imdb_score as top_rating_movie, language, num_voted_users
FROM `inbound-guru-354704.movie_analysis.movie_list`
where num_voted_users > 25000
order by imdb_score desc
)
limit 250

Top foreign language movies having highest IMDB rating
select row_number() over(order by top_rating_movie desc) as movie_rank, *
from (
SELECT
movie_title,
imdb_score as top_rating_movie, language
FROM `inbound-guru-354704.movie_analysis.movie_list`
where num_voted_users > 25000
order by imdb_score desc
limit 250)
where language != 'English'

Top 10 director
SELECT row_number() over(order by mean_score desc) as rank, *
from(
 select
director_name, 
avg(imdb_score) as mean_score
FROM `inbound-guru-354704.movie_analysis.movie_list`
where director_name is not null
and movie_title is not null
and imdb_score is not null
group by director_name
order by mean_score desc, director_name
limit 10)

Top popular Genres
SELECT count(movie_title) as num_of_movie, genres
FROM `inbound-guru-354704.movie_analysis.movie_list`
where movie_title is not null
and genres is not null
group by genres
order by num_of_movie desc
limit 10

Critic-favourite and audience-favourite actors
SELECT actor_1_name as actor_name, 
count(movie_title) as num_of_movies,
avg(num_critic_for_reviews) as mean_critic_review, 
avg(num_user_for_reviews) as mean_user_review
FROM modeanalytics.imdb_movies 
where actor_1_name = 'Meryl Streep' 
or actor_1_name = 'Leonardo DiCaprio'
or actor_1_name = 'Brad Pitt'
group by actor_1_name
order by mean_critic_review, mean_user_review

Comparison of number of Critic and User review in each decade
SELECT decade, 
SUM(num_critic_for_reviews) as num_of_critic_review, 
SUM(num_user_for_reviews) as num_of_user_review
FROM(
SELECT *,
CASE 
WHEN title_year < 2000 then 1990
WHEN title_year >= 2000 and title_year < 2010 then 2000
WHEN title_year >= 2010 and title_year < 2020 then 2010
END as decade
FROM (
SELECT 
movie_title, title_year,
num_critic_for_reviews, num_user_for_reviews
FROM modeanalytics.imdb_movies 
where title_year is not null
order by title_year) as a) as b 
GROUP by decade
ORDER by decade

