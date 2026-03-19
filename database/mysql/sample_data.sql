-- Sample data for Letterboxd Clone schema (MySQL)
-- Run after mysql/schema.sql

START TRANSACTION;

INSERT INTO users (username, email, password_hash, join_date, bio) VALUES
('Shreyash', 'shreyash@example.com', 'hash_shreyash', '2025-01-10', 'Movie buff and sci-fi lover.'),
('Kavya', 'kavya@example.com', 'hash_kavya', '2025-02-14', 'Writes short reviews every weekend.'),
('Naman', 'naman@example.com', 'hash_naman', '2025-03-05', 'Collects top-100 lists.'),
('Ishant', 'ishant@example.com', 'hash_ishant', '2025-04-01', 'Animation fan.'),
('Aayaan', 'aayaan@example.com', 'hash_aayaan', '2025-05-19', 'Likes thrillers and mysteries.'),
('Shubhankar', 'shubhankar@example.com', 'hash_shubhankar', '2025-06-10', 'Documentary and indie fan.'),
('Tanmay', 'tanmay@example.com', 'hash_tanmay', '2025-07-22', 'Keeps detailed diary entries.'),
('Ansh', 'ansh@example.com', 'hash_ansh', '2025-08-30', 'Likes world cinema and detective stories.');

INSERT INTO movies (title, release_year, duration_minutes, language, description) VALUES
('Inception', 2010, 148, 'English', 'A thief enters dreams to steal ideas.'),
('Interstellar', 2014, 169, 'English', 'Explorers travel through a wormhole to save humanity.'),
('Parasite', 2019, 132, 'Korean', 'A poor family infiltrates a wealthy household.'),
('Spirited Away', 2001, 125, 'Japanese', 'A girl enters a spirit world to rescue her parents.'),
('The Dark Knight', 2008, 152, 'English', 'Batman faces the Joker in Gotham.'),
('Whiplash', 2014, 107, 'English', 'A drummer pushes toward perfection.'),
('Arrival', 2016, 116, 'English', 'A linguist helps communicate with alien visitors.'),
('The Grand Budapest Hotel', 2014, 99, 'English', 'A concierge and lobby boy navigate a murder and inheritance plot.'),
('Your Name', 2016, 106, 'Japanese', 'Two teenagers mysteriously swap bodies across distance and time.'),
('Zodiac', 2007, 157, 'English', 'Journalists and detectives pursue a serial killer case.');

INSERT INTO actors (actor_name, birth_date) VALUES
('Leonardo DiCaprio', '1974-11-11'),
('Matthew McConaughey', '1969-11-04'),
('Song Kang-ho', '1967-01-17'),
('Rumi Hiiragi', '1987-08-01'),
('Christian Bale', '1974-01-30'),
('Miles Teller', '1987-02-20'),
('Amy Adams', '1974-08-20'),
('Ralph Fiennes', '1962-12-22'),
('Ryunosuke Kamiki', '1993-05-19'),
('Jake Gyllenhaal', '1980-12-19');

INSERT INTO directors (director_name, birth_date) VALUES
('Christopher Nolan', '1970-07-30'),
('Bong Joon-ho', '1969-09-14'),
('Hayao Miyazaki', '1941-01-05'),
('Damien Chazelle', '1985-01-19'),
('Denis Villeneuve', '1967-10-03'),
('Wes Anderson', '1969-05-01'),
('Makoto Shinkai', '1973-02-09'),
('David Fincher', '1962-08-28');

INSERT INTO genres (genre_name) VALUES
('Sci-Fi'),
('Drama'),
('Thriller'),
('Animation'),
('Crime'),
('Romance'),
('Mystery'),
('Comedy');

INSERT INTO movie_actors (movie_id, actor_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

INSERT INTO movie_directors (movie_id, director_id) VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 3),
(5, 1),
(6, 4),
(7, 5),
(8, 6),
(9, 7),
(10, 8);

INSERT INTO movie_genres (movie_id, genre_id) VALUES
(1, 1), (1, 3),
(2, 1), (2, 2),
(3, 2), (3, 3),
(4, 4),
(5, 5), (5, 3),
(6, 2),
(7, 1), (7, 2),
(8, 2), (8, 8),
(9, 4), (9, 6),
(10, 5), (10, 3), (10, 7);

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
(5, 1, 4.0, '2026-01-12 08:00:00'),
(1, 7, 4.5, '2026-01-13 09:30:00'),
(2, 7, 4.0, '2026-01-14 10:15:00'),
(3, 8, 4.5, '2026-01-15 11:00:00'),
(4, 9, 5.0, '2026-01-16 19:00:00'),
(5, 10, 4.5, '2026-01-17 21:00:00'),
(6, 7, 4.0, '2026-01-18 08:20:00'),
(6, 10, 4.5, '2026-01-19 08:30:00'),
(7, 9, 4.5, '2026-01-20 18:00:00'),
(7, 8, 4.0, '2026-01-21 18:10:00'),
(8, 10, 5.0, '2026-01-22 22:00:00'),
(8, 3, 4.5, '2026-01-23 22:10:00'),
(2, 10, 4.5, '2026-01-24 10:10:00'),
(3, 7, 4.0, '2026-01-25 11:20:00'),
(4, 8, 4.0, '2026-01-26 17:40:00'),
(1, 9, 4.0, '2026-01-27 09:40:00');

