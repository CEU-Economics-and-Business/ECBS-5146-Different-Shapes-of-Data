---
title: Course intro. First steps in SQL. 
teaching: 90
questions:
- What is data engineering and why it is important for data analysts? 
- How to access a data set, stored in a database?
- How to load various data files (eg. csv) into database?
objectives:
- Setting the context - evolution of digital persistency 1950-2010
- Introducing the basic terms, in context of SQL
- Writing the first SQL
- Setting local MYSQL / Workbench (Expected to be done prior to the course)
- Understanding how to work in MySQL Workbench
- Creating and exploring the first MySQL database
- Understanding how to backup and restore a database
keypoints:
- \#INTRO 
- \#LOCAL ENVIRONMENT 
- \#BASIC SQL 
- \#YOUR FIRST DATABASE 
- \#DUMPS

---


> ## Table of Content
> [Lecture PPTX]({{ page.root }}/artifacts/intro/intro.pptx)
>
> [SQL in 6 minutes](#sql5)
>
> [First look on MySQL and MySQL Workbench](#firslook)
>
> [Your first local MySQL Database](#firstdb)
>
> [Exploring your first database](#explore)
>
> [Dumping and restoring a database with MySQL Workbench](#dump)
>
> [Homework](#homework)  
{: .discussion}


<br><br>
<a name="setup"/>
> ## Prerequisites for this chapter
>   * Install:  [MySQL Community Server](https://dev.mysql.com/downloads/), [MySQL Workbench](https://dev.mysql.com/downloads/) 
{: .prereq} 




<br/><br/>
<a name="sql5"/>

## SQL in 6 minutes



Browse to [https://www.w3schools.com/sql/trysql.asp?filename=trysql_op_in](https://www.w3schools.com/sql/trysql.asp?filename=trysql_op_in)


#### Query 1
```
SELECT * FROM customers;
```
{: .language-sql}

#### Query 2
```
SELECT supplierName, COUNT(*) AS 'number of products' FROM suppliers
INNER JOIN products
	ON products.SupplierID = suppliers.SupplierID
GROUP BY suppliers.SupplierID;
```
{: .language-sql}

#### Query 3
```
SELECT 	o.OrderDate,
       	o.OrderID,
       	o.ShipperID,
       	ROUND(SUM(od.Quantity * p.Price), 0) AS Basket,
	CASE WHEN od.Quantity < 30 THEN 'SMALLQ' ELSE 'HIGHQ' END as QuantityLabel
FROM Orders AS o
     LEFT JOIN OrderDetails AS od ON od.OrderID = o.OrderID
     INNER JOIN ( SELECT * FROM Products WHERE Price >= 100 ) AS p on p.ProductID = od.ProductID
GROUP BY o.OrderID,
         o.ShipperID
HAVING Basket >= 1000
ORDER BY o.OrderDate DESC, o.OrderID;
```
{: .language-sql}


<br/><br/><br/>
<a name="firstdb"/>

## First look on MySQL and MySQL Workbench
[Screenshot help]({{ page.root }}/artifacts/intro/connect.png)


<br/><br/>
<a name="firslook"/>

## Your first local MySQL Database 


#### Create your first database / schema
```
CREATE SCHEMA firstdb;
```
{: .language-sql}

SQL is not case sensitive:

```
create schema FIRSTDB;
```
{: .language-sql}

For the next commands, make sure the created db is selected

```
USE firstdb;
```
{: .language-sql}

<br/><br/>
#### Deleting a database

Execute twice

```
DROP SCHEMA firstdb;
```
{: .language-sql}

`Note` second time you will get and error because the db is already deleted with the first one. 

Try this instead

```
DROP SCHEMA IF EXISTS firstdb;
```
{: .language-sql}

Let's create a db again

```
CREATE SCHEMA birdstrikes;
USE birdstrikes;
```
{: .language-sql}

<br/><br/>
#### Loading CSV into a table

**Note:** If you are not familiar with CSV file format, read the CSV section [here]({{ page.root }}/08-dsd/index.html#csv)  

Let's create a table:
```
CREATE TABLE birdstrikes 
(id INTEGER NOT NULL,
aircraft VARCHAR(32),
flight_date DATE NOT NULL,
damage VARCHAR(16) NOT NULL,
airline VARCHAR(255) NOT NULL,
state VARCHAR(255),
phase_of_flight VARCHAR(32),
reported_date DATE,
bird_size VARCHAR(16),
cost INTEGER NOT NULL,
speed INTEGER,PRIMARY KEY(id));
```
{: .language-sql}

This table is empty, we need to fill in with data.

 This time we will load a csv file into the table. For security reason, CSV loading is limited, so you need to copy the CSV file in a place indicated by this command:

```
SHOW VARIABLES LIKE "secure_file_priv";
```
{: .language-sql}

also the next command should give you "ON"

```
SHOW VARIABLES LIKE "local_infile";
```
{: .language-sql}

<br/>
#### Plan A
If "local_infile" is "ON" and "secure_file_priv" is not "NULL"


Copy [birdstrikes_small.csv]({{ page.root }}/artifacts/intro/birdstrikes_small.csv) in the folder resulted in the previous command. 

Then load CSV data into the table with this command:
```
LOAD DATA INFILE 'c:/ProgramData/MySQL/MySQL Server 8.0/Uploads/birdstrikes_small.csv' 
INTO TABLE birdstrikes 
FIELDS TERMINATED BY ';' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES 
(id, aircraft, flight_date, damage, airline, state, phase_of_flight, @v_reported_date, bird_size, cost, @v_speed)
SET
reported_date = nullif(@v_reported_date, ''),
speed = nullif(@v_speed, '');
```
{: .language-sql}

<br/>
#### Plan B

If "local_infile" is not "ON" or "secure_file_priv" is NULL, you need to change my.cnf (Mac,Linux) or my.ini (Windows). This is an advanced operation, so as plan B: download [birdstrikes.sql]({{ page.root }}/artifacts/intro/birdstrikes.sql) and Open SQL Script in MySQL Workbench, then execute. 


<br/><br/><br/>

<a name="explore"/>

## Exploring your first database


List the table(s) of your database

```
SHOW TABLES;
```
{: .language-sql}

List the structure of a table

```
DESCRIBE birdstrikes;
```
{: .language-sql}

![Database diagram]({{ page.root }}/artifacts/intro/db_model.png)


Retrieving data stored in birdstrikes

```
SELECT * FROM birdstrikes;
```
{: .language-sql}

Select certain field(s)

```
SELECT cost FROM birdstrikes;
```
{: .language-sql}

```
SELECT airline,cost FROM birdstrikes;
```
{: .language-sql}


<br/><br/><br/>
<a name="dump"/>

## Dumping a database with MySQL Workbench
[Screenshot help]({{ page.root }}/artifacts/intro/dump.png)




<br/><br/><br/>
>## Ninja challenge
>
>* Load lines starting with "Data:" from [ninja.txt]({{ page.root }}/artifacts/intro/ninja.txt) into a table.
>* Further requirements:
>	* Divide the last column with 1000 during the load
>	* " signs should be removed during the load
>	* Dump the table and send to me in mail with the sql script. 
{: .challenge} 


<br/><br/>
<a name="homework"/>

>## Homework 1
>
>* Import a relational data set of your choosing into your local instance. 
>* Requirements:
>	* find a data set worth to analyze later (prepares you for the term project)
>	* no restriction on the type of data source, can be excel, csv, another db, sql file etc
>	* pay attention on the relational nature of the set, advised to find a structure of 3+ interlinked table 
>	* do not use this: https://www.mysqltutorial.org/mysql-sample-database.aspx (because we will use it later in the course)
>	* hint: you can find various open datasets on the internet, like here: https://data.worldbank.org/
>* Create a public GitHub repo. This repo will be used for all homeworks and term project in this course. 
>* Save your artifacts (possible sources like csv, sql file ) in a folder called HW1. 
>* Submit GitHub repo link to moodle when you are ready
{: .challenge} 
