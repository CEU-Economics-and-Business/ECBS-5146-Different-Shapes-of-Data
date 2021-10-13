-- Exercise1: Copy the birdstrikes structure into a new tabe called birdstrikes2. Insert into birdstrikes2 the line where id is 10.
-- Hints:
-- Use the samples from Chapter2 for copy
-- For insert user the format like: INSERT INTO bla SELECT blabla


USE birdstrikes;

CREATE TABLE birdstrikes2 LIKE birdstrikes;

INSERT INTO birdstrikes2 SELECT * FROM  birdstrikes WHERE id=10;














-- Exercise2: Create a view, which contains product_sales rows of year 2003 and 2005. How many rows has the resulting view?

DROP VIEW IF EXISTS Year_2003and2005;

CREATE VIEW `Year_2003and2005` AS
SELECT * FROM product_sales WHERE product_sales.Date LIKE '2003%' OR product_sales.Date LIKE '2005%';

SELECT COUNT(*) FROM classicmodels.year_2003and2005;
-- 1575