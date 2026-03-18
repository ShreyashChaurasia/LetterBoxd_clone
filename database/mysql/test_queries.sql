-- 60 test queries for Letterboxd Clone database (MySQL)

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

-- Q11: Average rating and total ratings per movie.
SELECT
    m.movie_id,
    m.title,
    ROUND(AVG(r.rating_value), 2) AS avg_rating,
    COUNT(r.rating_id) AS rating_count
FROM movies m
LEFT JOIN ratings r ON r.movie_id = m.movie_id
GROUP BY m.movie_id, m.title
ORDER BY avg_rating DESC, rating_count DESC, m.title;

-- Q12: Distribution of rating values.
SELECT
    rating_value,
    COUNT(*) AS frequency
FROM ratings
GROUP BY rating_value
ORDER BY rating_value;

-- Q13: Top users by number of ratings given.
SELECT
    u.user_id,
    u.username,
    COUNT(r.rating_id) AS ratings_given
FROM users u
JOIN ratings r ON r.user_id = u.user_id
GROUP BY u.user_id, u.username
ORDER BY ratings_given DESC, u.username
LIMIT 3;

-- Q14: Movies with most reviews.
SELECT
    m.movie_id,
    m.title,
    COUNT(rv.review_id) AS review_count
FROM movies m
JOIN reviews rv ON rv.movie_id = m.movie_id
GROUP BY m.movie_id, m.title
ORDER BY review_count DESC, m.title;

-- Q15: User-movie pairs where user rated but did not review.
SELECT
    u.username,
    m.title
FROM ratings r
JOIN users u ON u.user_id = r.user_id
JOIN movies m ON m.movie_id = r.movie_id
LEFT JOIN reviews rv
    ON rv.user_id = r.user_id
    AND rv.movie_id = r.movie_id
WHERE rv.review_id IS NULL
ORDER BY u.username, m.title;

-- Q16: User-movie pairs where user reviewed but did not rate.
SELECT
    u.username,
    m.title
FROM reviews rv
JOIN users u ON u.user_id = rv.user_id
JOIN movies m ON m.movie_id = rv.movie_id
LEFT JOIN ratings r
    ON r.user_id = rv.user_id
    AND r.movie_id = rv.movie_id
WHERE r.rating_id IS NULL
ORDER BY u.username, m.title;

-- Q17: Movies with no ratings yet.
SELECT
    m.movie_id,
    m.title
FROM movies m
LEFT JOIN ratings r ON r.movie_id = m.movie_id
WHERE r.rating_id IS NULL
ORDER BY m.title;

-- Q18: Movies most frequently added to watchlists.
SELECT
    m.movie_id,
    m.title,
    COUNT(w.watchlist_id) AS watchlist_adds
FROM movies m
LEFT JOIN watchlist_entries w ON w.movie_id = m.movie_id
GROUP BY m.movie_id, m.title
ORDER BY watchlist_adds DESC, m.title;

-- Q19: Diary logs and rewatch counts per movie.
SELECT
    m.movie_id,
    m.title,
    COUNT(d.diary_id) AS diary_logs,
    SUM(d.rewatch = 1) AS rewatch_logs
FROM movies m
LEFT JOIN diary_entries d ON d.movie_id = m.movie_id
GROUP BY m.movie_id, m.title
ORDER BY diary_logs DESC, rewatch_logs DESC, m.title;

-- Q20: Daily ratings trend.
SELECT
    DATE(r.rated_at) AS rating_day,
    COUNT(*) AS ratings_count,
    ROUND(AVG(r.rating_value), 2) AS avg_rating
FROM ratings r
GROUP BY DATE(r.rated_at)
ORDER BY rating_day;

-- Q21: User signups by month.
SELECT
    DATE_FORMAT(u.join_date, '%Y-%m') AS join_month,
    COUNT(*) AS users_joined
FROM users u
GROUP BY DATE_FORMAT(u.join_date, '%Y-%m')
ORDER BY join_month;

-- Q22: Movie count by language.
SELECT
    m.language,
    COUNT(*) AS movie_count
FROM movies m
GROUP BY m.language
ORDER BY movie_count DESC, m.language;

-- Q23: Top 5 longest movies.
SELECT
    m.title,
    m.release_year,
    m.duration_minutes
FROM movies m
ORDER BY m.duration_minutes DESC, m.title
LIMIT 5;

