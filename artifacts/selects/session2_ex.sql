
-- Exercise1: Based on the previous chapter, create a table called “employee” with two columns: “id” and “employee_name”. NULL values should not be accepted for these 2 columns.

CREATE TABLE employee (id INTEGER NOT NULL, employee_name VARCHAR(255) NOT NULL, PRIMARY KEY(id));
DESCRIBE employee;
SELECT * FROM employee;

-- Exercise2: What state figures in the 145th line of our database?
SELECT * FROM birdstrikes LIMIT 145;
SELECT * FROM birdstrikes LIMIT 144,10;
-- Tennessee


-- Exercise3: What is flight_date of the latest birstrike in this database?
SELECT * FROM birdstrikes as b ORDER BY b.flight_date DESC;
-- 20004018


-- Exercise4: What was the cost of the 50th most expensive damage?
SELECT DISTINCT cost FROM birdstrikes ORDER BY cost DESC LIMIT 49,1;
-- 5345

-- Exercise5: What state figures in the 2nd record, if you filter out all records which have no state and no bird_size specified?
SELECT * FROM birdstrikes WHERE state IS NOT NULL AND bird_size IS NOT NULL;
-- ''

-- Exercise6:  How many days elapsed between the current date and the flights happening in week 52, for incidents from Colorado? (Hint: use NOW, DATEDIFF, WEEKOFYEAR)
SELECT DATEDIFF(tab.flight_date, NOW()) FROM birdstrikes as tab WHERE WEEKOFYEAR(tab.flight_date) =52 AND state="Colorado"
-- 7576
