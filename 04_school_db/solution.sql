CREATE TABLE schools (
  id serial PRIMARY KEY,
  name varchar(100) NOT NULL,
  address varchar(255),
  telephone varchar(20)
);

CREATE TABLE academic_years (
  id serial PRIMARY KEY,
  year_name varchar(50) NOT NULL,
  start_date date NOT NULL,
  end_date date NOT NULL
);

CREATE TABLE teachers (
  id serial PRIMARY KEY,
  school_id integer REFERENCES schools(id) ON DELETE CASCADE,
  first_name varchar(50) NOT NULL,
  last_name varchar(50) NOT NULL,
  email varchar(100) UNIQUE NOT NULL,
  hire_date date
);

CREATE TABLE students (
  id serial PRIMARY KEY,
  school_id integer REFERENCES schools(id) ON DELETE CASCADE,
  first_name varchar(50) NOT NULL,
  last_name varchar(50) NOT NULL,
  email varchar(100) UNIQUE NOT NULL,
  date_of_birth date NOT NULL,
  enrollment_date date DEFAULT CURRENT_DATE
);

CREATE TABLE courses (
  id serial PRIMARY KEY,
  school_id integer REFERENCES schools(id) ON DELETE CASCADE,
  code varchar(20) NOT NULL,
  title varchar(100) NOT NULL,
  description text,
  credits integer DEFAULT 3
);

CREATE TABLE sections (
  id serial PRIMARY KEY,
  course_id integer REFERENCES courses(id) ON DELETE CASCADE,
  academic_year_id integer REFERENCES academic_years(id) ON DELETE RESTRICT,
  teacher_id integer REFERENCES teachers(id) ON DELETE SET NULL,
  section_number varchar(10) NOT NULL,
  room_number varchar(50),
  schedule_time varchar(100)
);

CREATE TABLE enrollments (
  student_id integer REFERENCES students(id) ON DELETE CASCADE,
  section_id integer REFERENCES sections(id) ON DELETE CASCADE,
  enrollment_date date DEFAULT CURRENT_DATE,
  letter_grade varchar(5),
  PRIMARY KEY (student_id, section_id)
);

INSERT INTO schools (name, address, telephone) VALUES
  ('University of Kigali (UoK)', 'KG 541 St, Kigali', '+250788303385'),
  ('Kigali Independent University (ULK)', 'KK 27 Ave, Gisozi, Kigali', '+250788303600'),
  ('African Leadership University (ALU)', 'Kigali Innovation City, Kigali', '+250788123456');

INSERT INTO academic_years (year_name, start_date, end_date) VALUES
  ('2024-2025', '2024-09-01', '2025-06-15'),
  ('2025-2026', '2025-09-01', '2026-06-15');

INSERT INTO teachers (school_id, first_name, last_name, email, hire_date) VALUES
  (1, 'Alice', 'Mugabo', 'alice.mugabo@uok.ac.rw', '2021-08-15'),
  (1, 'Robert', 'Kwizera', 'robert.kwizera@uok.ac.rw', '2020-01-10'),
  (2, 'Jean', 'Ndayisaba', 'jean.ndayisaba@ulk.ac.rw', '2019-09-01'),
  (3, 'Amina', 'Mutua', 'amina.mutua@alueducation.com', '2022-01-15');

INSERT INTO students (school_id, first_name, last_name, email, date_of_birth, enrollment_date) VALUES
  (1, 'Emma', 'Umutoni', 'emma.u@uok.ac.rw', '2003-04-15', '2022-09-01'),
  (1, 'Daniel', 'Mugisha', 'daniel.m@uok.ac.rw', '2002-07-23', '2022-09-01'),
  (2, 'Christian', 'Kayitare', 'christian.k@ulk.ac.rw', '2001-08-24', '2021-09-01'),
  (3, 'Grace', 'Bahati', 'grace.b@alueducation.com', '2003-06-01', '2022-09-01');

