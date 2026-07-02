
-- show the definitions for the columns in a table
DESCRIBE employees;

-- Get all the rows and all the columns from a given table
SELECT * FROM customers;

-- Show only the firstName, lastName, email and employeeNumber columns from the employees table
SELECT employeeNumber, firstName, lastName, email FROM employees;

-- in general,
-- SELECT <col_1, col_2,....col_n> FORM <table_name>

-- Select column and rename them
SELECT lastName AS "Last Name", firstName AS "First Name", email AS "Email" FROM employees;

-- select the customerName, contactLastName, contactFirstName and phone
-- but rename them to proper English, eg: "Customer Name"
SELECT customerName AS "Customer Name", 
       contactLastName AS "Contact Last Name",
	   contactFirstName as "Contact First Name",
	   phone AS "Phone"
FROM customers;

-- CONCAT function can combine two columns into  one
SELECT employeeNumber, CONCAT(firstName, " ", lastName) AS "Full Name" FROM employees

-- UCASE can convert the column to uppercase
SELECT employeeNumber, CONCAT(firstName, " ", lastName) AS "Full Name", UCASE(email) FROM employees

-- only show employees from officeCode 1
SELECT * FROM employees WHERE officeCode=1

-- only show employees from officeCode 1
SELECT lastName AS "Last Name", firstName AS "First Name",
      email AS "Email", officeCode AS "Office Code" FROM employees WHERE officeCode=1

-- string comparison in SQL is case in-sensitive
select * from employees WHERE jobTitle="sales rep";
SELECT * FROM employees WHERE jobTitle LIKE "sales rep";

-- we can use LIKE with string patterns
-- the % is a placeholder (i.e a wildcard). It can match anything
-- Get all the sales manager
SELECT * FROM employees WHERE jobTitle LIKE "Sale% Manager%"

-- get all the employees with the word "sales" in their job title
SELECT * FROM employees WHERE jobTitle LIKE "%Sale%"

-- comparison operators work as in a programming language
select * from customers WHERE creditLimit > 0;

-- combining inequality with logical
-- find all customers which creditLimit is between 10K to 50K
SELECT * FROM customers
WHERE creditLimit >= 10000 AND creditLimit < 50000;

-- alternatively...
SELECT * FROM customers
WHERE creditLimit BETWEEN 10000 AND 50000;

-- Logical operators
-- AND / OR

-- select all the sales rep from office code 1
SELECT * FROM employees WHERE officeCode=1 AND jobTitle="sales rep";

-- Get only the unique values
SELECT DISTINCT(status) FROM orders;

-- Get all the orders that have been shipped or cancelled
SELECT * FROM orders WHERE status="Shipped" OR status="Cancelled";

-- when mixing AND / OR together, the order of precedence is important
-- the following actually select ALL employees from office code 1 and ONLY sales rep from office code 2.
select * from employees WHERE officeCode = 1 OR officeCode = 2 AND jobTitle = "Sales Rep";

-- when mixing AND / OR together, the order of precedence is important
-- the following actually select ALL employees from office code 1 and ONLY sales rep from office code 2.
select * from employees WHERE (officeCode = 1 OR officeCode = 2) AND jobTitle = "Sales Rep";

-- Sort tables

-- sort the customers by credit limit (default is ascending order)
SELECT * FROM customers ORDER BY creditLimit;

-- sort the customers by credit limit (default is ascending order)
SELECT * FROM customers ORDER BY creditLimit DESC;

-- Limit the number of rows returned
-- sort the customers by credit limit (default is ascending order)
SELECT * FROM customers ORDER BY creditLimit DESC LIMIT 10;