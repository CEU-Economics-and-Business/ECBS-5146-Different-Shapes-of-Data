---
title: DB administration. Queries. 
teaching: 70
exercises: 35
questions:
- As analyst, you would like to make sure your data stored, can be accessed only by authorized persons.
- As analyst, you would like to query your database, to obtain data required for your analytics.
objectives:
- Understanding the options of altering a db
- Introduction to database security
- Understanding datatypes
- Present examples and exercise querying databases 
---


> ## Keywords
> ALTERING DB. SECURITY. DATA TYPES. LOGICAL OPERATORS. FILTERING.
{: .discussion}


> ## Table of Content
>[Chapter's database](#db)  
>[Altering your first database](#altering)  
>[Users and privileges](#users)  
>[More advanced selects](#selects)  
>[Data types](#datatypes)  
>[Comparison Operators](#operators)  
>[Filtering with VARCHAR](#VARCHAR)  
>[Filtering with INT](#INT)  
>[Filtering with DATE](#DATE)  
>[Homework](#homework)  
{: .discussion}
  
<br/><br/><br/>
<a name="db"/>
## Chapter's database

No need to load new data, in this chapter we will use only the birdstrikes table loaded in the last chapter:


![Database diagram](/artifacts/intro/db_model.png)

<br/><br/><br/>
<a name="altering"/>
## Altering your first database

<br/><br/>
#### Copy table

```
CREATE TABLE new_birdstrikes LIKE birdstrikes;
SHOW TABLES;
DESCRIBE new_birdstrikes;
SELECT * FROM new_birdstrikes;
```
{: .language-sql}

<br/><br/>
#### Delete table

```
DROP TABLE IF EXISTS new_birdstrikes;
```
{: .language-sql}

<br/><br/>
#### Create table

```
CREATE TABLE employee (id INTEGER NOT NULL, employee_name VARCHAR(255) NOT NULL, PRIMARY KEY(id));`
DESCRIBE employee;
```
{: .language-sql}

<br/><br/>
#### Insert new rows (records)

Insert lines in employee table one by one

```
INSERT INTO employee (id,employee_name) VALUES(1,'Student1');
INSERT INTO employee (id,employee_name) VALUES(2,'Student2');
INSERT INTO employee (id,employee_name) VALUES(3,'Student3');
```
{: .language-sql}

Let's check the results

```
SELECT * FROM employee;
```
{: .language-sql}

What happens if you try this (and why)?

```
INSERT INTO employee (id,employee_name) VALUES(3,'Student4');
```
{: .language-sql}

<br/><br/>
#### Updating rows

```
UPDATE employee SET employee_name='Arnold Schwarzenegger' WHERE id = '1';
UPDATE employee SET employee_name='The Other Arnold' WHERE id = '2';
```
{: .language-sql}

Let's check the results

```
SELECT * FROM employee;
```
{: .language-sql}

<br/><br/>
#### Deleting rows

Deleting some records

```
DELETE FROM employee WHERE id = 3;
```
{: .language-sql}

Let's check the results

```
SELECT * FROM employee
```
{: .language-sql}

<br/><br/>
#### Deleting all rows

```
TRUNCATE employee;
```
{: .language-sql}

Let's check the results

```
SELECT * FROM employee;
```
{: .language-sql}




<br/><br/><br/>
<a name="users"/>
## Users and privileges

<br/><br/>
#### Creating new user

```
CREATE USER 'laszlosallo'@'%' IDENTIFIED BY 'laszlosallo1';
```
{: .language-sql}

<br/><br/>
#### Giving full rights for table employee

```
GRANT ALL ON birdstrikes.employee TO 'laszlosallo'@'%';
```
{: .language-sql}

<br/><br/>
#### Giving rights to see one column of birdstrikes

```
GRANT SELECT (state) ON birdstrikes.birdstrikes TO 'laszlosallo'@'%';
```
{: .language-sql}

<br/><br/>
#### Deleting user

```
DROP USER 'laszlosallo'@'%';
```
{: .language-sql}


<br/><br/><br/>
<a name="selects"/>
## More advanced selects

<br/><br/>
#### New column
Create a new column

```
SELECT *, speed/2 FROM birdstrikes;
```
{: .language-sql}

<br/><br/>
#### Aliasing

```
SELECT *, speed/2 AS halfspeed FROM birdstrikes;
```
{: .language-sql}

<br/><br/>
#### Using Limit

List the first 10 records

```
SELECT * FROM birdstrikes LIMIT 10;
```
{: .language-sql}

List the first 1 record, after the the first 10

```
SELECT * FROM birdstrikes LIMIT 10,1;
```
{: .language-sql}


<br/><br/>
> ## `Exercise1` 
> What state figures in the 145th line of our database?
{: .challenge} 

<br/><br/>


#### Ordering data

Order by a field

```
SELECT state, cost FROM birdstrikes ORDER BY cost;
```
{: .language-sql}


Order by a multiple fields

```
SELECT state, cost FROM birdstrikes ORDER BY state, cost ASC;
```
{: .language-sql}

Reverse ordering

```
SELECT state, cost FROM birdstrikes ORDER BY cost DESC;
```
{: .language-sql}


<br/><br/>
> ## `Exercise2` 
> What is flight_date of the latest birstrike in this database?
{: .challenge} 

<br/><br/>




#### Unique values 

Of a column

```
SELECT DISTINCT damage FROM birdstrikes;
```
{: .language-sql}

Unique pairs

```
SELECT DISTINCT airline, damage FROM birdstrikes;
```
{: .language-sql}


<br/><br/>
> ## `Exercise3` 
> What was the cost of the 50th most expensive damage?
{: .challenge} 

<br/><br/>


#### Filtering
Select the lines where states is Alabama

```
SELECT * FROM birdstrikes WHERE state = 'Alabama';
```
{: .language-sql}


<br/><br/><br/>
<a name="datatypes"/>
## Data types

![Data types](/artifacts/selects/data_types.png)


<br/><br/><br/>
<a name="operators"/>
## Comparison Operators

![Data types](/artifacts/selects/ops.png)



<br/><br/><br/>
<a name="VARCHAR"/>
## Filtering with VARCHAR

<br/><br/>
#### NOT EQUAL

Select the lines where states is not Alabama

```
SELECT * FROM birdstrikes WHERE state != 'Alabama'
```
{: .language-sql}

States starting with 'A'

<br/><br/>
#### LIKE

```
SELECT DISTINCT state FROM birdstrikes WHERE state LIKE 'A%';
```
{: .language-sql}

Note the case (in)sensitivity

```
SELECT DISTINCT state FROM birdstrikes WHERE state LIKE 'a%';
```
{: .language-sql}

States starting with 'ala'

```
SELECT DISTINCT state FROM birdstrikes WHERE state LIKE 'ala%';
```
{: .language-sql}

States starting with 'North ' followed by any character, followed by an 'a', followed by anything

```
SELECT DISTINCT state FROM birdstrikes WHERE state LIKE 'North _a%';
```
{: .language-sql}

States not starting with 'A'

```
SELECT DISTINCT state FROM birdstrikes WHERE state NOT LIKE 'a%' ORDER BY state;
```
{: .language-sql}

<br/><br/>
#### Logical operators

Filter by multiple conditions

```
SELECT * FROM birdstrikes WHERE state = 'Alabama' AND bird_size = 'Small';
SELECT * FROM birdstrikes WHERE state = 'Alabama' OR state = 'Missouri';
```
{: .language-sql}

<br/><br/>
#### IS NOT NULL

Filtering out nulls and empty strings

```
SELECT DISTINCT(state) FROM birdstrikes WHERE state IS NOT NULL AND state != '' ORDER BY state;
```
{: .language-sql}

<br/><br/>
#### IN

What if I need 'Alabama', 'Missouri','New York','Alaska'? Should we concatenate 4 AND filters?

```
SELECT * FROM birdstrikes WHERE state IN ('Alabama', 'Missouri','New York','Alaska');
```
{: .language-sql}

<br/><br/>
#### LENGTH
Listing states with 5 characters

```
SELECT DISTINCT(state) FROM birdstrikes WHERE LENGTH(state) = 5;
```
{: .language-sql}

<br/><br/><br/>
<a name="INT"/>
## Filtering with INT

Speed equals 350

```
SELECT * FROM birdstrikes WHERE speed = 350;
```
{: .language-sql}

Speed equal or more than 25000

```
SELECT * FROM birdstrikes WHERE speed >= 10000;
```
{: .language-sql}

<br/><br/>
#### ROUND, SQRT

```
SELECT ROUND(SQRT(speed/2) * 10) AS synthetic_speed FROM birdstrikes;
```
{: .language-sql}

<br/><br/>
#### BETWEEN

```
SELECT * FROM birdstrikes where cost BETWEEN 20 AND 40;
```
{: .language-sql}




<br/><br/>
> ## `Exercise4` 
> What state figures in the 2nd record, if you filter out all records which have no state and no bird_size specified?
{: .challenge} 

<br/><br/><br/>
<a name="DATE"/>
## Filtering with DATE

Date is "2000-01-02"

```
SELECT * FROM birdstrikes WHERE flight_date = "2000-01-02";
```
{: .language-sql}

All entries where flight_date is between "2000-01-01" AND "2000-01-03"

```
SELECT * FROM birdstrikes WHERE flight_date >= '2000-01-01' AND flight_date <= '2000-01-03';
```
{: .language-sql}

<br/><br/>
#### BETWEEN

```
SELECT * FROM birdstrikes where flight_date BETWEEN "2000-01-01" AND "2000-01-03";
```
{: .language-sql}


<br/><br/>
> ## `Exercise5` 
> How many days elapsed between the current date and the flights happening in week 52, for incidents from Colorado? (Hint: use NOW, DATEDIFF, WEEKOFYEAR)
{: .challenge} 


<br/><br/><br/>
<a name="homework"/>
> ## Homework 2
> * Upload the solution of exercise 1-5 to your GitHub repo in a folder called HW2
> * Submit GitHub repo link to moodle when you are ready
> * Make sure to submit both the SQL statements and answers to the questions
> * The required data format for submission is a .sql file
{: .challenge} 
