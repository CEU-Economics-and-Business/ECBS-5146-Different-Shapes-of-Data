---
title: Database management. First selects. 
teaching: 70
exercises: 35
questions:
- As analyst, you are asked to perform analytics on data set, stored in a database.
- As analyst, you got data from various sources (eg. csv, access to an external db or db dump). You would like to setup your own database, loading the data from external sources, so that you can perform analytics on it.
- What do you need to know to perform these tasks?
objectives:
- Setting the context - evolution of digital persistency 1950-2010
- Introducing the basic terms, in context of SQL
- Writing the first SQL
- Setting local MYSQL / Workbench (Expected to be done prior to the course)
- Understanding how to work in Workbench
- Creating and exploring the first MySQL database
- Understanding how to backup and restore a database
---


> ## Keywords
> INTRO. LOCAL ENVIRONMENT. BASIC SQL. YOUR FIRST DATABASE. DUMPS.
{: .discussion}


> ## Table of Content
> [Lecture PPTX](/ECBS-5146-Different-Shapes-of-Data/artifacts/intro/intro.pptx)
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
  




<br/><br/>
<a name="sql5"/>
## SQL in 6 minutes



Browse to [https://www.w3schools.com/sql/trysql.asp?filename=trysql_op_in)](https://www.w3schools.com/sql/trysql.asp?filename=trysql_op_in)


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
ORDER BY o.OrderDate DESC, o.OrderID
```
{: .language-sql}




<br/><br/><br/>
<a name="firstdb"/>
## First look on MySQL and MySQL Workbench
[Screenshot help](https://github.com/salacika/DE1SQL/blob/master/SQL1/connect.png?raw=true)

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

<<<<<<< HEAD:_archive/02-selects.md
<br/><br/>
=======
>>>>>>> parent of f69b1d9 (a):_episodes/01-intro.md
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

Lets recreate the db again

```
CREATE SCHEMA firstdb;
USE firstdb;
```
{: .language-sql}

<<<<<<< HEAD:_archive/02-selects.md
<br/><br/>
=======
>>>>>>> parent of f69b1d9 (a):_episodes/01-intro.md
#### Loading CSV into a table

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

This table is empty, we need to fill in with data. This time we will load a csv file into the table. For security reason, CSV loading is limited, so you need to copy the CSV file in a place indicated by this command:
```
SHOW VARIABLES LIKE "secure_file_priv";
```
{: .language-sql}

Copy https://github.com/salacika/DE1SQL/blob/master/SQL1/birdstrikes_small.csv in the folder resulted in the previous command. 

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

![Database diagram](/SQL1/db_model.png)


Retriving data stored in birdstrikes

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
[Screenshot help](/ECBS-5146-Different-Shapes-of-Data/artifacts/intro/dumo.png)


<br/><br/><br/>
<a name="homework"/>

>## Homework 1
>* Import a relational data set of your choosing into your local instance. 
>
>* Requirements:
>	* find a data set worth to analyze later (prepares you for the term project)
>	* no restriction on the type of data source, can be excel, csv, another db, sql file etc
>	* pay attention on the relational nature of the set, advised to find a structure of 3+ interlinked table 
>	* do not use this: https://www.mysqltutorial.org/mysql-sample-database.aspx (because we will use it later in the course)
>	* hint: you can find various open datasets on the internet, like here: https://data.worldbank.org/
>
>* Create a public GitHub repo. Save your artifacts (possible sources like csv, sql file ) in a folder called HW1.
>* Submit GitHub link to moodle when you are ready
{: .challenge} 
