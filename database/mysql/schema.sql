-- Letterboxd Clone Database Schema (MySQL)
-- Target: MySQL 8.0+

START TRANSACTION;

DROP TABLE IF EXISTS movie_genres;
DROP TABLE IF EXISTS movie_directors;
DROP TABLE IF EXISTS movie_actors;
DROP TABLE IF EXISTS diary_entries;
DROP TABLE IF EXISTS list_movies;
DROP TABLE IF EXISTS lists;
DROP TABLE IF EXISTS watchlist_entries;
DROP TABLE IF EXISTS ratings;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS genres;
DROP TABLE IF EXISTS directors;
DROP TABLE IF EXISTS actors;
DROP TABLE IF EXISTS movies;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    user_id          INT AUTO_INCREMENT PRIMARY KEY,
    username         VARCHAR(30) NOT NULL UNIQUE,
    email            VARCHAR(255) NOT NULL UNIQUE,
    password_hash    VARCHAR(255) NOT NULL,
    join_date        DATE NOT NULL DEFAULT (CURRENT_DATE),
    bio              TEXT,
    CONSTRAINT users_username_min_len CHECK (CHAR_LENGTH(username) >= 3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE movies (
    movie_id         INT AUTO_INCREMENT PRIMARY KEY,
    title            VARCHAR(200) NOT NULL,
    release_year     INT NOT NULL,
    duration_minutes INT NOT NULL,
    language         VARCHAR(50) NOT NULL,
    description      TEXT,
    created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT movies_release_year_chk CHECK (release_year BETWEEN 1888 AND 2100),
    CONSTRAINT movies_duration_chk CHECK (duration_minutes BETWEEN 1 AND 600),
    CONSTRAINT movies_title_year_unique UNIQUE (title, release_year)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE actors (
    actor_id         INT AUTO_INCREMENT PRIMARY KEY,
    actor_name       VARCHAR(120) NOT NULL,
    birth_date       DATE,
    CONSTRAINT actors_name_unique UNIQUE (actor_name, birth_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE directors (
    director_id      INT AUTO_INCREMENT PRIMARY KEY,
    director_name    VARCHAR(120) NOT NULL,
    birth_date       DATE,
    CONSTRAINT directors_name_unique UNIQUE (director_name, birth_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE genres (
    genre_id         INT AUTO_INCREMENT PRIMARY KEY,
    genre_name       VARCHAR(60) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE reviews (
    review_id        INT AUTO_INCREMENT PRIMARY KEY,
    user_id          INT NOT NULL,
    movie_id         INT NOT NULL,
    review_text      TEXT NOT NULL,
    review_date      DATE NOT NULL DEFAULT (CURRENT_DATE),
    contains_spoiler TINYINT(1) NOT NULL DEFAULT 0,
    CONSTRAINT reviews_unique_per_user_movie UNIQUE (user_id, movie_id),
    CONSTRAINT fk_reviews_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_reviews_movie FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE ratings (
    rating_id        INT AUTO_INCREMENT PRIMARY KEY,
    user_id          INT NOT NULL,
    movie_id         INT NOT NULL,
    rating_value     DECIMAL(2,1) NOT NULL,
    rated_at         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ratings_range_chk CHECK (rating_value BETWEEN 0.5 AND 5.0),
    CONSTRAINT ratings_step_chk CHECK (MOD(rating_value * 10, 5) = 0),
    CONSTRAINT ratings_unique_per_user_movie UNIQUE (user_id, movie_id),
    CONSTRAINT fk_ratings_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_ratings_movie FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE watchlist_entries (
    watchlist_id     INT AUTO_INCREMENT PRIMARY KEY,
    user_id          INT NOT NULL,
    movie_id         INT NOT NULL,
    added_date       DATE NOT NULL DEFAULT (CURRENT_DATE),
    CONSTRAINT watchlist_unique_user_movie UNIQUE (user_id, movie_id),
    CONSTRAINT fk_watchlist_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_watchlist_movie FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE lists (
    list_id          INT AUTO_INCREMENT PRIMARY KEY,
    user_id          INT NOT NULL,
    list_name        VARCHAR(120) NOT NULL,
    description      TEXT,
    created_at       DATE NOT NULL DEFAULT (CURRENT_DATE),
    is_public        TINYINT(1) NOT NULL DEFAULT 1,
    CONSTRAINT lists_unique_user_name UNIQUE (user_id, list_name),
    CONSTRAINT fk_lists_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE list_movies (
    list_movie_id    INT AUTO_INCREMENT PRIMARY KEY,
    list_id          INT NOT NULL,
    movie_id         INT NOT NULL,
    added_at         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    position_in_list INT,
    CONSTRAINT list_movies_unique UNIQUE (list_id, movie_id),
    CONSTRAINT list_movies_position_positive CHECK (position_in_list IS NULL OR position_in_list > 0),
    CONSTRAINT fk_list_movies_list FOREIGN KEY (list_id) REFERENCES lists(list_id) ON DELETE CASCADE,
    CONSTRAINT fk_list_movies_movie FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE diary_entries (
    diary_id         INT AUTO_INCREMENT PRIMARY KEY,
    user_id          INT NOT NULL,
    movie_id         INT NOT NULL,
    watch_date       DATE NOT NULL,
    notes            TEXT,
    rewatch          TINYINT(1) NOT NULL DEFAULT 0,
    CONSTRAINT fk_diary_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_diary_movie FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE movie_actors (
    movie_id         INT NOT NULL,
    actor_id         INT NOT NULL,
    PRIMARY KEY (movie_id, actor_id),
    CONSTRAINT fk_movie_actors_movie FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON DELETE CASCADE,
    CONSTRAINT fk_movie_actors_actor FOREIGN KEY (actor_id) REFERENCES actors(actor_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE movie_directors (
    movie_id         INT NOT NULL,
    director_id      INT NOT NULL,
    PRIMARY KEY (movie_id, director_id),
    CONSTRAINT fk_movie_directors_movie FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON DELETE CASCADE,
    CONSTRAINT fk_movie_directors_director FOREIGN KEY (director_id) REFERENCES directors(director_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE movie_genres (
    movie_id         INT NOT NULL,
    genre_id         INT NOT NULL,
    PRIMARY KEY (movie_id, genre_id),
    CONSTRAINT fk_movie_genres_movie FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON DELETE CASCADE,
    CONSTRAINT fk_movie_genres_genre FOREIGN KEY (genre_id) REFERENCES genres(genre_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Performance indexes for frequent access paths.
CREATE INDEX idx_reviews_movie ON reviews(movie_id);
CREATE INDEX idx_ratings_movie ON ratings(movie_id);
CREATE INDEX idx_ratings_user ON ratings(user_id);
CREATE INDEX idx_watchlist_user ON watchlist_entries(user_id);
CREATE INDEX idx_list_movies_list ON list_movies(list_id);
CREATE INDEX idx_diary_user_date ON diary_entries(user_id, watch_date);

COMMIT;