-- Q24: Average movie duration by genre.
SELECT
    g.genre_name,
    ROUND(AVG(m.duration_minutes), 1) AS avg_duration_minutes
FROM genres g
JOIN movie_genres mg ON mg.genre_id = g.genre_id
JOIN movies m ON m.movie_id = mg.movie_id
GROUP BY g.genre_id, g.genre_name
ORDER BY avg_duration_minutes DESC, g.genre_name;

-- Q25: Movies tagged with more than one genre.
SELECT
    m.movie_id,
    m.title,
    COUNT(mg.genre_id) AS genre_count
FROM movies m
JOIN movie_genres mg ON mg.movie_id = m.movie_id
GROUP BY m.movie_id, m.title
HAVING COUNT(mg.genre_id) > 1
ORDER BY genre_count DESC, m.title;

-- Q26: Directors with average rating across their films.
SELECT
    d.director_name,
    COUNT(DISTINCT md.movie_id) AS directed_movies,
    ROUND(AVG(r.rating_value), 2) AS avg_movie_rating
FROM directors d
LEFT JOIN movie_directors md ON md.director_id = d.director_id
LEFT JOIN ratings r ON r.movie_id = md.movie_id
GROUP BY d.director_id, d.director_name
ORDER BY avg_movie_rating DESC, directed_movies DESC, d.director_name;

-- Q27: Actors with average rating across their films.
SELECT
    a.actor_name,
    COUNT(DISTINCT ma.movie_id) AS acted_movies,
    ROUND(AVG(r.rating_value), 2) AS avg_movie_rating
FROM actors a
LEFT JOIN movie_actors ma ON ma.actor_id = a.actor_id
LEFT JOIN ratings r ON r.movie_id = ma.movie_id
GROUP BY a.actor_id, a.actor_name
ORDER BY avg_movie_rating DESC, acted_movies DESC, a.actor_name;

-- Q28: Genre appearances inside public lists.
SELECT
    g.genre_name,
    COUNT(*) AS appearances_in_public_lists
FROM lists l
JOIN list_movies lm ON lm.list_id = l.list_id
JOIN movie_genres mg ON mg.movie_id = lm.movie_id
JOIN genres g ON g.genre_id = mg.genre_id
WHERE l.is_public = 1
GROUP BY g.genre_id, g.genre_name
ORDER BY appearances_in_public_lists DESC, g.genre_name;

-- Q29: List sizes with owner names.
SELECT
    l.list_id,
    l.list_name,
    u.username AS list_owner,
    COUNT(lm.list_movie_id) AS item_count
FROM lists l
JOIN users u ON u.user_id = l.user_id
LEFT JOIN list_movies lm ON lm.list_id = l.list_id
GROUP BY l.list_id, l.list_name, u.username
ORDER BY item_count DESC, l.list_name;

-- Q30: Private list count per user.
SELECT
    u.username,
    COUNT(l.list_id) AS private_lists
FROM users u
LEFT JOIN lists l
    ON l.user_id = u.user_id
    AND l.is_public = 0
GROUP BY u.user_id, u.username
ORDER BY private_lists DESC, u.username;

-- Q31: Public list contents with generated display order.
SELECT
    l.list_name,
    u.username AS list_owner,
    m.title,
    ROW_NUMBER() OVER (
        PARTITION BY l.list_id
        ORDER BY lm.position_in_list, lm.added_at
    ) AS display_order
FROM lists l
JOIN users u ON u.user_id = l.user_id
JOIN list_movies lm ON lm.list_id = l.list_id
JOIN movies m ON m.movie_id = lm.movie_id
WHERE l.is_public = 1
ORDER BY l.list_name, display_order;

-- Q32: Diary entries with matching rating (if present).
SELECT
    u.username,
    m.title,
    d.watch_date,
    r.rating_value
FROM diary_entries d
JOIN users u ON u.user_id = d.user_id
JOIN movies m ON m.movie_id = d.movie_id
LEFT JOIN ratings r
    ON r.user_id = d.user_id
    AND r.movie_id = d.movie_id
ORDER BY d.watch_date DESC, u.username, m.title;

-- Q33: Users sorted by total rewatches.
SELECT
    u.username,
    SUM(d.rewatch = 1) AS rewatch_count,
    COUNT(d.diary_id) AS total_diary_logs
FROM users u
LEFT JOIN diary_entries d ON d.user_id = u.user_id
GROUP BY u.user_id, u.username
ORDER BY rewatch_count DESC, total_diary_logs DESC, u.username;

