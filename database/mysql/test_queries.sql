-- 10 test queries for Letterboxd Clone database (MySQL)
-- Run after mysql/schema.sql and mysql/sample_data.sql

-- Q1: List all users with total ratings and reviews they have written.
SELECT
    u.user_id,
    u.username,
    COUNT(DISTINCT r.rating_id) AS total_ratings,
    COUNT(DISTINCT rv.review_id) AS total_reviews
FROM users u
LEFT JOIN ratings r ON r.user_id = u.user_id
LEFT JOIN reviews rv ON rv.user_id = u.user_id
GROUP BY u.user_id, u.username
ORDER BY u.user_id;

-- Q2: Top 5 highest rated movies (minimum 2 ratings).
SELECT
    m.movie_id,
    m.title,
    ROUND(AVG(r.rating_value), 2) AS avg_rating,
    COUNT(*) AS rating_count
FROM movies m
JOIN ratings r ON r.movie_id = m.movie_id
GROUP BY m.movie_id, m.title
HAVING COUNT(*) >= 2
ORDER BY avg_rating DESC, rating_count DESC
LIMIT 5;

-- Q3: Show all reviews for a given movie (example: Inception).
SELECT
    m.title,
    u.username,
    rv.review_date,
    rv.review_text
FROM reviews rv
JOIN users u ON u.user_id = rv.user_id
JOIN movies m ON m.movie_id = rv.movie_id
WHERE m.title = 'Inception'
ORDER BY rv.review_date DESC;

-- Q4: All movies in each public list, in list order.
SELECT
    l.list_name,
    u.username AS list_owner,
    lm.position_in_list,
    m.title
FROM lists l
JOIN users u ON u.user_id = l.user_id
JOIN list_movies lm ON lm.list_id = l.list_id
JOIN movies m ON m.movie_id = lm.movie_id
WHERE l.is_public = 1
ORDER BY l.list_name, lm.position_in_list;

-- Q5: Movies currently in each user's watchlist.
SELECT
    u.username,
    m.title,
    w.added_date
FROM watchlist_entries w
JOIN users u ON u.user_id = w.user_id
JOIN movies m ON m.movie_id = w.movie_id
ORDER BY u.username, w.added_date DESC;

-- Q6: Diary activity - how many movies each user logged.
SELECT
    u.username,
    COUNT(d.diary_id) AS movies_logged,
    SUM(CASE WHEN d.rewatch = 1 THEN 1 ELSE 0 END) AS rewatches
FROM users u
LEFT JOIN diary_entries d ON d.user_id = u.user_id
GROUP BY u.username
ORDER BY movies_logged DESC, u.username;

-- Q7: Find movies by genre (example: Sci-Fi) with average rating.
SELECT
    g.genre_name,
    m.title,
    ROUND(AVG(r.rating_value), 2) AS avg_rating
FROM genres g
JOIN movie_genres mg ON mg.genre_id = g.genre_id
JOIN movies m ON m.movie_id = mg.movie_id
LEFT JOIN ratings r ON r.movie_id = m.movie_id
WHERE g.genre_name = 'Sci-Fi'
GROUP BY g.genre_name, m.title
ORDER BY avg_rating IS NULL, avg_rating DESC, m.title;

-- Q8: Directors and the number of movies they have in the database.
SELECT
    d.director_name,
    COUNT(md.movie_id) AS total_movies
FROM directors d
LEFT JOIN movie_directors md ON md.director_id = d.director_id
GROUP BY d.director_name
ORDER BY total_movies DESC, d.director_name;

-- Q9: Actor filmography with release year.
SELECT
    a.actor_name,
    m.title,
    m.release_year
FROM actors a
JOIN movie_actors ma ON ma.actor_id = a.actor_id
JOIN movies m ON m.movie_id = ma.movie_id
ORDER BY a.actor_name, m.release_year DESC;

-- Q10: "Recommendation-style" query:
-- movies in user's favorite genre not yet rated by that user (example user: shrey).
WITH genre_counts AS (
    SELECT
        r.user_id,
        mg.genre_id,
        COUNT(*) AS genre_rating_count
    FROM ratings r
    JOIN movie_genres mg ON mg.movie_id = r.movie_id
    WHERE r.user_id = (SELECT user_id FROM users WHERE username = 'shrey')
    GROUP BY r.user_id, mg.genre_id
),
user_fav_genre AS (
    SELECT
        gc.user_id,
        gc.genre_id,
        gc.genre_rating_count,
        ROW_NUMBER() OVER (
            PARTITION BY gc.user_id
            ORDER BY gc.genre_rating_count DESC, gc.genre_id
        ) AS rn
    FROM genre_counts gc
)
SELECT
    u.username,
    g.genre_name AS favorite_genre,
    m.title AS suggested_movie
FROM user_fav_genre uf
JOIN users u ON u.user_id = uf.user_id
JOIN genres g ON g.genre_id = uf.genre_id
JOIN movie_genres mg ON mg.genre_id = uf.genre_id
JOIN movies m ON m.movie_id = mg.movie_id
WHERE uf.rn = 1
AND NOT EXISTS (
    SELECT 1
    FROM ratings r2
    WHERE r2.user_id = uf.user_id
    AND r2.movie_id = m.movie_id
)
ORDER BY suggested_movie;
