-- step 1: create movie table
CREATE TABLE films (
  id serial PRIMARY KEY,
  name text UNIQUE,
  release_year int
  );
-- step 2: insert data
INSERT INTO films (name, release_year)
VALUES ('Fast and Furious', '2019'),
	    ('Peter Pan', '2008'),
        ('The Matrix', '2011'),
        ('The notebook', '2014'),
        ('Death note', '2018');

-- step 3: select the table
SELECT * FROM films;

-- step 4: update row values
UPDATE films
SET release_year = '1999'
WHERE name = 'The Matrix';


-- step 5: find all movies released in 2002
SELECT * FROM films
WHERE release_year = '2002';

-- step 6: adding new columns
ALTER TABLE films
ADD COLUMN runtime INTEGER;

-- step 7: backfill null columns
UPDATE films
SET runtime = 150, category = 'Scifi', rating = 3.9, box_office_earnings = 2750000000
WHERE name = 'Star wars';

UPDATE films
SET runtime = 120, category = 'Scifi', rating = 4.8, box_office_earnings = 5750000000
WHERE name = 'Spiderman';

-- step 8: add constraint on an already existing column
ALTER TABLE films
ADD CONSTRAINT unique_release UNIQUE (name);

-- step 9: add constraints to restrict future values if there are no initial values
ALTER TABLE films
ALTER COLUMN category SET NOT NULL,
ALTER COLUMN runtime SET NOT NULL,
ALTER COLUMN box_office_earnings SET NOT NULL,
ALTER COLUMN rating SET NOT NULL;