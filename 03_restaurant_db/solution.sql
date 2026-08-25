-- schema: create tables
CREATE TABLE restaurant (
  id integer PRIMARY KEY,
  name varchar(20),
  description varchar(100),
  rating decimal,
  telephone char(10),
  hours varchar(100)
);

CREATE TABLE address (
  id integer PRIMARY KEY,
  street_number char(10),
  street_name varchar(20),
  city varchar(20),
  state varchar(15),
  google_map_link varchar(50),
  restaurant_id integer REFERENCES restaurant(id) UNIQUE
);

CREATE TABLE category (
  id char(2) PRIMARY KEY,
  name varchar(20),
  description varchar(200)
);

CREATE TABLE dish (
  id integer PRIMARY KEY,
  name varchar(50),
  description varchar(200),
  hot_and_spicy boolean
);

CREATE TABLE review (
  id integer PRIMARY KEY,
  rating decimal,
  description varchar(100),
  date date,
  restaurant_id integer REFERENCES restaurant(id)
);

CREATE TABLE categories_dishes (
  category_id char(2) REFERENCES category(id),
  dish_id integer REFERENCES dish(id),
  PRIMARY KEY (category_id, dish_id),
  price money
);

-- validate table constraints
SELECT constraint_name, table_name, column_name
FROM information_schema.key_column_usage
WHERE table_name = 'address';

SELECT constraint_name, table_name, column_name
FROM information_schema.key_column_usage
WHERE table_name = 'categories_dishes';

-- insert values for restaurant
INSERT INTO restaurant VALUES (
  1,
  'Bytes of China',
  'Delectable Chinese Cuisine',
  3.9,
  '6175551212',
  'Mon - Fri 9:00 am to 9:00 pm, Weekends 10:00 am to 11:00 pm'
);

-- insert values for address
INSERT INTO address VALUES (
  1,
  '2020',
  'Busy Street',
  'Chinatown',
  'MA',
  'http://bit.ly/BytesOfChina',
  1
);

-- insert values for review
INSERT INTO review VALUES 
  (1, 5.0, 'Would love to host another birthday party at Bytes of China!', '2020-05-22', 1),
  (2, 4.5, 'Other than a small mix-up, I would give it a 5.0!', '2020-04-01', 1),
  (3, 3.9, 'A reasonable place to eat for lunch, if you are in a rush!', '2020-03-15', 1);

-- insert values for category
INSERT INTO category VALUES 
  ('C', 'Chicken', null),
  ('LS', 'Luncheon Specials', 'Served with Hot and Sour Soup or Egg Drop Soup and Fried or Steamed Rice between 11:00 am and 3:00 pm from Monday to Friday.'),
  ('HS', 'House Specials', null);

-- insert values for dish
INSERT INTO dish VALUES 
  (1, 'Chicken with Broccoli', 'Diced chicken stir-fried with succulent broccoli florets', false),
  (2, 'Sweet and Sour Chicken', 'Marinated chicken with tangy sweet and sour sauce together with pineapples and green peppers', false),
  (3, 'Chicken Wings', 'Finger-licking mouth-watering entree to spice up any lunch or dinner', true),
  (4, 'Beef with Garlic Sauce', 'Sliced beef steak marinated in garlic sauce for that tangy flavor', true),
  (5, 'Fresh Mushroom with Snow Peapods and Baby Corns', 'Colorful entree perfect for vegetarians and mushroom lovers', false),
  (6, 'Sesame Chicken', 'Crispy chunks of chicken flavored with savory sesame sauce', false),
  (7, 'Special Minced Chicken', 'Marinated chicken breast sauteed with colorful vegetables topped with pine nuts and shredded lettuce.', false),
  (8, 'Hunan Special Half & Half', 'Shredded beef in Peking sauce and shredded chicken in garlic sauce', true);

-- insert values for cross-reference table, categories_dishes
INSERT INTO categories_dishes VALUES 
  ('C', 1, 6.95),
  ('C', 3, 6.95),
  ('LS', 1, 8.95),
  ('LS', 4, 8.95),
  ('LS', 5, 8.95),
  ('HS', 6, 15.95),
  ('HS', 7, 16.95),
  ('HS', 8, 17.95);

-- step 10: get restaurant name, address, and telephone
SELECT restaurant.name, address.street_number, address.street_name, restaurant.telephone
FROM restaurant
JOIN address
  ON restaurant.id = address.restaurant_id;

-- step 11: get best review rating
WITH best_rating AS (
  SELECT MAX(rating) AS max_rating 
  FROM review
)
SELECT review.rating, review.description
FROM review
WHERE review.rating = (SELECT max_rating FROM best_rating);

-- step 12: display dishes sorted by dish_name
SELECT dish.name AS dish_name, categories_dishes.price AS price, category.name AS category
FROM dish
JOIN categories_dishes
  ON dish.id = categories_dishes.dish_id
JOIN category
  ON category.id = categories_dishes.category_id
ORDER BY dish_name;

-- step 13: display dishes sorted by category name
SELECT category.name AS category, dish.name AS dish_name, categories_dishes.price AS price
FROM dish
JOIN categories_dishes
  ON dish.id = categories_dishes.dish_id
JOIN category
  ON category.id = categories_dishes.category_id
ORDER BY category ASC;

-- step 14: spicy dishes
SELECT dish.name AS spicy_dish_name, category.name AS category, categories_dishes.price AS price
FROM dish
JOIN categories_dishes
  ON dish.id = categories_dishes.dish_id
JOIN category
  ON category.id = categories_dishes.category_id
WHERE dish.hot_and_spicy = true;

-- step 15, 16 & 17: get dish name and dish count for dishes in multiple categories
SELECT dish.name AS dish_name, COUNT(categories_dishes.dish_id) AS dish_count
FROM categories_dishes
JOIN dish
  ON categories_dishes.dish_id = dish.id
GROUP BY categories_dishes.dish_id, dish.name
HAVING COUNT(categories_dishes.dish_id) > 1;
