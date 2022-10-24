
-- Exercise1: Create a stored procedure which displays the first X entries of payment table. X is IN parameter for the procedure.

DROP PROCEDURE IF EXISTS GetFirstXPayments;

DELIMITER //

CREATE PROCEDURE GetFirstXPayments(
	IN x INT
)
BEGIN
	SELECT * FROM payments LIMIT x;
END //
DELIMITER ;

CALL GetFirstXPayments(18);




-- Exercise2: Create a stored procedure which returns the amount for Xth entry of payment table. X is IN parameter for the procedure. Display the returned amount.

DROP PROCEDURE IF EXISTS GetAmountForXthPayments;

DELIMITER //

CREATE PROCEDURE GetAmountForXthPayments(
	IN x INT,
    OUT amountout DECIMAL(10,2)
)
BEGIN
	SET x = x-1;
	SELECT amount INTO amountout FROM payments LIMIT x,1;
END //
DELIMITER ;

CALL GetAmountForXthPayments(4,@amount);
SELECT @amount;



-- Exercise3:  Create a stored procedure which returns category of a given row in payments. Row number is IN parameter, while category is OUT parameter. Display the returned category. CAT1 - amount > 100.000, CAT2 - amount > 10.000, CAT3 - amount <= 10.000

DROP PROCEDURE IF EXISTS GetCategoryOfXthPayments;

DELIMITER //

CREATE PROCEDURE GetCategoryOfXthPayments(
	IN x INT,
    OUT category VARCHAR(10)
)

BEGIN
	DECLARE xthamount DECIMAL(10,2) DEFAULT 0;
	SET x = x-1;
	SELECT amount 
		INTO xthamount
			FROM payments
				LIMIT x,1;
		         
	IF xthamount > 100000 THEN
		SET category = 'CAT1';
	ELSEIF xthamount > 10000  THEN
		SET category = 'CAT2';
	ELSE 
		SET category = 'CAT3';
	END IF;
            
END //
DELIMITER ;

CALL GetCategoryOfXthPayments(18,@category);
SELECT @category;



USE classicmodels;

-- Exercise4: Create a loop which counts to 5 and displays the actual count in each step as SELECT (eg. SELECT x) 

DROP PROCEDURE IF EXISTS LoopDemo;

DELIMITER $$
CREATE PROCEDURE LoopDemo()
BEGIN
	DECLARE x  INT DEFAULT 0;
    
	myloop: LOOP 
	           
		SET  x = x + 1;
		SELECT x;
           
		IF  (x = 5) THEN
			LEAVE myloop;
         	END  IF;
         
	END LOOP myloop;
END$$
DELIMITER ;

CALL LoopDemo();

-- ex5

DROP PROCEDURE IF EXISTS fetch_ordernum_shippeddate;
DELIMITER $$
CREATE PROCEDURE fetch_ordernum_shippeddate()
BEGIN
	DECLARE ordernum INT;
	DECLARE shippeddate DATE;
    DECLARE finished INTEGER DEFAULT 0;
	-- DECLARE CURSOR
	DECLARE cursor1 CURSOR FOR SELECT orders.customerNumber, orders.shippedDate FROM classicmodels.orders;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
	-- OPEN CURSOR
	OPEN cursor1;
	TRUNCATE messages;
	myloop: LOOP
		-- FETCH CURSOR
		FETCH cursor1 INTO ordernum, shippeddate;
		INSERT INTO messages SELECT CONCAT(ordernum, ":", COALESCE(shippeddate,''));
		IF finished = 1 THEN LEAVE myloop;
		END IF;
	END LOOP myloop;
	-- CLOSE CURSOR
	CLOSE cursor1;
END$$
DELIMITER ;
CALL fetch_ordernum_shippeddate();
SELECT * FROM messages;


