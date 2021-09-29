

-- Exercise1: Join all fields of order and orderdetails
SELECT * 
FROM orders 
INNER JOIN orderdetails 
ON orders.orderNumber = orderdetails.orderNumber;


-- Exercise2: Join all fields of order and orderdetails. Display only orderNumber, status and sum of totalsales (quantityOrdered * priceEach) for each orderNumber.
SELECT 
    t1.orderNumber,
    t1.status,
    SUM(quantityOrdered * priceEach) totalsales
FROM
    orders t1
INNER JOIN orderdetails t2 
    ON t1.orderNumber = t2.orderNumber
GROUP BY orderNumber;


-- Exercise3: We want to how the employees are performing. Join orders, customers and employees and return orderDate,lastName, firstName
SELECT orderDate,lastName, firstName
FROM orders t1
INNER JOIN customers t2
USING (customerNumber)
INNER JOIN employees t3
ON t2.salesRepEmployeeNumber = t3.employeeNumber;


   
