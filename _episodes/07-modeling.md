---
title: "Data Modeling for Maintanable Data Products"
teaching: 100
exercises: 100
questions:
- What entities are represented in the data?
- How do these entites relate to one another?
- Why should I normalize my database?
objectives:
- Recognize tidy data. 
- Create logical model for simple relational data and represent it with Entity-Relation Diagrams.
- Understand and apply normal forms 1-3 to simple relational data.
- Model many-to-one relationships.
- Model many-to-many relations through a link table.
keypoints:
- Normalized data can be maintained with fewer errors.
- Denormalization helps analysis speed.
- Denormalize data the moment before analysis, not sooner.
---

{% include mermaid.html %}

## Reading
1. Broman and Woo, 2018. [Data Organization in Spreadsheets](https://www.tandfonline.com/doi/pdf/10.1080/00031305.2017.1375989).
2. Silberschatz, Kotz and Sudarshan, 2011. Database System Concepts, 6th Edition. Chapters 7.1-7.3. (optional)
3. [Entity Relationship Diagrams](https://www.youtube.com/watch?v=QpdhBUYk7Kk)

## Tidy data

<div class="mermaid">
graph LR
    raw --> tidy --> normalized --> structured
</div>

Initially data is messy not because of performance trade-offs, but because of design errors. We fix these errors to create tidy data. Then we normalize data to improve maintainablity. Finally, we can denormalize data to improve performance. Note that denormalized data is very far from messy data.

![]({{ "/fig/messy-data.png" | relative_url }})

> ## Exercise
> Look at the data displayed above. Identify six problems with this dataset.
> > ## Solution
> > 1. Columns not titled properly.
> > 2. Different types of data in a single column.
> > 3. Course title abbreviated.
> > 4. Names inconsistently recorded.
> > 5. Rows do not correspond to records.
> > 6. Information encoded in color/formatting.
> {: .solution}
{: .challenge}

![]({{ "/fig/StudentList.png" | relative_url }})

This is much better, but still does not satisfy "[tidy data](https://vita.had.co.nz/papers/tidy-data.pdf)" criteria. In fact, many web apps or online databases would dump its tables in a format like this.

We will study _how_ to create tidy data in Episode 5.

## The Entity--Relationship model
* entity
* relationship
* attribute
* table

> ## Exercise
> For the data sources listed on the course homepage, answer the following questions.
> 1. What entities are represented in the data?
> 2. What is a record in the dataset?
> 3. If multiple entities are represented, how are they related? Explain in words.
> 
> For example, for the "Government Compensation in California Data" (1) employees, employers, regions, (2) one employee at one employer in a given year. (3) Employers have many employees. Employees may have many employers but we don't know. Employers may operate across several regions.
> 
> Or for the "Street Tree Census" (1) trees, street blocks, regions. (2) Unique tree trunks observed at a point in time. (3) Each tree is at a particular point with a precise coordinate. This then belongs to a street block, which belongs to regions at various levels of the hierarchy: ZIP code, city, borough. 
> 
> Do this for the "Habitatges d'ús turístic de la ciutat de Barcelona" and the "National Bridge Inventory."
> > ## Solution
> > ### "Habitatges d'ús turístic de la ciutat de Barcelona"
> > 1. Apartments or other places of accommodation. Streets and addresses.
> > 2. An apartment with a unique ID.
> > 3. Each apartment has a unique street address. Each adress can have many apartments. Addresses belong to streets, which belong to districts, etc.
> >
> > ### "National Bridge Inventory"
> > 1. Bridges. Roads. Regions. Organization.
> > 2. A bridge in a given year.
> > 3. Each bridge may serve a road. Roads can pass through many bridges. A bridge is owned by an organization. The point of the bridge belongs to a region.
> {: .solution}
{: .challenge}

### The Entity Relation Diagram
[Mermaid Live Editor](https://mermaid-js.github.io/mermaid-live-editor/#/edit/eyJjb2RlIjoiZXJEaWFncmFtXG4gICAgICAgICAgQ1VTVE9NRVIgfXwuLnx7IERFTElWRVJZLUFERFJFU1MgOiBoYXNcbiAgICAgICAgICBDVVNUT01FUiB8fC0tb3sgT1JERVIgOiBwbGFjZXNcbiAgICAgICAgICBDVVNUT01FUiB8fC0tb3sgSU5WT0lDRSA6IFwibGlhYmxlIGZvclwiXG4gICAgICAgICAgREVMSVZFUlktQUREUkVTUyB8fC0tb3sgT1JERVIgOiByZWNlaXZlc1xuICAgICAgICAgIElOVk9JQ0UgfHwtLXx7IE9SREVSIDogY292ZXJzXG4gICAgICAgICAgT1JERVIgfHwtLXx7IE9SREVSLUlURU0gOiBpbmNsdWRlc1xuICAgICAgICAgIFBST0RVQ1QtQ0FURUdPUlkgfHwtLXx7IFBST0RVQ1QgOiBjb250YWluc1xuICAgICAgICAgIFBST0RVQ1QgfHwtLW97IE9SREVSLUlURU0gOiBcIm9yZGVyZWQgaW5cIlxuICAgICAgICAgICAgIiwibWVybWFpZCI6eyJ0aGVtZSI6ImRlZmF1bHQiLCJ0aGVtZVZhcmlhYmxlcyI6eyJiYWNrZ3JvdW5kIjoid2hpdGUiLCJwcmltYXJ5Q29sb3IiOiIjRUNFQ0ZGIiwic2Vjb25kYXJ5Q29sb3IiOiIjZmZmZmRlIiwidGVydGlhcnlDb2xvciI6ImhzbCg4MCwgMTAwJSwgOTYuMjc0NTA5ODAzOSUpIiwicHJpbWFyeUJvcmRlckNvbG9yIjoiaHNsKDI0MCwgNjAlLCA4Ni4yNzQ1MDk4MDM5JSkiLCJzZWNvbmRhcnlCb3JkZXJDb2xvciI6ImhzbCg2MCwgNjAlLCA4My41Mjk0MTE3NjQ3JSkiLCJ0ZXJ0aWFyeUJvcmRlckNvbG9yIjoiaHNsKDgwLCA2MCUsIDg2LjI3NDUwOTgwMzklKSIsInByaW1hcnlUZXh0Q29sb3IiOiIjMTMxMzAwIiwic2Vjb25kYXJ5VGV4dENvbG9yIjoiIzAwMDAyMSIsInRlcnRpYXJ5VGV4dENvbG9yIjoicmdiKDkuNTAwMDAwMDAwMSwgOS41MDAwMDAwMDAxLCA5LjUwMDAwMDAwMDEpIiwibGluZUNvbG9yIjoiIzMzMzMzMyIsInRleHRDb2xvciI6IiMzMzMiLCJtYWluQmtnIjoiI0VDRUNGRiIsInNlY29uZEJrZyI6IiNmZmZmZGUiLCJib3JkZXIxIjoiIzkzNzBEQiIsImJvcmRlcjIiOiIjYWFhYTMzIiwiYXJyb3doZWFkQ29sb3IiOiIjMzMzMzMzIiwiZm9udEZhbWlseSI6IlwidHJlYnVjaGV0IG1zXCIsIHZlcmRhbmEsIGFyaWFsIiwiZm9udFNpemUiOiIxNnB4IiwibGFiZWxCYWNrZ3JvdW5kIjoiI2U4ZThlOCIsIm5vZGVCa2ciOiIjRUNFQ0ZGIiwibm9kZUJvcmRlciI6IiM5MzcwREIiLCJjbHVzdGVyQmtnIjoiI2ZmZmZkZSIsImNsdXN0ZXJCb3JkZXIiOiIjYWFhYTMzIiwiZGVmYXVsdExpbmtDb2xvciI6IiMzMzMzMzMiLCJ0aXRsZUNvbG9yIjoiIzMzMyIsImVkZ2VMYWJlbEJhY2tncm91bmQiOiIjZThlOGU4IiwiYWN0b3JCb3JkZXIiOiJoc2woMjU5LjYyNjE2ODIyNDMsIDU5Ljc3NjUzNjMxMjglLCA4Ny45MDE5NjA3ODQzJSkiLCJhY3RvckJrZyI6IiNFQ0VDRkYiLCJhY3RvclRleHRDb2xvciI6ImJsYWNrIiwiYWN0b3JMaW5lQ29sb3IiOiJncmV5Iiwic2lnbmFsQ29sb3IiOiIjMzMzIiwic2lnbmFsVGV4dENvbG9yIjoiIzMzMyIsImxhYmVsQm94QmtnQ29sb3IiOiIjRUNFQ0ZGIiwibGFiZWxCb3hCb3JkZXJDb2xvciI6ImhzbCgyNTkuNjI2MTY4MjI0MywgNTkuNzc2NTM2MzEyOCUsIDg3LjkwMTk2MDc4NDMlKSIsImxhYmVsVGV4dENvbG9yIjoiYmxhY2siLCJsb29wVGV4dENvbG9yIjoiYmxhY2siLCJub3RlQm9yZGVyQ29sb3IiOiIjYWFhYTMzIiwibm90ZUJrZ0NvbG9yIjoiI2ZmZjVhZCIsIm5vdGVUZXh0Q29sb3IiOiJibGFjayIsImFjdGl2YXRpb25Cb3JkZXJDb2xvciI6IiM2NjYiLCJhY3RpdmF0aW9uQmtnQ29sb3IiOiIjZjRmNGY0Iiwic2VxdWVuY2VOdW1iZXJDb2xvciI6IndoaXRlIiwic2VjdGlvbkJrZ0NvbG9yIjoicmdiYSgxMDIsIDEwMiwgMjU1LCAwLjQ5KSIsImFsdFNlY3Rpb25Ca2dDb2xvciI6IndoaXRlIiwic2VjdGlvbkJrZ0NvbG9yMiI6IiNmZmY0MDAiLCJ0YXNrQm9yZGVyQ29sb3IiOiIjNTM0ZmJjIiwidGFza0JrZ0NvbG9yIjoiIzhhOTBkZCIsInRhc2tUZXh0TGlnaHRDb2xvciI6IndoaXRlIiwidGFza1RleHRDb2xvciI6IndoaXRlIiwidGFza1RleHREYXJrQ29sb3IiOiJibGFjayIsInRhc2tUZXh0T3V0c2lkZUNvbG9yIjoiYmxhY2siLCJ0YXNrVGV4dENsaWNrYWJsZUNvbG9yIjoiIzAwMzE2MyIsImFjdGl2ZVRhc2tCb3JkZXJDb2xvciI6IiM1MzRmYmMiLCJhY3RpdmVUYXNrQmtnQ29sb3IiOiIjYmZjN2ZmIiwiZ3JpZENvbG9yIjoibGlnaHRncmV5IiwiZG9uZVRhc2tCa2dDb2xvciI6ImxpZ2h0Z3JleSIsImRvbmVUYXNrQm9yZGVyQ29sb3IiOiJncmV5IiwiY3JpdEJvcmRlckNvbG9yIjoiI2ZmODg4OCIsImNyaXRCa2dDb2xvciI6InJlZCIsInRvZGF5TGluZUNvbG9yIjoicmVkIiwibGFiZWxDb2xvciI6ImJsYWNrIiwiZXJyb3JCa2dDb2xvciI6IiM1NTIyMjIiLCJlcnJvclRleHRDb2xvciI6IiM1NTIyMjIiLCJjbGFzc1RleHQiOiIjMTMxMzAwIiwiZmlsbFR5cGUwIjoiI0VDRUNGRiIsImZpbGxUeXBlMSI6IiNmZmZmZGUiLCJmaWxsVHlwZTIiOiJoc2woMzA0LCAxMDAlLCA5Ni4yNzQ1MDk4MDM5JSkiLCJmaWxsVHlwZTMiOiJoc2woMTI0LCAxMDAlLCA5My41Mjk0MTE3NjQ3JSkiLCJmaWxsVHlwZTQiOiJoc2woMTc2LCAxMDAlLCA5Ni4yNzQ1MDk4MDM5JSkiLCJmaWxsVHlwZTUiOiJoc2woLTQsIDEwMCUsIDkzLjUyOTQxMTc2NDclKSIsImZpbGxUeXBlNiI6ImhzbCg4LCAxMDAlLCA5Ni4yNzQ1MDk4MDM5JSkiLCJmaWxsVHlwZTciOiJoc2woMTg4LCAxMDAlLCA5My41Mjk0MTE3NjQ3JSkifX0sInVwZGF0ZUVkaXRvciI6dHJ1ZX0) to create Entity Relation diagrams.

### Relationship cardinality
![Copyright LucidChart](https://d2slcw3kip6qmk.cloudfront.net/marketing/pages/chart/erd-symbols/ERD-Notation.PNG)

#### Government Compensation in California
Create one box for each "entity set" (say, employers). These correspond to "tables" in a _relational database_.

<div class="mermaid">
erDiagram
          EMPLOYEE }|..|| EMPLOYER : "works for"
          EMPLOYER }|..|{ REGION : "located in"
</div>

#### Street Tree Census

<div class="mermaid">
erDiagram
          Tree }|..|| Street : "located in"
          Street }|..|{ Region : "part of"
</div>

#### Habitatges de Barcelona
<div class="mermaid">
erDiagram
          Apartment }|..|| Address : "located at"
          Address }|..|| Street : "part of"
