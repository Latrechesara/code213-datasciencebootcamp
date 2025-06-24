-- So let's look at how we can create a stored procedure

-- First let's just write a super simple query
SELECT *
FROM employee_salary
WHERE salary >= 60000;


-- Now let's put this into a stored procedure.
-- IMPORTANT: This is a basic procedure without BEGIN/END so it only supports one statement.
DROP PROCEDURE IF EXISTS large_salaries;

CREATE PROCEDURE large_salaries()
SELECT *
FROM employee_salary
WHERE salary >= 60000;

-- Now if we run this it will work and create the stored procedure
-- we can click refresh and see that it is there

-- notice it did not give us an output, that's because we have to call it:

CALL large_salaries();

-- as you can see it ran the query inside the stored procedure we created



-- Now how we have written it is not actually best practice.
-- Usually when writing a stored procedure you don't have a simple query like that. It's usually more complex

-- if we tried to add another query to this stored procedure it wouldn't work. It's a separate query:
-- This will fail or only return the first query
DROP PROCEDURE IF EXISTS large_salaries2;
CREATE PROCEDURE large_salaries2()
SELECT *
FROM employee_salary
WHERE salary >= 60000;
SELECT *
FROM employee_salary
WHERE salary >= 50000;

-- ❌ This will not work correctly. Let's do it the proper way.


-- ✅ Best practice: use a delimiter and a BEGIN...END block to group multiple statements

-- Change the delimiter to $$
DELIMITER $$
DROP PROCEDURE IF EXISTS large_salaries2;

CREATE PROCEDURE large_salaries2()
BEGIN
	SELECT *
	FROM employee_salary
	WHERE salary >= 60000;
	
	SELECT *
	FROM employee_salary
	WHERE salary >= 50000;
END $$

-- Reset the delimiter to default
DELIMITER ;

-- Now we can run this stored procedure
CALL large_salaries2();

-- As you can see, we have 2 outputs which are the 2 queries we had in our stored procedure



-- We can also create a stored procedure by right clicking on Stored Procedures and creating one in a GUI.
-- But let's continue using code to learn.

-- Let's drop and recreate it again but properly set the database name to `data_emp`

USE data_emp;

DROP PROCEDURE IF EXISTS large_salaries3;

DELIMITER $$

-- Stored procedure that filters on salary and also shows an additional block
CREATE PROCEDURE large_salaries3()
BEGIN
	SELECT *
	FROM employee_salary
	WHERE salary >= 60000;

	SELECT *
	FROM employee_salary
	WHERE salary >= 50000;
END $$

DELIMITER ;

-- Run the stored procedure
CALL large_salaries3();



-- -------------------------------------------------------------------------

-- We can also add parameters to stored procedures for flexibility

USE data_emp;
DROP PROCEDURE IF EXISTS large_salaries3;

DELIMITER $$

-- This version adds a parameter to filter by a specific employee
CREATE PROCEDURE large_salaries3(employee_id_param INT)
BEGIN
	SELECT *
	FROM employee_salary
	WHERE salary >= 60000
	  AND employee_id_param = employee_id;
END $$

DELIMITER ;

-- Now we can pass a parameter to filter the employee
CALL large_salaries3(1); -- Replace 1 with any other ID to test
