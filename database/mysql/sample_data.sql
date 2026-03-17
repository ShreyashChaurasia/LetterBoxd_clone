-- Sample data for Letterboxd Clone schema (MySQL)
-- Run after mysql/schema.sql

START TRANSACTION;

INSERT INTO users (username, email, password_hash, join_date, bio) VALUES
('shrey', 'shrey@example.com', 'hash_shrey', '2025-01-10', 'Movie buff and sci-fi lover.'),
('aisha', 'aisha@example.com', 'hash_aisha', '2025-02-14', 'Writes short reviews every weekend.'),
('rahul', 'rahul@example.com', 'hash_rahul', '2025-03-05', 'Collects top-100 lists.'),
('meera', 'meera@example.com', 'hash_meera', '2025-04-01', 'Animation fan.'),
('dev', 'dev@example.com', 'hash_dev', '2025-05-19', 'Likes thrillers and mysteries.');

INSERT INTO movies (title, release_year, duration_minutes, language, description) VALUES
('Inception', 2010, 148, 'English', 'A thief enters dreams to steal ideas.'),
('Interstellar', 2014, 169, 'English', 'Explorers travel through a wormhole to save humanity.'),
('Parasite', 2019, 132, 'Korean', 'A poor family infiltrates a wealthy household.'),
('Spirited Away', 2001, 125, 'Japanese', 'A girl enters a spirit world to rescue her parents.'),
('The Dark Knight', 2008, 152, 'English', 'Batman faces the Joker in Gotham.'),
('Whiplash', 2014, 107, 'English', 'A drummer pushes toward perfection.');

INSERT INTO actors (actor_name, birth_date) VALUES
('Leonardo DiCaprio', '1974-11-11'),
('Matthew McConaughey', '1969-11-04'),
('Song Kang-ho', '1967-01-17'),
('Rumi Hiiragi', '1987-08-01'),
('Christian Bale', '1974-01-30'),
('Miles Teller', '1987-02-20');

INSERT INTO directors (director_name, birth_date) VALUES
('Christopher Nolan', '1970-07-30'),
('Bong Joon-ho', '1969-09-14'),
('Hayao Miyazaki', '1941-01-05'),
('Damien Chazelle', '1985-01-19');

INSERT INTO genres (genre_name) VALUES
('Sci-Fi'),
('Drama'),
('Thriller'),
('Animation'),
('Crime');

INSERT INTO movie_actors (movie_id, actor_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6);

INSERT INTO movie_directors (movie_id, director_id) VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 3),
(5, 1),
(6, 4);

INSERT INTO movie_genres (movie_id, genre_id) VALUES
(1, 1), (1, 3),
(2, 1), (2, 2),
(3, 2), (3, 3),
(4, 4),
(5, 5), (5, 3),
(6, 2);

INSERT INTO ratings (user_id, movie_id, rating_value, rated_at) VALUES
(1, 1, 5.0, '2026-01-01 10:00:00'),
(1, 2, 4.5, '2026-01-02 10:00:00'),
(1, 5, 4.5, '2026-01-03 10:00:00'),
(2, 1, 4.5, '2026-01-03 09:00:00'),
(2, 3, 5.0, '2026-01-04 09:00:00'),
(2, 4, 4.0, '2026-01-05 09:00:00'),
(3, 2, 5.0, '2026-01-06 12:00:00'),
(3, 5, 4.0, '2026-01-07 12:00:00'),
(3, 6, 4.5, '2026-01-08 12:00:00'),
(4, 3, 4.5, '2026-01-09 20:00:00'),
(4, 4, 5.0, '2026-01-10 20:00:00'),
(5, 5, 5.0, '2026-01-11 08:00:00'),
(5, 1, 4.0, '2026-01-12 08:00:00');

INSERT INTO reviews (user_id, movie_id, review_text, review_date, contains_spoiler) VALUES
(1, 1, 'Mind-bending and visually stunning.', '2026-01-01', 0),
(1, 2, 'Emotional and ambitious sci-fi epic.', '2026-01-02', 0),
(2, 3, 'Sharp social commentary with perfect pacing.', '2026-01-04', 0),
(3, 6, 'Intense and stressful in the best way.', '2026-01-08', 0),
(4, 4, 'Magical world-building and heartfelt story.', '2026-01-10', 0),
(5, 5, 'One of the best comic-book films ever.', '2026-01-11', 0);

INSERT INTO watchlist_entries (user_id, movie_id, added_date) VALUES
(1, 3, '2026-02-01'),
(1, 4, '2026-02-01'),
(2, 2, '2026-02-02'),
(3, 1, '2026-02-02'),
(4, 5, '2026-02-03'),
(5, 6, '2026-02-03');

INSERT INTO lists (user_id, list_name, description, created_at, is_public) VALUES
(1, 'Top Sci-Fi', 'My favorite science fiction films.', '2026-02-05', 1),
(2, 'Must Watch', 'Movies everyone should watch once.', '2026-02-06', 1),
(3, 'Weekend Picks', 'Shortlist for weekend movie nights.', '2026-02-07', 1);

INSERT INTO list_movies (list_id, movie_id, added_at, position_in_list) VALUES
(1, 1, '2026-02-05 10:00:00', 1),
(1, 2, '2026-02-05 10:01:00', 2),
(2, 3, '2026-02-06 11:00:00', 1),
(2, 5, '2026-02-06 11:01:00', 2),
(3, 4, '2026-02-07 12:00:00', 1),
(3, 6, '2026-02-07 12:01:00', 2);

INSERT INTO diary_entries (user_id, movie_id, watch_date, notes, rewatch) VALUES
(1, 1, '2026-01-01', 'Rewatch before project demo.', 1),
(1, 2, '2026-01-02', 'Loved the soundtrack.', 0),
(2, 3, '2026-01-04', 'Great final act.', 0),
(3, 6, '2026-01-08', 'J.K. Simmons was amazing.', 0),
(4, 4, '2026-01-10', 'Beautiful animation details.', 1),
(5, 5, '2026-01-11', 'Ledger performance still iconic.', 1);

COMMIT;
