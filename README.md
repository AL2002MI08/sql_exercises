# SQL Exercises

A collection of hands-on SQL exercises and database projects covering relational database design, querying, data manipulation, schema management, and data integrity with PostgreSQL.

---

## Repository Structure

```text
sql_exercises/
├── 01_movies_db/
│   ├── README.md       # Exercise overview and tasks
│   └── solution.sql    # SQL queries
└── README.md           # Main repository documentation
```

---

## Technologies & Tools

- **Database**: PostgreSQL
- **Language**: SQL
- **Database Clients / GUI**: Postbird, pgAdmin, or `psql` CLI

---

## Getting Started

### 1. Prerequisites
Ensure you have PostgreSQL installed and running locally, or access to a PostgreSQL instance.

### 2. Running SQL Scripts
Execute any exercise script using `psql` or your preferred SQL GUI client:

```bash
# Using psql CLI
psql -U <username> -d <database_name> -f 01_movies_db/solution.sql
```

Or copy and run the SQL statements directly inside your client's query editor.

---

## Git Workflow

1. **Branching Strategy**:
   - `main`: Stable, completed solutions.
   - `dev`: Active development and working branch for new exercises.
2. **Adding a New Exercise**:
   - Create a numbered directory (e.g., `02_ecommerce_db/`).
   - Add `solution.sql` with your SQL queries and a `README.md` describing the tasks.
