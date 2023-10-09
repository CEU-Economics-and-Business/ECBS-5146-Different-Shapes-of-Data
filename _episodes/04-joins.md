---
title: Data modeling. Joins.
teaching: 90
questions:
- How do you design/model a database?
- In normalized database, the data is structured in a way to avoid data redundancy and support consistency. As analyst, this structure is not always the best fit for analytics. How do you merge one or more tables to get the required data set?
objectives:
- Understanding the basics of data modelling
- Practicing data modelling
- Introducing a larger relational database
- Understanding the difference between different joins
- Present examples and exercise joins
keypoints:
- \#DATA MODELLING
- \#RELATIONAL DATASETS 
- \#JOINS
---


> ## Table of Content 
> [Lecture PPTX]({{ page.root }}/artifacts/joins/joins.pptx)  
> [Data modeling](#model)  
> [INNER joins](#inner)  
> [SELF joins](#self)  
> [LEFT joins](#left)  
> [Homework](#homework)    
{: .discussion}
  

<br><br>
<a name="setup"/>
> ## Prerequisites for this chapter
>   Load [sample database]({{ page.root }}/artifacts/joins/sampledatabase_create.sql) script into your local MySQL instance. [[Credit]](https://www.mysqltutorial.org/mysql-sample-database.aspx)
{: .prereq} 

<br/><br/>
## Sample database diagram
![Database diagram]({{ page.root }}/artifacts/joins/sampledatabase_diagram.png)


<br/><br/><br/>
<a name="model"/>
## Data modeling

There are many types of data models: hierarchical, network, relational etc. Today we will focus on Relational Data modeling.

Several techniques can be used for modeling. Today we will use the most widespread: Entity–relationship modelling (ERM).

>## `Modelling game - University` 
> Let's model in a group of 3 a data structure of a University. Mandatory elements: Program, Program Coordinator, Course, Prerequisite Course, Student, Instructor.
{: .challenge} 





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


Same thing with aliasing:
```
SELECT *
FROM products t1
INNER JOIN productlines t2 
ON t1.productline = t2.productline;
```
{: .language-sql}

Same thing, but now with USING:
```
SELECT *
FROM products 
INNER JOIN productlines 
USING(productline);
```
{: .language-sql}



<br/><br/>
#### Select specific columns
```
SELECT t1.productName, t1.productLine, t2.textDescription
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
> We want to know how the employees are performing. Join orders, customers and employees and return orderDate,lastName, firstName
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
INNER JOIN orderDetails 
    USING (orderNumber)
WHERE
    orderNumber = 10123;
```
{: .language-sql}

<br/><br/>
#### ON 

The next query gives the same result yet, the mechanism behind is very different: WHERE does the filtering (o.orderNumber = 10123) <i>after</i> the join is executed, while in case of ON, the join will happen on the specified subset (o.orderNumber = 10123)
```
SELECT 
    o.orderNumber, 
    customerNumber, 
    productCode
FROM
    orders o
INNER JOIN orderDetails d 
    ON o.orderNumber = d.orderNumber AND 
       o.orderNumber = 10123;
```
{: .language-sql}


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
>## `Question` 
> Why President is not in the list?
{: .challenge} 

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