-- Q34: First and latest activity timestamp per user.
WITH all_activity AS (
    SELECT user_id, CAST(rated_at AS DATETIME) AS activity_ts FROM ratings
    UNION ALL
    SELECT user_id, CAST(review_date AS DATETIME) AS activity_ts FROM reviews
    UNION ALL
    SELECT user_id, CAST(watch_date AS DATETIME) AS activity_ts FROM diary_entries
)
SELECT
    u.username,
    MIN(a.activity_ts) AS first_activity,
    MAX(a.activity_ts) AS latest_activity,
    COUNT(a.activity_ts) AS total_events
FROM users u
LEFT JOIN all_activity a ON a.user_id = u.user_id
GROUP BY u.user_id, u.username
ORDER BY latest_activity DESC, u.username;

-- Q35: User average rating and bias versus global average.
WITH global_avg AS (
    SELECT AVG(rating_value) AS avg_rating
    FROM ratings
)
SELECT
    u.username,
    ROUND(AVG(r.rating_value), 2) AS user_avg_rating,
    ROUND(AVG(r.rating_value) - ga.avg_rating, 2) AS bias_vs_global
FROM users u
JOIN ratings r ON r.user_id = u.user_id
CROSS JOIN global_avg ga
GROUP BY u.user_id, u.username, ga.avg_rating
ORDER BY bias_vs_global DESC, u.username;

-- Q36: Top 2 rated movies per user.
WITH ranked_user_ratings AS (
    SELECT
        u.username,
        m.title,
        r.rating_value,
        ROW_NUMBER() OVER (
            PARTITION BY r.user_id
            ORDER BY r.rating_value DESC, r.rated_at DESC, m.title
        ) AS rn
    FROM ratings r
    JOIN users u ON u.user_id = r.user_id
    JOIN movies m ON m.movie_id = r.movie_id
)
SELECT
    username,
    title,
    rating_value
FROM ranked_user_ratings
WHERE rn <= 2
ORDER BY username, rn;

-- Q37: Genre-wise ranking of movies by average rating.
WITH genre_movie_scores AS (
    SELECT
        g.genre_name,
        m.movie_id,
        m.title,
        ROUND(AVG(r.rating_value), 2) AS avg_rating,
        COUNT(r.rating_id) AS rating_count
    FROM genres g
    JOIN movie_genres mg ON mg.genre_id = g.genre_id
    JOIN movies m ON m.movie_id = mg.movie_id
    LEFT JOIN ratings r ON r.movie_id = m.movie_id
    GROUP BY g.genre_name, m.movie_id, m.title
)
SELECT
    genre_name,
    title,
    avg_rating,
    rating_count,
    DENSE_RANK() OVER (
        PARTITION BY genre_name
        ORDER BY avg_rating DESC, rating_count DESC, title
    ) AS genre_rank
FROM genre_movie_scores
ORDER BY genre_name, genre_rank, title;

-- Q38: Number of commonly rated movies for each pair of users.
SELECT
    u1.username AS user_a,
    u2.username AS user_b,
    COUNT(*) AS common_rated_movies
FROM ratings r1
JOIN ratings r2
    ON r1.movie_id = r2.movie_id
    AND r1.user_id < r2.user_id
JOIN users u1 ON u1.user_id = r1.user_id
JOIN users u2 ON u2.user_id = r2.user_id
GROUP BY u1.username, u2.username
ORDER BY common_rated_movies DESC, user_a, user_b;

-- Q39: Rating disagreement (average absolute diff) for user pairs.
SELECT
    u1.username AS user_a,
    u2.username AS user_b,
    ROUND(AVG(ABS(r1.rating_value - r2.rating_value)), 2) AS avg_abs_diff,
    COUNT(*) AS common_movies
FROM ratings r1
JOIN ratings r2
    ON r1.movie_id = r2.movie_id
    AND r1.user_id < r2.user_id
JOIN users u1 ON u1.user_id = r1.user_id
JOIN users u2 ON u2.user_id = r2.user_id
GROUP BY u1.username, u2.username
ORDER BY avg_abs_diff, common_movies DESC, user_a, user_b;

