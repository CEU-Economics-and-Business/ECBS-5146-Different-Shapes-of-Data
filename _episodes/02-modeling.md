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
- Create and query a simple database in SQLite.
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
4. [Cost of a join](https://www.brianlikespostgres.com/cost-of-a-join.html)

## Setup
- [Download](https://sqlite.org/download.html) and install SQLite.

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
[Mermaid Live Editor](https://mermaidjs.github.io/mermaid-live-editor/) to create block diagrams ("lines and boxes").

#### Government Compensation in California
<div class="mermaid">
graph TD
    employee1 --> employer1 --> region1
    employee2 --> employer1
    employer1 --> region2
    employee3 --> employer2 --> region2
</div>

Create one box for each "entity set" (say, employers). These correspond to "tables" in a _relational database_.

<div class="mermaid">
graph LR
    Employee --n:1--> Employer
    Employer ---|n:n| Region
</div>

#### Street Tree Census

<div class="mermaid">
graph LR
    Tree --n:1--> Street
    Street --n:1--> Region
</div>

#### Habitatges de Barcelona
<div class="mermaid">
graph LR
   Apartment --n:1--> Address --n:1--> Street
</div>
We can also use a [Class Diagram](https://mermaidjs.github.io/#/classDiagram) to represent more detail. (Note that this is still experimental in Mermaid JS.) 

```
classDiagram
    Apartment "many" ..> "1" Address : located at
    Address "many" ..> "1" Street : part of
```
{: .source}

<div class="mermaid">
classDiagram
    Apartment "many" ..> "1" Address : located at
    Address "many" ..> "1" Street : part of
</div>

> ## Exercise
> Draw an Entity Relation Diagram for the _National Bridge Inventory_ using a Class Diagram in Mermaid.
{: .challenge}

## Modeling many-to-many relationships through link tables

> ## Link table
> A **link table** (aka associative table, bridge table, mapping table) converts a many-to-many relationship to two many-to-one reltionships.
{: .callout}

### A many-to-one relationsip
<div class="mermaid">
graph LR
    Course --> Department
</div>

This is the easiest to represent in tables. We add a _foreign key_ column to the Course table, referencing the Department _primary key_. The course "ECBS5148" will point to Department "ECBS".

### A many-to-many relationsip
<div class="mermaid">
graph LR
    Student ---|register| Course
</div>

### Modeled with a link table
<div class="mermaid">
graph LR
    register --> Student
    register --> Course
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

> ## Exercise
> In Tenders Electronic Daily, each "Contract Award Notice" represents a tender started by an organization as a "Contracting Authority." Winning organizations ("Contractors") are typically firms. There may be multiple winners for a tender. Draw an Entity Relation Diagram for TED.
{: .challenge}

#### Tenders Electronic Daily - first version
<div class="mermaid">
graph LR
   Organization ---|n:n| Tender
</div>

<div class="mermaid">
graph LR
    role --n:1--> Organization
    role --n:1--> Tender
</div>

<div class="mermaid">
classDiagram
    Role "many" ..> "1" Tender
    Role "many" ..> "1" Organization

    class Organization
    class Tender
    class Role

    Role : organization_id
    Role : tender_id
    Role : role in (buyer, seller)

    Organization : organization_id
    Organization : name

    Tender : tender_id
    Tender : title
    Tender : value
</div>

> ## Exercise
> Looking more closely, we find that there may be multiple "lots" within each tender. Decisions may be different by lot, with different amounts and different winners. We also notice that multiple CPV codes may be listed as products or services procured. With this new information, redesign your Entity Relation Diagram.
{: .challenge}

#### Tenders Electronic Daily - full version

<div class="mermaid">
classDiagram
    Seller "many" .. "many" Lot
    Lot "many" ..> "1" Tender
    Product "many" .. "many" Lot
    Buyer "1" <.. "many" Tender
</div>

Or,
<a href="https://mermaidjs.github.io/mermaid-live-editor/#/edit/eyJjb2RlIjoiY2xhc3NEaWFncmFtXG4gICAgTG90IFwibWFueVwiIC4uPiBcIjFcIiBUZW5kZXJcbiAgICBQcm9kdWN0IFwibWFueVwiIC4uIFwibWFueVwiIExvdFxuICAgIE9yZ2FuaXphdGlvbiBcIjFcIiA8Li4gXCJtYW55XCIgVGVuZGVyIDogYnV5ZXJcbiAgICBCaWQgXCJtYW55XCIgLi4-IFwiMVwiIE9yZ2FuaXphdGlvbiA6IHNlbGxlclxuICAgIEJpZCBcIm1hbnlcIiAuLj4gXCIxXCIgTG90IiwibWVybWFpZCI6eyJ0aGVtZSI6ImRlZmF1bHQifX0">with a link table for the lot-winner relationship</a>,
<div class="mermaid">
classDiagram
    Lot "many" ..> "1" Tender
    Product "many" .. "many" Lot
    Organization "1" <.. "many" Tender : buyer
    Bid "many" ..> "1" Organization : seller
    Bid "many" ..> "1" Lot
</div>

{% assign table_data = site.data.sis.roster %}
{% assign table_caption = "Data from `roster.csv`" %}
{% include table.html %}

> ## Exercise
> Draw a block diagram representing the conceptual model of the student roster.
{: .challenge}

### Physical modeling (optional)
The following is a document from the _Offene Register_ data about German corporations in [YAML format](https://en.wikipedia.org/wiki/YAML). Don't worry about the specific format now, try to understand what the document says.
```
all_attributes: 
    _registerArt: HRB
    _registerNummer: 150148
    additional_data: 
        AD: true
        CD: true
        DK: true
        HD: false
        SI: true
        UT: true
        "VÖ": false
    federal_state: Hamburg
    native_company_number: "Hamburg HRB 150148"
    registered_office: Hamburg
    registrar: Hamburg
company_number: K1101R_HRB150148
current_status: "currently registered"
jurisdiction_code: de
name: "olly UG (haftungsbeschränkt)"
officers: 
 -  name: "Oliver Keunecke"
    other_attributes: 
        city: Hamburg
        firstname: Oliver
        flag: "vertretungsberechtigt gemäß allgemeiner Vertretungsregelung"
        lastname: Keunecke
    position: "Geschäftsführer"
    start_date: "2018-02-06"
    type: person
registered_address: "Waidmannstraße 1, 22769 Hamburg."
retrieved_at: "2018-11-09T18:03:03Z"
```
{: .source}

You can also [explore the database](https://db.offeneregister.de/openregister-ef9e802).

> ## Challenge
> Create an SQL schema for the Offene Register data. It should be able to store all the information in the dataset. Write the `CREATE TABLE` statements.
>> ## Solution
>> ```
>> CREATE TABLE company (
>>     registrar: TEXT NOT NULL,
>>     company_number: TEXT NOT NULL PRIMARY KEY,
>>     current_status: TEXT,
>>     name: TEXT,
>>     registered_address: TEXT,
>>     retrieved_at: FLOAT
>> );
>> CREATE TABLE registrar (
>>     registrar_id: TEXT NOT NULL PRIMARY KEY,
>>     federal_state: TEXT,
>>     jurisdiction_code: TEXT,
>> );
>> CREATE TABLE person (
>>     person_id: INTEGER NOT NULL PRIMARY KEY,
>>     name: TEXT,
>>     city: TEXT,
>>     firstname: TEXT,
>>     flag: TEXT,
>>     lastname: TEXT,
>>     type: TEXT
>> );
>> CREATE TABLE officer (
>>     company_number: TEXT NOT NULL,
>>     person_id: INTEGER NOT NULL,
>>     position: TEXT,
>>     start_date: INTEGER,
>>     end_date: INTEGER,
>> );
>> ```
>> {: .source}
> {: .solution} 
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

> ## Exercise
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

> ## Exercise
> Look at the [2015 Street Tree Census](https://data.cityofnewyork.us/Environment/2015-Street-Tree-Census-Tree-Data/uvpi-gqnh). After creating tables that satisfy the first normal form, 
which of the columns violate the third normal form?
>> ## Solution
>> Suppose there are two tables, a `problem` table with columns `tree_id` and `problem` (see example), and a 
`tree` table listing all other columns for each tree. In the `tree` table, `address` determines a lot of columns: `postcode`, `zip_city`, `borough` etc. These could be separated out in an `address` table. 
> {: .solution}
{: .challenge}


> ## Challenge
> Draw the Entity-Relation diagram of the student database in its 3rd normnal form. Include column names, too.
{: .challenge}

## Working with a normalized database

> ## Exercise
> Load `DE.sqlite` in SQLiteBrowser. This is a subset of 2018 Contract Award Notices from Tenders Electronic Daily, where one of the winner is from Germany. Explore `CAE_NAME`, `WIN_NAME`, `ISO_COUNTRY_CODE` and `WIN_COUNTRY_CODE` from the table `messy`. Find tenders won by "Siemens."
>
> Now explore buyers and sellers directly in their respective tables and in the `buyer_seller` view.
{: .challenge}

> ## Exercise
> Load `DE.sqlite` in SQLiteBrowser. This is a subset of 2018 Contract Award Notices from Tenders Electronic Daily, where one of the winner is from Germany. Explore `CAE_NAME`, `WIN_NAME`, `ISO_COUNTRY_CODE` and `WIN_COUNTRY_CODE` from the table `messy`. Find tenders won by "Siemens."
>
> Now explore buyers and sellers directly in their respective tables and in the `buyer_seller` view.
{: .challenge}

> ## Exercise
> Load `DE.sqlite` in sqlite. Write an SQL query that shows the countries from where sellers named "Siemens*" are from. Use the `LIKE 'Siemens%'` function.
>> ## Solution
>> ```
>> select WIN_COUNTRY_CODE, count(*) as N  
>>    from seller where WIN_NAME like 'Siemens%' 
>>    group by WIN_COUNTRY_CODE 
>>    order by N desc;
>> ```
>> {: .source}
> {: .solution}
{: .challenge}

> ## Exercise
> Load `DE.sqlite` in sqlite. Replace `WIN_COUNTRY_CODE` with DE for all sellers named "Siemens*". Check you results in the `buyer_seller` view.
{: .challenge}

> ## Challenge
> Count the number of tenders (lots) for which the buyer and the seller are from the same country. Also count the lots when they are from different countries. Which version of the data do you want to use?
>> ## Solution
>> We can use the `buyer_seller` view directly. This is a denormalized view of buyers and sellers.
>> ```
>> select count(*) from buyer_seller where ISO_COUNTRY_CODE = WIN_COUNTRY_CODE;
>> ```
>> {: .source}
> {: .solution}
{: .challenge}

## Denormalization
[Joins ar very fast](https://www.brianlikespostgres.com/cost-of-a-join.html), so it is sufficient to denormalize late.

We can denormalize our database like
```
SELECT * FROM roster 
    LEFT JOIN course ON roster.course_code = course.course_code 
    LEFT JOIN student ON student.student_id = roster.student_id;
```
{: .source}

> ## Challenge
> The primary keys of a lot are `ID_AWARD` and `ID_LOT_AWARDED`. Denormalize the buyer and seller tables to show them together.
>> ## Solution
>> ```
>> SELECT L.ID_AWARD, L.ID_LOT_AWARDED, CAE_NAME, ISO_COUNTRY_CODE, WIN_NAME, WIN_COUNTRY_CODE FROM buyer as L 
>>     LEFT JOIN seller as R
>>     ON L.ID_AWARD = R.ID_AWARD AND
>>     L.ID_LOT_AWARDED = R.ID_LOT_AWARDED;
>> ```
>> {: .source}
> {: .solution}
{: .challenge}



> ## Challenge
> Write the `SQL` statement that denormalizes the Offene Register data.
>> ## Solution
>> ```
>> SELECT * FROM officer 
>>     JOIN company ON officer.company_number = company.company_number
>>     JOIN person ON person.person_id = officer.person_id
>>     JOIN registrar ON registrar.registrar = company.registrar;
>> ```
>> {: .language-sql}
> {: .solution}
{: .challenge}
