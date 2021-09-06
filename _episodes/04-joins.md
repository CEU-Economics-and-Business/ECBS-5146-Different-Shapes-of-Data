---
title: Joins
teaching: 90
questions:
- In normalized database, the data is structured in a way to avoid data redundancy and support consistency. As analyst, this structure is not always the best fit for analytics. Most of the time you need to merge one or more tables to get the required data set. Joins is offering a solution for this problem.
objectives:
- Understanding the difference between Operational and Analytical data layer
- Introducing Data Warehouse architectures
- Introducing a larger relational database
- Understanding the difference between different joins
- Present examples and exercise joins
keypoints:
- \#RELATIONAL DATASETS 
- \#JOINS
---


> ## Table of Content
> [Session setup](#setup)  
> [INNER joins](#inner)  
> [SELF joins](#self)  
> [LEFT joins](#left)  
> [Homework](#homework)    
{: .discussion}
  

<br/><br/><br/>
<a name="setup"/>
## Session setup

Install [sample database]({{ page.root }}/artifacts/joins/sampledatabase_create.sql) script. Credit: https://www.mysqltutorial.org/mysql-sample-database.aspx

<br/><br/>
#### Database diagram
![Database diagram]({{ page.root }}/artifacts/joins/sampledatabase_diagram.png)

<br/><br/><br/>
<a name="inner"/>
## INNER joins

#### Syntax 
```
SELECT *
FROM left_table
INNER JOIN right_table
ON left_table.id = right_table.id;
```
{: .language-sql}

<br/><br/>
#### Basic forms
Join all fields of products and productlines details

```
SELECT * 
FROM products 
INNER JOIN productlines  
ON products.productline = productlines.productline;
```
{: .language-sql}

Same thing, but now with USING:
```
SELECT t1.productLine, t2.textDescription
FROM products t1
INNER JOIN productlines t2 
USING(productline);
```
{: .language-sql}

Same thing with aliasing:
```
SELECT *
FROM products t1
INNER JOIN productlines t2 
USING(productline);
```
{: .language-sql}

<br/><br/>
#### Select specific columns
```
SELECT t1.productLine, t2.textDescription
FROM products t1
INNER JOIN productlines t2 
ON t1.productline = t2.productline;
```
{: .language-sql}

<br/><br/>
>## `Exercise1` 
> Join all fields of order and orderdetails
{: .challenge} 

<br/><br/>
>## `Exercise2` 
> Join all fields of order and orderdetails. Display only orderNumber, status and sum of totalsales (quantityOrdered * priceEach) for each orderNumber. 
{: .challenge} 

<br/>



#### Multiple INNER joins

```
SELECT *
FROM left_table
INNER JOIN right_table
ON left_table.id = right_table.id
INNER JOIN another_table
ON left_table.id = another_table.id;
```
{: .language-sql}

<br/>

>## `Exercise3` 
> We want to how the employees are performing. Join orders, customers and employees and return orderDate,lastName, firstName
{: .challenge} 

<br/><br/><br/>
<a name="self"/>

## SELF JOIN

Employee table represents a hierarchy, which can be flattened with a self join. The next query displays the Manager, Direct report pairs:

```
SELECT 
    CONCAT(m.lastName, ', ', m.firstName) AS Manager,
    CONCAT(e.lastName, ', ', e.firstName) AS 'Direct report'
FROM
    employees e
INNER JOIN employees m ON 
    m.employeeNumber = e.reportsTo
ORDER BY 
    Manager;
```
{: .language-sql}

<br/><br/>
>## `Exercise4` 
> Why President is not in the list?
{: .challenge} 

<br/><br/><br/>
<a name="left"/>

## LEFT JOIN

The next example returns customer info and related orders:

```
SELECT
    c.customerNumber,
    customerName,
    orderNumber,
    status
FROM
    customers c
LEFT JOIN orders o 
    ON c.customerNumber = o.customerNumber;
```
{: .language-sql}

<br/><br/>
#### Difference between LEFT and INNER join
The previous example returns all customers including the customers who have no order. If a customer has no order, the values in the column orderNumber and status are NULL. Try the same query with INNER join.

<br/><br/>
#### Difference between LEFT and RIGHT join
Right join is the mirror of the left join, you can achieve the same results with both. Rarely used.

<br/><br/>
#### WHERE with joins
```
SELECT 
    o.orderNumber, 
    customerNumber, 
    productCode
FROM
    orders o
LEFT JOIN orderDetails 
    USING (orderNumber)
WHERE
    orderNumber = 10123;
```
{: .language-sql}

<br/><br/>
#### ON 

In the next query, the WHERE clause is added to ON, yet, it will have a different meaning. In this case, the query returns all orders but only the order 10123 will have line items associated with it, as in the following statement:
```
SELECT 
    o.orderNumber, 
    customerNumber, 
    productCode
FROM
    orders o
LEFT JOIN orderDetails d 
    ON o.orderNumber = d.orderNumber AND 
       o.orderNumber = 10123;
```
{: .language-sql}

<br/><br/>
<a name="homework"/>

> ## Homework 4
> * INNER join orders,orderdetails,products and customers. Return back: 
>   - orderNumber
>   - priceEach
>    - quantityOrdered
>    - productName
>    - productLine
>    - city
>    - country
>    - orderDate
> * Upload your solution to your GitHub repo in a folder called HW4
> * Submit GitHub repo link to moodle when you are ready
{: .challenge} 