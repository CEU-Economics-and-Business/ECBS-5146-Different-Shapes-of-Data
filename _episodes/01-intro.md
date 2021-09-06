---
title: Course intro
teaching: 70
exercises: 35
questions:
- As analyst, you are asked to perform analytics on data set, stored in a database.
- As analyst, you got data from various sources (eg. csv, access to an external db or db dump). You would like to setup your own database, loading the data from external sources, so that you can perform analytics on it.
- What do you need to know to perform these tasks?
objectives:
- Keywords - INTRO. LOCAL ENVIRONMENT. BASIC SQL. YOUR FIRST DATABASE. DUMPS.
- Setting the context - evolution of digital persistency 1950-2010
- Introducing the basic terms, in context of SQL
- Writing the first SQL
- Setting local MYSQL / Workbench (Expected to be done prior to the course)
- Understanding how to work in Workbench
- Creating and exploring the first MySQL database
- Understanding how to backup and restore a database
---

> ## Table of Content
> [Lecture PPTX](/ECBS-5146-Different-Shapes-of-Data/artifacts/intro/intro.pptx)
>
> [SQL in 5 Minutes](#sql5)
>
> [MongoDB](#mongo)
>
> [Solr](#solr)
>
> [Neo4j](#neo4j)
{: .discussion}
  


<br/><br/>
<a name="sql5"/>
## SQL in 5x3 minutes



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