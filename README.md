# LetterBoxd_clone

Letterboxd-style movie tracking system for a DBMS project.

## Project Scope

This repository contains:

- ER design reference in `ER_Diagram.md`
- MySQL relational schema scripts
- sample seed data
- 10 SQL test queries for validation/demo

The data model supports:

- users
- movies
- reviews
- ratings
- watchlists
- custom lists
- diary/watch logs
- actors/directors/genres with many-to-many movie mappings

## Repository Structure

```text
.
|- ER_Diagram.md
|- database/
|  `- mysql/
|     |- schema.sql
|     |- sample_data.sql
|     `- test_queries.sql
`- README.md
```

## Database Version

MySQL 8.0+ scripts:
- `database/mysql/schema.sql`
- `database/mysql/sample_data.sql`
- `database/mysql/test_queries.sql`

## How To Run (MySQL)

### In MySQL shell

```sql
SOURCE database/mysql/schema.sql;
SOURCE database/mysql/sample_data.sql;
SOURCE database/mysql/test_queries.sql;
```

### From terminal

```bash
mysql -u <username> -p <database_name> < database/mysql/schema.sql
mysql -u <username> -p <database_name> < database/mysql/sample_data.sql
mysql -u <username> -p <database_name> < database/mysql/test_queries.sql
```

## Test Queries Included

`database/mysql/test_queries.sql` includes 10 verification queries that cover:

1. user activity summary (ratings + reviews)
2. top-rated movies
3. movie review listing
4. public list contents
5. watchlist retrieval
6. diary and rewatch stats
7. genre-wise ratings
8. director film counts
9. actor filmography
10. recommendation-style query based on favorite genre

## Notes

- Schema includes primary keys, foreign keys, unique constraints, check constraints, and performance indexes.
- Sample data is intentionally small and readable for viva/demo usage.
- Requires MySQL 8.0+ (CTE/window function support in query 10).