INSERT INTO reviews (user_id, movie_id, review_text, review_date, contains_spoiler) VALUES
(1, 1, 'Mind-bending and visually stunning.', '2026-01-01', 0),
(1, 2, 'Emotional and ambitious sci-fi epic.', '2026-01-02', 0),
(2, 3, 'Sharp social commentary with perfect pacing.', '2026-01-04', 0),
(3, 6, 'Intense and stressful in the best way.', '2026-01-08', 0),
(4, 4, 'Magical world-building and heartfelt story.', '2026-01-10', 0),
(5, 5, 'One of the best comic-book films ever.', '2026-01-11', 0),
(1, 7, 'Thoughtful, tense, and emotionally grounded science fiction.', '2026-01-13', 0),
(2, 10, 'Meticulous mystery with a haunting mood.', '2026-01-24', 0),
(4, 9, 'A warm and emotional animated romance.', '2026-01-16', 0),
(6, 7, 'Great atmosphere and first-contact concept.', '2026-01-18', 0),
(7, 8, 'Stylish visuals and delightful performances.', '2026-01-21', 0),
(8, 10, 'Very detailed investigation; the ending stayed with me.', '2026-01-22', 1);

INSERT INTO watchlist_entries (user_id, movie_id, added_date) VALUES
(1, 3, '2026-02-01'),
(1, 4, '2026-02-01'),
(2, 2, '2026-02-02'),
(3, 1, '2026-02-02'),
(4, 5, '2026-02-03'),
(5, 6, '2026-02-03'),
(2, 9, '2026-02-04'),
(3, 10, '2026-02-04'),
(6, 8, '2026-02-05'),
(7, 7, '2026-02-06'),
(8, 1, '2026-02-06'),
(8, 4, '2026-02-07'),
(5, 9, '2026-02-08');

INSERT INTO lists (user_id, list_name, description, created_at, is_public) VALUES
(1, 'Top Sci-Fi', 'My favorite science fiction films.', '2026-02-05', 1),
(2, 'Must Watch', 'Movies everyone should watch once.', '2026-02-06', 1),
(3, 'Weekend Picks', 'Shortlist for weekend movie nights.', '2026-02-07', 1),
(6, 'Underrated Gems', 'Excellent films that deserve more attention.', '2026-02-08', 1),
(7, 'Rainy Night Movies', 'Quiet films for late evenings.', '2026-02-09', 0),
(8, 'Mind Games', 'Twisty stories and psychological tension.', '2026-02-10', 1);

INSERT INTO list_movies (list_id, movie_id, added_at, position_in_list) VALUES
(1, 1, '2026-02-05 10:00:00', 1),
(1, 2, '2026-02-05 10:01:00', 2),
(2, 3, '2026-02-06 11:00:00', 1),
(2, 5, '2026-02-06 11:01:00', 2),
(3, 4, '2026-02-07 12:00:00', 1),
(3, 6, '2026-02-07 12:01:00', 2),
(4, 7, '2026-02-08 14:00:00', 1),
(4, 10, '2026-02-08 14:02:00', 2),
(4, 3, '2026-02-08 14:04:00', 3),
(5, 8, '2026-02-09 20:00:00', 1),
(5, 1, '2026-02-09 20:03:00', 2),
(6, 10, '2026-02-10 16:00:00', 1),
(6, 7, '2026-02-10 16:02:00', 2),
(6, 2, '2026-02-10 16:05:00', 3);

INSERT INTO diary_entries (user_id, movie_id, watch_date, notes, rewatch) VALUES
(1, 1, '2026-01-01', 'Rewatch before project demo.', 1),
(1, 2, '2026-01-02', 'Loved the soundtrack.', 0),
(2, 3, '2026-01-04', 'Great final act.', 0),
(3, 6, '2026-01-08', 'J.K. Simmons was amazing.', 0),
(4, 4, '2026-01-10', 'Beautiful animation details.', 1),
(5, 5, '2026-01-11', 'Ledger performance still iconic.', 1),
(2, 10, '2026-01-24', 'Liked the procedural detail.', 0),
(3, 7, '2026-01-25', 'Strong first-contact storytelling.', 0),
(4, 8, '2026-01-26', 'Loved the color palette.', 0),
(6, 7, '2026-01-18', 'Great score and atmosphere.', 1),
(6, 10, '2026-01-19', 'Still unsettling on rewatch.', 1),
(7, 9, '2026-01-20', 'Emotional ending.', 0),
(8, 10, '2026-01-22', 'Fincher never misses.', 0),
(8, 3, '2026-01-23', 'Revisited for class discussion.', 1),
(1, 9, '2026-01-27', 'Slow burn done right.', 0);

COMMIT;
