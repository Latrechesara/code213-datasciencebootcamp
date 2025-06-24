-- ================================================
-- TEMPORARY TABLES in MySQL 
-- ================================================

-- TEMP TABLES are visible only in the current session
-- They are useful to store intermediate results from complex queries.

-- 1. ✅ CREATE a temporary table manually
CREATE TEMPORARY TABLE temp_employee_notes (
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    note VARCHAR(255)
);

-- ✅ INSERT example data manually
INSERT INTO temp_employee_notes
VALUES 
    ('Sara', 'Latreche', 'Excellent librarian'),
    ('Amine', 'Benkacem', 'Promoted to Senior Engineer');

-- ✅ Query from the temporary table
SELECT * FROM temp_employee_notes;

-- This table is NOT visible in the permanent schema
-- Refreshing your database objects will NOT show it.

-- ================================
-- 2. ✅ Create a temporary table from SELECT
-- ================================

-- Create a temp table with employees who earn more than 100,000 DA
CREATE TEMPORARY TABLE high_earners AS
SELECT 
    es.employee_id,
    es.first_name,
    es.last_name,
    es.occupation,
    es.salary,
    ed.gender,
    ed.age
FROM employee_salary es
JOIN employee_demographic ed ON es.employee_id = ed.employee_id
WHERE es.salary > 100000;

-- ✅ Now query from that temp table
SELECT * FROM high_earners;

-- You can also filter or do aggregations on the temporary table
SELECT gender, COUNT(*) AS num_high_earners
FROM high_earners
GROUP BY gender;

-- Example: average salary of high earners by gender
SELECT gender, ROUND(AVG(salary), 1) AS avg_high_salary
FROM high_earners
GROUP BY gender;

-- ================================
-- ⚠️ Important Notes
-- ================================
-- ❗Temp tables are automatically dropped when the session ends
-- ❗You cannot see them in the database schema tree
-- ❗They are isolated to your current connection (other users can’t see them)
-- ❗You can reuse the name again without DROP, but only after the session ends

-- If you try to create the same temp table again in the same session, you'll get an error unless you drop it first:
DROP TEMPORARY TABLE IF EXISTS high_earners;
