---
title: Term project 1
---

### Format
The term project will be completed individually. 

### What to use as template / guiding material
Typically, the course material and exercises provided here suffice, particularly the chapters on Data warehouse architectures. 

### Goal
* Synthesize the various concepts learned throughout the course to illustrate how they integrate
* Revisit SQL statements discussed in the course
* Extend beyond the course material. Depending on the scope chosen by the student, additional knowledge may be aquired
* Experiment with the process of delivering such a project (naming, packaging, versioning, documenting, testing, etc.)

### High level requirements

**OPERATIONAL LAYER:** Develop an operational data layer in MySQL. Import a relational dataset of your choice into your local instance. Choose data that is suitable for transformation into an analytical layer for further analysis. Ideally, you can utilize the results from HW1.

**ANALYTICS:** Draft a concise plan detailing potential analytics that can be performed with this dataset. Outline how the analytical data layer, ETL, and Data Mart would support these analytics (refer to the ProductSales example from class).

**ANALYTICAL LAYER:** Design a denormalized data structure based on your operational layer. Create the corresponding tables in MySQL.

**ETL PIPLINE:** Construct an ETL pipeline using Triggers and Stored procedures. Ensure each element of ETL (Extract, Transform, Load) is demonstrated.

**DATA MART:** Establish Views as data marts. 

*Optional: create Materialized Views with Events for some of the data marts. 


### Delivery
Store and submit project artifacts in a folder named **"Term1"** in your dedicated DE1 **GitHub** repo. (You can store here your HW results and other artifacts as well.)
<br/><br/>
For **naming conventions** and structure, you have the freedom to make your own choices unless it was implicitly covered in the course (Database modeling and documenting with Enhanced Entity-Relationship (EER) diagrams or Analytical layer modeling and documentation using Star Schema). I encourage you to research online and maintain consistency and coding conventions.  
<br/>
**Testing** is optional, as it was not covered in the course. However, be aware that testing might be crucial part of real world enterprise project delivery. 
<br/><br/>
**For documentation** utilize GIT markdown and comments in SQL files or other coding artifactifacts
<br/><br/>
The project should be **reproducible** in a straightforward manner. In other words, any reviewer with github link should be able to run your code and achieve the same results as you. 

### Grading criteria

-	Fitness of the input dataset to the purpose **5 pts max**
-	Complexity of the input data set **5 pts max**
-	Execution of the operational data layer **10 pts max**
-	Analytics plan **10 pts max**
-	Execution of the analytical data layer **10 pts max**
-	ETL **10 pts max**
-	Data Marts **10 pts max**
-	Delivery: Naming, structure **10 pts max**
-	Delivery: Documentation **10 pts max**
-	Reproducibility **10 pts max**

Extra points **10 pts max** [Please explicitly highlight in your documentation and code comments, if you introduced something extra into your project]
- Triggers
- Testing
- Materialized Views 
- Anything special not covered during the course and makes sense in the project context

### Submission 
Before you begin the project, submit your planned dataset [here](https://docs.google.com/spreadsheets/d/1wU-aBzTvght0PcEXVVetB2hRi0ujVJjLzXaiuCcprF0/edit?usp=sharing). You may start once the Instructor approves it in the right column. 
<br/>
Submit your GitHub link (and nothing else) to Moodle when you are finished (ensure the repository is public!) The deadline for the term project is November 6th, EOD. 
<br/>