INSERT INTO courses (school_id, code, title, description, credits) VALUES
  (1, 'SWE-101', 'Introduction to Software Engineering', 'Core principles of software development, git, and lifecycle', 3),
  (1, 'BUS-201', 'Corporate Finance', 'Financial analysis, budgeting, and investment strategies', 3),
  (2, 'SWE-202', 'Data Structures & Algorithms', 'Fundamental algorithms, time complexity, and data structures', 4),
  (2, 'BUS-101', 'Principles of Management', 'Organizational behavior, leadership, and business strategy', 3),
  (3, 'SWE-301', 'Database Systems & Design', 'Relational database design, SQL, normalization, and ACID properties', 3),
  (3, 'BUS-305', 'International Business & Entrepreneurship', 'Global market expansion, innovation, and venture creation', 3);

INSERT INTO sections (course_id, academic_year_id, teacher_id, section_number, room_number, schedule_time) VALUES
  (1, 1, 1, '01', 'Lab Tech 1', 'MWF 09:00 - 10:30 AM'),
  (2, 1, 2, '01', 'Room B201', 'TTh 10:30 - 12:00 PM'),
  (3, 1, 3, '01', 'Lab 3', 'MWF 11:00 - 12:30 PM'),
  (4, 1, 3, '02', 'Room A102', 'TTh 01:00 - 02:30 PM'),
  (5, 1, 4, '01', 'Innovation Lab 1', 'MWF 02:00 - 03:30 PM');

INSERT INTO enrollments (student_id, section_id, enrollment_date, letter_grade) VALUES
  (1, 1, '2026-01-06', 'A'),
  (1, 2, '2026-05-21', 'B+'),
  (2, 1, '2025-09-15', 'A-'),
  (2, 2, '2025-01-06', 'A'),
  (3, 3, '2025-03-24', 'B'),
  (3, 4, '2026-01-03', 'C+'),
  (4, 5, '2025-09-02', 'C-');

-- adding constraints and alter schema
ALTER TABLE schools
ADD COLUMN email varchar(100);

ALTER TABLE sections
ADD COLUMN max_capacity integer DEFAULT 30;

ALTER TABLE enrollments
ADD COLUMN numerical_grade decimal(5,2);

UPDATE schools
SET email = 'info@uok.ac.rw'
WHERE name = 'University of Kigali (UoK)';

UPDATE schools
SET email = 'info@ulk.ac.rw'
WHERE name = 'Kigali Independent University (ULK)';

UPDATE schools
SET email = 'admissions@alueducation.com'
WHERE name = 'African Leadership University (ALU)';

UPDATE enrollments
SET numerical_grade = 94.50
WHERE student_id = 1 AND section_id = 1;

UPDATE enrollments
SET numerical_grade = 88.00
WHERE student_id = 1 AND section_id = 2;

ALTER TABLE sections
ADD CONSTRAINT check_positive_capacity CHECK (max_capacity > 0);

ALTER TABLE enrollments
ADD CONSTRAINT check_valid_grade CHECK (numerical_grade BETWEEN 0 AND 100);

-- get students plus course, section, teacher, and grade
SELECT students.first_name, students.last_name, courses.title AS course,
       sections.section_number, teachers.last_name AS teacher, enrollments.letter_grade
FROM students
INNER JOIN enrollments
  ON students.id = enrollments.student_id
INNER JOIN sections
  ON enrollments.section_id = sections.id
INNER JOIN courses
  ON sections.course_id = courses.id
LEFT JOIN teachers
  ON sections.teacher_id = teachers.id
ORDER BY courses.title, sections.section_number, students.last_name;

-- total enrolled students per course
SELECT courses.code, courses.title, COUNT(enrollments.student_id) AS student_count
FROM courses
INNER JOIN sections
  ON courses.id = sections.course_id
LEFT JOIN enrollments
  ON sections.id = enrollments.section_id
GROUP BY courses.code, courses.title
ORDER BY student_count DESC;

-- average grade per course section
SELECT courses.title AS course, sections.section_number,
       ROUND(AVG(enrollments.numerical_grade), 2) AS average_grade
FROM sections
INNER JOIN courses
  ON sections.course_id = courses.id
INNER JOIN enrollments
  ON sections.id = enrollments.section_id
WHERE enrollments.numerical_grade IS NOT NULL
GROUP BY courses.title, sections.section_number;