-- Q40: Simple collaborative suggestions for user 'shrey'.
WITH target_user AS (
    SELECT user_id
    FROM users
    WHERE username = 'shrey'
),
similar_users AS (
    SELECT
        r2.user_id,
        COUNT(*) AS overlap_count,
        AVG(ABS(r1.rating_value - r2.rating_value)) AS avg_diff
    FROM ratings r1
    JOIN ratings r2
        ON r1.movie_id = r2.movie_id
    JOIN target_user t ON t.user_id = r1.user_id
    WHERE r2.user_id <> t.user_id
    GROUP BY r2.user_id
    HAVING COUNT(*) >= 1
),
candidate_movies AS (
    SELECT
        r.movie_id,
        ROUND(AVG(r.rating_value), 2) AS peer_avg_rating,
        COUNT(*) AS peer_votes
    FROM ratings r
    JOIN similar_users su ON su.user_id = r.user_id
    WHERE NOT EXISTS (
        SELECT 1
        FROM ratings tr
        JOIN target_user t2 ON t2.user_id = tr.user_id
        WHERE tr.movie_id = r.movie_id
    )
    GROUP BY r.movie_id
)
SELECT
    m.title,
    cm.peer_avg_rating,
    cm.peer_votes
FROM candidate_movies cm
JOIN movies m ON m.movie_id = cm.movie_id
ORDER BY cm.peer_avg_rating DESC, cm.peer_votes DESC, m.title;

-- Q41: Watchlist entries not yet logged in diary by the same user.
SELECT
    u.username,
    m.title,
    w.added_date
FROM watchlist_entries w
JOIN users u ON u.user_id = w.user_id
JOIN movies m ON m.movie_id = w.movie_id
LEFT JOIN diary_entries d
    ON d.user_id = w.user_id
    AND d.movie_id = w.movie_id
WHERE d.diary_id IS NULL
ORDER BY u.username, w.added_date;

-- Q42: Watchlist-to-diary conversion rate per user.
SELECT
    u.username,
    COUNT(DISTINCT w.movie_id) AS watchlisted_movies,
    COUNT(DISTINCT d.movie_id) AS watched_from_watchlist,
    ROUND(
        100.0 * COUNT(DISTINCT d.movie_id) / NULLIF(COUNT(DISTINCT w.movie_id), 0),
        2
    ) AS conversion_pct
FROM users u
LEFT JOIN watchlist_entries w ON w.user_id = u.user_id
LEFT JOIN diary_entries d
    ON d.user_id = w.user_id
    AND d.movie_id = w.movie_id
GROUP BY u.user_id, u.username
ORDER BY conversion_pct DESC, u.username;

-- Q43: Average days between watchlist add and diary log (same user/movie).
SELECT
    u.username,
    ROUND(AVG(DATEDIFF(d.watch_date, w.added_date)), 1) AS avg_days_to_watch,
    COUNT(*) AS matched_titles
FROM watchlist_entries w
JOIN diary_entries d
    ON d.user_id = w.user_id
    AND d.movie_id = w.movie_id
    AND d.watch_date >= w.added_date
JOIN users u ON u.user_id = w.user_id
GROUP BY u.user_id, u.username
ORDER BY avg_days_to_watch, u.username;

-- Q44: Users who logged the same movie multiple times.
SELECT
    u.username,
    m.title,
    COUNT(*) AS diary_log_count
FROM diary_entries d
JOIN users u ON u.user_id = d.user_id
JOIN movies m ON m.movie_id = d.movie_id
GROUP BY u.username, m.title
HAVING COUNT(*) > 1
ORDER BY diary_log_count DESC, u.username, m.title;

-- Q45: Latest review for each movie.
WITH ranked_reviews AS (
    SELECT
        m.title,
        u.username,
        rv.review_date,
        rv.review_text,
        ROW_NUMBER() OVER (
            PARTITION BY rv.movie_id
            ORDER BY rv.review_date DESC, rv.review_id DESC
        ) AS rn
    FROM reviews rv
    JOIN users u ON u.user_id = rv.user_id
    JOIN movies m ON m.movie_id = rv.movie_id
)
SELECT
    title,
    username,
    review_date,
    review_text
FROM ranked_reviews
WHERE rn = 1
ORDER BY title;

-- Q46: Total and spoiler review counts per movie.
SELECT
    m.title,
    COUNT(rv.review_id) AS total_reviews,
    SUM(rv.contains_spoiler = 1) AS spoiler_reviews
FROM movies m
LEFT JOIN reviews rv ON rv.movie_id = m.movie_id
GROUP BY m.movie_id, m.title
ORDER BY spoiler_reviews DESC, total_reviews DESC, m.title;

