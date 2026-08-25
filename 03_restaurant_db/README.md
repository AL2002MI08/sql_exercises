# Restaurant Database Design

## Project Description
Design and manage a relational restaurant database in PostgreSQL, modeling one-to-one, one-to-many, and many-to-many relationships across restaurants, addresses, reviews, categories, and dishes.

## Tasks Completed
- Created tables with primary keys, foreign keys, and unique constraints for `restaurant`, `address`, `category`, `dish`, `review`, and cross-reference table `categories_dishes`
- Validated table key constraints using `information_schema.key_column_usage`
- Inserted sample records for restaurant details, addresses, reviews, categories, and dish pricing
- Queried restaurant contact and location details using a one-to-one join
- Retrieved the highest rated restaurant review using a Common Table Expression (CTE)
- Queried and sorted menu items by dish name and category name using multi-table joins
- Filtered menu items to display spicy dishes with category and price information
- Identified and counted dishes associated with multiple categories using `GROUP BY` and `HAVING`

## Structure
```text
03_restaurant_db/
├── README.md       # Project description and tasks
└── solution.sql    # Table definitions, seed data, and queries
```
