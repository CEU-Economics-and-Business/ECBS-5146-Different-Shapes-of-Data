---
title: Data Architecture Tradeoffs.
teaching: 90
questions:
- Why 80% of classical Data Warehouse projects fails?
- Why RDBMS is less trendy these days?
- What are the expected characteristics of a data store these days?
- What are the limitation of a classical RDBMS and how the "New tools" are solving these limitations?
objectives:
- Understand the issues around the classical Data Warehouse architecture
- Understand the limitation of RDBMDs
- Understand the social, economical and technological changes after 2010 and the radical changes induced in the data world
- Understand the role of opens source in data world
- Understand distributed systems
- Understand cloud-based systems
- Practice creation of a RDBMS in AWS
keypoints:
- \#SERVER ARCHITECTURES 
- \#CLOUD
- \#SQL SWISSKNIFE
- \#NOSQL
- \#SCHEMALESS
- \#BEYOND TABULAR
---




> ## Table of Content
> [Lecture PPTX]({{ page.root }}/artifacts/tradeoffs/tradeoffs.pptx)
>
> [Installing MySQL in AWS Cloud](#aws)
>
> [Homework](#homework)  
{: .discussion}



<br/><br/>
<a name="aws"/>

## Installing MySQL in AWS Cloud

Getting insights in AWS cloud, has to major goals:
* A data system in cloud enables collaboration during the execution of your term project
* Introducing cloud in practice, helps students to understand the next lecture

As practice we will install a MySQL in AWS using Amazon RDS and then we will access it through MySQL Workbench and then Python. 

## Access MYSQL from Python

#### Select a database
```
from mysql.connector import (connection)

connection = connection.MySQLConnection(
    user='xxx', 
    password='xxx',
    host='localhost',
    database='birdstrikes', 
    auth_plugin = 'mysql_native_password')

db = connection.cursor()
```
{: .language-python}

#### Run a SQL query and display resultset
```
db.execute("SELECT * FROM birdstrikes LIMIT 5;")

result = db.fetchall()

for x in result:
  print(x)
```
{: .language-python}


#### Close connection
```
connection.close()
```
{: .language-python}


<br/><br/>
<a name="homework"/>

<br><br>

> ## Homework (Optional, no need to submit)
> 
> * Replicate the "classicmodels" schema into your cloud instance using MySQL Workbench's migration wizard.
{: .challenge}




