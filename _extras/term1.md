---
title: Term project 1
---

### Format
The term project will delivered individually. 

### Goal
* Linking the bit and pieces learnt during the course, so that students can see how all these fits together
* Exercise once more the SQL statements covered in the course
* Go beyond what we learn. Depending on the scope, student choose to submit, one might need to expand the knowledge acquired during the course
* Learning the format of delivering such a project (naming, packaging, versioning, documenting, testing etc.)

### High level requirements
**OPERATIONAL LAYER:** Create an operational data layer in MySQL. Import a relational data set of your choosing into your local instance. Find a data which makes sense to be transformed in analytical data layer for further analytics. In ideal case, you can use the outcome of HW1.

**ANALYTICS:** Create a short plan of what kind of analytics can be potentially executed on this data set.  Plan how the analytical data layer, ETL, Data Mart would look like to support these analytics. (Remember ProductSales example during the class). 

**ANALYTICAL LAYER:** Design a denormalized data structure using the operational layer. Create table in MySQL for this structure. 

**ETL PIPLINE:** Create an ETL pipeline using Triggers, Stored procedures. Make sure to demonstrate every element of ETL (Extract, Transform, Load)

**DATA MART:** Create Views as data marts. 

*Optional: create Materialized Views with Events for some of the data marts. 


### Delivery
The project artifacts should be stored and handed over in a folder "Term1" on your GitHub repo.

I will give you the freedom of choosing naming conventions and structure, since this was not covered implicitly in the course. Yet, I would encourage you, to find some reading over the internet and whatever you choose, be consistent. 

Testing is optional, for the same reason, we have not covered during the course. Yet, be aware that this is important part of a project delivery. 
Documentation: use the possibilities offered by GIT markdown and comments in the sql files. 

Reproducibility: the project should be reproducible in a straightforward manner. In other words, I should be able to run your code and obtain the same outcome as you. 

### Grading criteria

-	Fitness of the input dataset to the purpose **5 points**
-	Complexity of the input data set **5 points**
-	Execution of the operational data layer **10 points**
-	Analytics plan **10 points**
-	Execution of the analytical data layer **10 points**
-	ETL **15 points**
-	Data Marts **10 points**
-	Delivery: Naming, structure **10 points**
-	Delivery: Documentation **10 points**
-	Reproducibility **15 points**

Extra points:
- Triggers
- Testing
- Materialized Views 
- Anything special not covered during the course but makes sense in the project context

### Submission 
Before you really start working on the project, submit your planned data set [here](https://docs.google.com/spreadsheets/d/1wU-aBzTvght0PcEXVVetB2hRi0ujVJjLzXaiuCcprF0/edit?usp=sharing). You can start working on it when the Instructure gives you ok in the right column. 

<br/>

Submit the GitHub link to Moodle when you are ready (don't forget to set the repository to public or give us access!) The deadline for the term project is 04th of November, EOD. 
