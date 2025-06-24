-- ==================================================
-- ⚙️ TRIGGERS
-- Triggers automatically execute SQL code in response to an event (INSERT, UPDATE, DELETE).
-- In this case, when we insert a new employee into `employee_demographic`,
-- we want to automatically insert a matching row into `employee_salary`.
-- ==================================================
-- You do this:                                This happens automatically:
-- ┌────────────────────────────┐              ┌────────────────────────────────┐
-- │ INSERT INTO employee_demographic (...) │ ───► │ INSERT INTO employee_salary (...) │
-- └────────────────────────────┘              └────────────────────────────────┘


USE data_emp;

-- Set a custom delimiter to support multi-statement triggers
DELIMITER $$

-- Drop the trigger if it already exists
DROP TRIGGER IF EXISTS after_employee_demographic_insert $$

-- Create the trigger on employee_demographic table
CREATE TRIGGER after_employee_demographic_insert
AFTER INSERT ON employee_demographic
FOR EACH ROW
BEGIN
    -- Automatically insert salary info for the new employee with placeholder values
    INSERT INTO employee_salary (
        employee_id, first_name, last_name, occupation, salary, dept_id
    )
    VALUES (
        NEW.employee_id, NEW.first_name, NEW.last_name, 'TBD', 50000, 1
    );
END $$

-- Reset the delimiter
DELIMITER ;

-- ✅ Test the trigger
-- Inserting a new employee will also create a salary record automatically
INSERT INTO employee_demographic (
    employee_id, first_name, last_name, age, gender, birth_date
)
VALUES (100, 'Leila', 'Mehdi', 33, 'Female', '1991-01-01');

-- Verify both tables
SELECT * FROM employee_demographic WHERE employee_id = 100;
SELECT * FROM employee_salary WHERE employee_id = 100;

-- Clean up test data
DELETE FROM employee_salary WHERE employee_id = 100;
DELETE FROM employee_demographic WHERE employee_id = 100;

-- ==================================================
-- ⏰ EVENTS
-- Events are scheduled SQL jobs that run automatically.
-- Example: Automatically delete employees aged 60+ every 1 minute.
-- ==================================================

-- Turn on the event scheduler (run only once per session or globally if needed)
SET GLOBAL event_scheduler = ON;

-- Check if the event scheduler is active
SHOW VARIABLES LIKE 'event_scheduler';

-- Drop the event if it already exists
DROP EVENT IF EXISTS retire_employees;

-- Set custom delimiter for multi-statement event
DELIMITER $$

-- Create an event to run every 1 minute and delete older employees
CREATE EVENT retire_employees
ON SCHEDULE EVERY 1 MINUTE
DO
BEGIN
    DELETE FROM employee_demographic
    WHERE age >= 60;
END $$

-- Reset the delimiter
DELIMITER ;

-- ✅ Verify the event
SHOW EVENTS;

-- Insert an employee aged over 60 for testing
INSERT INTO employee_demographic (
    employee_id, first_name, last_name, age, gender, birth_date
)
VALUES (101, 'Mohamed', 'Kaci', 65, 'Male', '1959-01-01');

-- Check if he's inserted
SELECT * FROM employee_demographic WHERE employee_id = 101;

-- ⏳ Wait at least 1–2 minutes, then check again — he should be gone
SELECT * FROM employee_demographic WHERE employee_id = 101;
