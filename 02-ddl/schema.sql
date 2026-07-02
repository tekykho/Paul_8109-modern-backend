-- Create new database
CREATE database swimming_coach;

-- Show all databases on the server
SHOW databases;

-- set the current active database
USE swimming_coach;

-- create table: tells SQL to create a new table
-- followed by the name of the table to create

CREATE TABLE parents (
    -- <name of column> <data type> <extra options>
    parent_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT, 
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) 
) ENGINE = INNODB;

-- Show all the tables in the current active database
SHOW TABLES;

CREATE TABLE students (
    student_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    parent_id INT UNSIGNED NOT NULL,
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45),
    dob DATETIME NOT NULL,
    swimming_level TINYINT NOT NULL
) ENGINE = INNODB;

-- Add a constraint
-- The constraint that we are adding is the foreign key relationship
ALTER TABLE students
 ADD CONSTRAINT fk_parents_students
    FOREIGN KEY(parent_id) REFERENCES parents(parent_id)
    ON DELETE CASCADE
    ON UPDATE RESTRICT; -- cannot change primary key (default)



CREATE TABLE locations (
    location_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    address VARCHAR(255) NOT NULL,
    open_at TIME,
    close_at TIME
) ENGINE = INNODB;

-- How to change a table
-- ALTER TABLE <table name> ADD COLUMN <name of new column> <data type> <options>
ALTER TABLE locations ADD COLUMN name VARCHAR(255) NOT NULL;

-- How to modify a column
ALTER TABLE locations MODIFY COLUMN address VARCHAR(1000) NOT NULL;

-- Drop columns (delete columns)
ALTER TABLE locations DROP COLUMN open_at;
ALTER TABLE locations DROP COLUMN close_at;

-- ALTER TABLE is subjected to constraints (such as foreign key constraints)

-- Delete an entire table
DROP TABLE locations;