-- Q47: Approximate word count for each review.
SELECT
    rv.review_id,
    u.username,
    m.title,
    (
        CHAR_LENGTH(TRIM(rv.review_text))
        - CHAR_LENGTH(REPLACE(TRIM(rv.review_text), ' ', ''))
        + 1
    ) AS approx_word_count
FROM reviews rv
JOIN users u ON u.user_id = rv.user_id
JOIN movies m ON m.movie_id = rv.movie_id
ORDER BY approx_word_count DESC, rv.review_id;

-- Q48: Busiest activity dates (ratings + reviews + diary logs).
WITH daily_events AS (
    SELECT DATE(rated_at) AS activity_date, COUNT(*) AS cnt
    FROM ratings
    GROUP BY DATE(rated_at)
    UNION ALL
    SELECT review_date AS activity_date, COUNT(*) AS cnt
    FROM reviews
    GROUP BY review_date
    UNION ALL
    SELECT watch_date AS activity_date, COUNT(*) AS cnt
    FROM diary_entries
    GROUP BY watch_date
)
SELECT
    activity_date,
    SUM(cnt) AS total_events
FROM daily_events
GROUP BY activity_date
ORDER BY total_events DESC, activity_date DESC;

-- Q49: Cumulative ratings over time per user.
WITH daily_ratings AS (
    SELECT
        r.user_id,
        DATE(r.rated_at) AS rating_day,
        COUNT(*) AS daily_count
    FROM ratings r
    GROUP BY r.user_id, DATE(r.rated_at)
)
SELECT
    u.username,
    dr.rating_day,
    dr.daily_count,
    SUM(dr.daily_count) OVER (
        PARTITION BY dr.user_id
        ORDER BY dr.rating_day
    ) AS cumulative_ratings
FROM daily_ratings dr
JOIN users u ON u.user_id = dr.user_id
ORDER BY u.username, dr.rating_day;

-- Q50: Movie quartiles by average rating.
WITH movie_scores AS (
    SELECT
        m.movie_id,
        m.title,
        AVG(r.rating_value) AS avg_rating
    FROM movies m
    JOIN ratings r ON r.movie_id = m.movie_id
    GROUP BY m.movie_id, m.title
)
SELECT
    title,
    ROUND(avg_rating, 2) AS avg_rating,
    NTILE(4) OVER (ORDER BY avg_rating DESC, title) AS quartile
FROM movie_scores
ORDER BY avg_rating DESC, title;

-- Q51: Number of movies by decade.
SELECT
    CONCAT(FLOOR(m.release_year / 10) * 10, 's') AS decade,
    COUNT(*) AS movie_count
FROM movies m
GROUP BY FLOOR(m.release_year / 10)
ORDER BY FLOOR(m.release_year / 10);

-- Q52: Director-genre matrix (how many films in each genre).
SELECT
    d.director_name,
    g.genre_name,
    COUNT(*) AS film_count
FROM movie_directors md
JOIN directors d ON d.director_id = md.director_id
JOIN movie_genres mg ON mg.movie_id = md.movie_id
JOIN genres g ON g.genre_id = mg.genre_id
GROUP BY d.director_name, g.genre_name
ORDER BY d.director_name, film_count DESC, g.genre_name;

-- Q53: Most common genre combinations within movies.
SELECT
    g1.genre_name AS genre_a,
    g2.genre_name AS genre_b,
    COUNT(*) AS movie_count
FROM movie_genres mg1
JOIN movie_genres mg2
    ON mg1.movie_id = mg2.movie_id
    AND mg1.genre_id < mg2.genre_id
JOIN genres g1 ON g1.genre_id = mg1.genre_id
JOIN genres g2 ON g2.genre_id = mg2.genre_id
GROUP BY g1.genre_name, g2.genre_name
ORDER BY movie_count DESC, genre_a, genre_b;

-- Q54: Overlap count between public lists.
SELECT
    l1.list_name AS list_a,
    l2.list_name AS list_b,
    COUNT(*) AS shared_movies
FROM list_movies lm1
JOIN list_movies lm2
    ON lm1.movie_id = lm2.movie_id
    AND lm1.list_id < lm2.list_id
JOIN lists l1 ON l1.list_id = lm1.list_id
JOIN lists l2 ON l2.list_id = lm2.list_id
WHERE l1.is_public = 1
AND l2.is_public = 1
GROUP BY l1.list_name, l2.list_name
ORDER BY shared_movies DESC, list_a, list_b;