</div>

> ## Exercise
> Draw an Entity Relation Diagram for the _National Bridge Inventory_ using an ERD in Mermaid.
{: .challenge}

## Modeling many-to-many relationships through link tables

> ## Link table
> A **link table** (aka associative table, bridge table, mapping table) converts a many-to-many relationship to two many-to-one reltionships.
{: .callout}

### A many-to-one relationsip
<div class="mermaid">
erDiagram
          Course }|..|| Department : "hosted by"
</div>

This is the easiest to represent in tables. We add a _foreign key_ column to the Course table, referencing the Department _primary key_. The course "ECBS5148" will point to Department "ECBS".

### A many-to-many relationsip
<div class="mermaid">
erDiagram
          Student }|..|{ Course : "register"
</div>

### Modeled with a link table
<div class="mermaid">
erDiagram
          Student ||..|{ register
          Course ||..|{ register
</div>

Often (but not always) there is a natural verb or noun describing the link table. We can also note additional attributes of the relationship, such as taking a course for Grade or for Audit only.

{% assign table_data = site.data.sis.roster-2NF %}
{% assign table_caption = "Which student takes which course?" %}
{% include table.html %}


> ## Naming conventions
> _Entity tables_: noun describing the entities in the table, in singular. For example, "student," "course," "tender."
>
> _Relationship tables_: verb describing the relationship, in its root form. For example, "register," "teach," "win."
> 
> In the diagrams, we use titlecase names for entity tables and lowercase names for relationship tables.
{: .callout}

|-------|--------|
| story | topics |
|-------|--------|
| 01 | brexit,johnson,uk |
| 02 | brexit,eu,tusk |
| 03 | us,trump,impeachment |
| 04 | us,uk,trade |

> ## Exercise
> Create a link table in your favorite spreadsheet editor to represent the many-to-many relationship between stories and topics.
{: .challenge}

{% assign table_data = site.data.sis.roster %}
{% assign table_caption = "Data from `roster.csv`" %}
{% include table.html %}

> ## Exercise
> Draw a block diagram representing the conceptual model of the student roster.
{: .challenge}


## Normalization

> ## Why normalize?
>
> |---------|-------|------------|--------------|
> |         | Messy | Normalized | Denormalized |
> |---------|-------|------------|--------------|
> | Explore | ok    | ok         | easy         |
> | Change  | hard  | easy       | hard         |
> | Analyze | hard  | ok         | easy         |
{: .callout}

### First normal form
> All attributes are atomic. = All cells are single valued.

"Course Title" and "Student Name" clearly violate this condition.


{% assign table_data = site.data.sis.roster-1NF %}
{% assign table_caption = "Data from `roster-1NF.csv`" %}
{% include table.html %}

Strictly speaking, `ECBS5148` is not atomic. Also, programs may be further split up into "MS in Business Analytics", "full-time".

> ## Exercise (optional)
> Look at the [2015 Street Tree Census](https://data.cityofnewyork.us/Environment/2015-Street-Tree-Census-Tree-Data/uvpi-gqnh). Which of the columns violate the first normal form?
>> ## Solution
>> `problems` is a list. We can create a separate `problem` table, with a foreign key pointing to the tree with which there are problems. This would be a many-to-one relation.
>> `address` can be broken into number and street.
> {: .solution}
{: .challenge}

{% assign table_data = site.data.modeling.problem %}
{% assign table_caption = "Data from `problem` table" %}
{% include table.html %}

### Second normal form
> None of the columns depend functionally on a proper subset of primary keys.

What are the keys in this data table? A combination of (Course Code, Student ID), or any combination of columns with the same information. 

Clearly, "Course Title" depends only on "Course Code", not on "Student ID." Similarly, "Student First Name" depends only on "Student ID."

{% assign table_data = site.data.sis.roster-1NF-error %}
{% assign table_caption = "Updating student name in a row" %}
{% include table-error.html %}


{% assign table_data = site.data.sis.roster-2NF %}
{% assign table_caption = "Data from `roster-2NF.csv`" %}
{% include table.html %}

Yeah, but where is everything else?

{% assign table_data = site.data.sis.student-2NF %}
{% assign table_caption = "Data from `student-2NF.csv`" %}
{% include table.html %}

{% assign table_data = site.data.sis.course-2NF %}
{% assign table_caption = "Data from `course-2NF.csv`" %}
{% include table.html %}

### Third normal form
> No column depends on anything but the keys.

In `student-2NF.csv`, "Department" is a function of "Program."

{% assign table_data = site.data.sis.student-2NF-error %}
{% assign table_caption = "Data from `student-2NF-error.csv`" %}
{% include table-error.html %}

{% assign table_data = site.data.sis.roster-3NF %}
{% assign table_caption = "Data from `roster-3NF.csv`" %}
{% include table.html %}

{% assign table_data = site.data.sis.student-3NF %}
{% assign table_caption = "Data from `student-3NF.csv`" %}
{% include table.html %}

{% assign table_data = site.data.sis.course-3NF %}
{% assign table_caption = "Data from `course-3NF.csv`" %}
{% include table.html %}

{% assign table_data = site.data.sis.program-3NF %}
{% assign table_caption = "Data from `program-3NF.csv`" %}
{% include table.html %}

> ## Exercise (optional)
> Look at the [2015 Street Tree Census](https://data.cityofnewyork.us/Environment/2015-Street-Tree-Census-Tree-Data/uvpi-gqnh). After creating tables that satisfy the first normal form, 
which of the columns violate the third normal form?
>> ## Solution
>> Suppose there are two tables, a `problem` table with columns `tree_id` and `problem` (see example), and a 
`tree` table listing all other columns for each tree. In the `tree` table, `address` determines a lot of columns: `postcode`, `zip_city`, `borough` etc. These could be separated out in an `address` table. 
> {: .solution}
{: .challenge}


> ## Challenge
> Draw the Entity-Relation diagram of the student database in its 3rd normnal form. 
{: .challenge}


## The Kimball framework ("star schema")

1. Select the business process.
2. Declare the grain.
3. Identify the dimensions.
4. Identify the facts.


> ## Exercise
> Take "students get grades" as the business process. What is the grain? What are the dimensions? What are the facts?
>> ## Solution
> {: .solution}
{: .challenge}
