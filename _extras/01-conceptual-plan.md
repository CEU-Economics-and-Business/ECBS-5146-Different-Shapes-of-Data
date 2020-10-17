---
title: A Sample Conceptual Plan (deliverable 1)
---

# City-Level Election Database
## Goals
I want to analyze how political support for the incumbent governing party changes with economic outcomes in Hungarian cities and towns. For this, I will need a city-level database of results in general elections in 1990-2018. Since general elections only happen every four years, I may also add European Parliamentary election results.

The database should be in a format suitable for merging city-level economic outcomes from TSTAR (a standard city database published by KSH.hu) and for loading and manipulating in statistical packages as R or Stata.

## Constraints
I can only use publicliy available data and open source software tools. I will work on my laptop, so data should be stored in flat files of suitable size.

The data includes names of political candidates, together with their part affiliation. This is potentially sensitive data, but is not subject to GDPR, because (i) the data has already been made public, (ii) information about candidates running for political office should be public domain.

If I will need to scrape the election website directly, I will take care to respect its `robots.txt` and usage terms, in particular, not to overload it with many requests.

{% include mermaid.html %}



## Data sources
The main source of the data is the [set of flat files](https://www.valasztas.hu/1990-2019_eredmenyek) published by the Hungarian Election Office. These have the same content as the data published on their website. I provide a more detailed description of data about general elections. The final product and report may include additional data.

<div class="mermaid">
graph LR
    s[valasztas.hu] --election data--> d[Data product] 
    k[ksh.hu] --cities--> d
    d --analyze party support over time--> a[Analyst]
    d ---|legal constraints| l(GDPR)
    d ---|technical constraints| t(Open source)
</div>



## Conceptual model
### Entities
1. Counties. Data is reported separately for each of 19 counties and Budapest. Counties have remained stable over 1990-2018 and they provide a primary grouping for each other entity.
2. Electoral districts. Within each county, there are multiple electoral districts. The number and boundary of districts have changed over time, so they cannot be easily merged over time.
3. Polling stations. Each district is broken into many polling stations. Their number and boundary have changed over time, so they cannot be easily merged over time. 
4. Cities. For each polling stattion, we also know the municipality that encompasses its catchment area. There is only one city associated with each polling station. (Unlike with districts, where the matching is many-to-many.) City bundaries have also changed somewhat over time, but much less and it is possible to create a time-invariant aggregation of cities.
5. Candidates. We know the name and supporting organization for every candidate running for office. A candidate can run for one individual district seat, but can also be on a party list.
6. Supporting organizations. Organizations (mostly parties) have two roles in the electoral system. First, they support individual candidates running in districts. A candidate can be supported by many parties. Party names are not necessarily written consistently across districts. Second, if they have a sufficient number of individual candidates, they can also collect votes on a party ticket. 

For my analytics purpose, I need to model cities, parties and elections.

## Open questions
- How to split votes for candidates with multiple supporting parties?


The primary objective of this data product is to create a "Result" table, which lists the number of party votes each party received in each city.

<div class="mermaid">
graph LR
    City --m:1--> Result
    Party --m:1--> Result
    Election --m:1--> Result[Result: individual,list] 
</div>

### Result table

|------|-------|----------|------------|------|
| City | Party | Election | Individual | List |
|------|-------|----------|------------|------|
| M01/T001 | 001 | 2018 | 37456 | 34230 |
| M01/T001 | 002 | 2018 | 12320 | 12209 |

### City table

|------|----------|-------|
| City | KSH code | Name  | 
|------|----------|-------|
| M01/T001 | 08123 | Budapest I. ker. |

### Party table

|-------|------------|-----------|-------|
| Party | Short name | Long name | Group | 
|-------|------------|-----------|-------|
| 001 | Fidesz| Fidesz - Magyar Polgári Szövetség | right | 

### Government table

|-------|----------|
| Party | Election | 
|-------|----------|
| 001 | 2010 | 
| 001 | 2014 | 
| 001 | 2018 | 

> ## Learning outcomes demonstrated
> - Separate important from unimportant features.
> - Create diagrams with Mermaid.
> - Create concept map of data products.
{: .discussion}


{% include links.md %}