-- Q55: Movies that appear in both watchlist and user-created lists.
SELECT DISTINCT
    u.username,
    m.title
FROM users u
JOIN watchlist_entries w ON w.user_id = u.user_id
JOIN lists l ON l.user_id = u.user_id
JOIN list_movies lm
    ON lm.list_id = l.list_id
    AND lm.movie_id = w.movie_id
JOIN movies m ON m.movie_id = w.movie_id
ORDER BY u.username, m.title;

-- Q56: Feature usage score per user (rating/review/watchlist/list/diary).
SELECT
    u.username,
    (
        MAX(r.user_id IS NOT NULL)
        + MAX(rv.user_id IS NOT NULL)
        + MAX(w.user_id IS NOT NULL)
        + MAX(l.user_id IS NOT NULL)
        + MAX(d.user_id IS NOT NULL)
    ) AS features_used_out_of_5
FROM users u
LEFT JOIN ratings r ON r.user_id = u.user_id
LEFT JOIN reviews rv ON rv.user_id = u.user_id
LEFT JOIN watchlist_entries w ON w.user_id = u.user_id
LEFT JOIN lists l ON l.user_id = u.user_id
LEFT JOIN diary_entries d ON d.user_id = u.user_id
GROUP BY u.user_id, u.username
ORDER BY features_used_out_of_5 DESC, u.username;

-- Q57: Users with missing or very short bio.
SELECT
    u.user_id,
    u.username,
    u.bio,
    CHAR_LENGTH(COALESCE(TRIM(u.bio), '')) AS bio_length
FROM users u
WHERE u.bio IS NULL
OR CHAR_LENGTH(COALESCE(TRIM(u.bio), '')) < 15
ORDER BY u.user_id;

-- Q58: Duplicate diary entries for same user/movie/date (data quality check).
SELECT
    u.username,
    m.title,
    d.watch_date,
    COUNT(*) AS duplicate_rows
FROM diary_entries d
JOIN users u ON u.user_id = d.user_id
JOIN movies m ON m.movie_id = d.movie_id
GROUP BY u.username, m.title, d.watch_date
HAVING COUNT(*) > 1
ORDER BY duplicate_rows DESC, u.username, m.title;

-- Q59: Keyword search in movie title/description (example keyword: dark).
SELECT
    m.movie_id,
    m.title,
    m.release_year,
    m.language
FROM movies m
WHERE m.title LIKE '%dark%'
OR m.description LIKE '%dark%'
ORDER BY m.release_year DESC, m.title;

-- Q60: One personalized unseen suggestion set per user from favorite genre.
WITH user_genre_agg AS (
    SELECT
        r.user_id,
        mg.genre_id,
        AVG(r.rating_value) AS avg_rating,
        COUNT(*) AS rating_count
    FROM ratings r
    JOIN movie_genres mg ON mg.movie_id = r.movie_id
    GROUP BY r.user_id, mg.genre_id
),
favorite_genre AS (
    SELECT
        uga.user_id,
        uga.genre_id,
        ROW_NUMBER() OVER (
            PARTITION BY uga.user_id
            ORDER BY uga.avg_rating DESC, uga.rating_count DESC, uga.genre_id
        ) AS rn
    FROM user_genre_agg uga
),
candidates AS (
    SELECT
        fg.user_id,
        m.movie_id,
        m.title,
        ROUND(AVG(r.rating_value), 2) AS community_avg
    FROM favorite_genre fg
    JOIN movie_genres mg ON mg.genre_id = fg.genre_id
    JOIN movies m ON m.movie_id = mg.movie_id
    LEFT JOIN ratings r ON r.movie_id = m.movie_id
    WHERE fg.rn = 1
    AND NOT EXISTS (
        SELECT 1
        FROM ratings ur
        WHERE ur.user_id = fg.user_id
        AND ur.movie_id = m.movie_id
    )
    GROUP BY fg.user_id, m.movie_id, m.title
)
SELECT
    u.username,
    g.genre_name AS favorite_genre,
    c.title AS suggested_movie,
    c.community_avg
FROM candidates c
JOIN users u ON u.user_id = c.user_id
JOIN favorite_genre fg
    ON fg.user_id = c.user_id
    AND fg.rn = 1
JOIN genres g ON g.genre_id = fg.genre_id
ORDER BY u.username, c.community_avg DESC, c.title;
