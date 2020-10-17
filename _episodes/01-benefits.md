---
title: "Data Architecture for Reprodicuble Analysis"
teaching: 70
exercises: 55
questions:
- Who needs the data and why? What legal and technological constraints do we face?
- What is the best shape of the data for answering the analysis questions?
- How do we model how different parts of the data hang together?
- In what format do we store and ship the data? What are the requirements on physical infrastructure?
objectives:
- Reason about things that do not exist (yet).
- Separate important from unimportant features.
- Represent a mental model visually.
- Create diagrams with Mermaid.
- Create concept map of data products.
- Identify key trade-offs in data architecture.
keypoints:
- Architecture spans the gap between "data as it is" and "data most suitable for analysis questions."
- Make plans that are fit for purpose and execute them.
- Architecture for analysis differs from architecture in production.
- Optimize for human rather than machine performance.
- As analysts you care about real-world entities, not records in your data.
---

{% include mermaid.html %}

> ## Reading
> 1. Chapter 1 of Brown (2018), [Software Architecture for Developers, Volume 1](https://leanpub.com/?software-architecture-for-developers/).
> 2. Chapter 1 of Kleppmann (2016), [Designing Data-Intensive Applications](https://dataintensive.net/buy.html).
> 3. [Concept maps](http://rodallrich.com/advphysiology/ausubel.pdf)
> 4. [Data lakes](https://martinfowler.com/bliki/DataLake.html)
{: .discussion}

## Concept maps

A lot of information can be communicated effectively with "lines and boxes." Boxes typically correspond to concepts or things ("nouns"), lines represent the relation between these concepts or actions between them ("verbs").

### Visualizing frontal instruction
<div class="mermaid">
graph TD
    t(Teacher) --> m(Material)
    m --> s1(Student)
    m --> s2(Student)
    m --> s3(Student)
</div>

### Visualizing live coding
<div class="mermaid">
graph TD
    subgraph S
        s1(Student) --> m1(Code)
        s2(Student) --> m2(Code)
        s3(Student) --> m3(Code)
    end
    subgraph T
        t(Teacher) --> m(Code)
    end
    m -.- m1 -.- m2 -.- m3
</div>

> ## Exercise
> Label each line with a verb.
>> ## Solution
>> For frontal instruction: Teacher "prepares," "presents" material. Student "reads," "downloads," "absorbs," "learns" material.
>>
>> For live coding: Teacher "writes" code. Student "writes" code, "compares to," "reviews" Teacher's code.
> {: .solution}
{: .challenge}

> ## Challenge
> Take a one-paragraph description of a Grimm story. Working in groups, represent the players and events on a concept map. 
>> ## Solution
>> [One example](https://mermaidjs.github.io/mermaid-live-editor/#/edit/eyJjb2RlIjoiZ3JhcGggVERcblN0ZXBtb3RoZXItLUFkdmljZS0tPlNpc3RlcnNcblN0ZXBtb3RoZXItLU5vIHBhcnR5LS0-Q2luZGFyZWxsYVxuU2lzdGVycy0tTW9jay0tPkNpbmRhcmVsbGFcblByaW5jZS0tUG90ZW50aWFsIHJlbGF0aW9uc2hpcC0tPkNpbmRhcmVsbGFcbkNpbmRhcmVsbGEtLURhbmNlIGFsbCBuaWdodC0tPlByaW5jZVxuQVtXaGl0ZSBiaXJkXS0tRHJvcCBzaG9lLS0-Q2luZGFyZWxsYVxuUHJpbmNlLS1Ucnkgb24gc2hvZXMgcGxzLS0-Q2luZGFyZWxsYVxuUHJpbmNlLS1Ucnkgb24gc2hvZXMgcGxzLS0-U2lzdGVyc1xuS2luZy0tSW52aXRlLS0-U2lzdGVyc1xuS2luZy0tT3JkYWluIGZlc3RpdmFsLS0-UHJpbmNlIiwibWVybWFpZCI6eyJ0aGVtZSI6ImRlZmF1bHQifX0). We also realized [Sequence Diagrams](https://mermaidjs.github.io/#/sequenceDiagram) may be more suited to telling a story. 
{: .challenge}

> ## Challenge (optional)
> You are the chief engineer of SpaceX, responsible for creating the first human base on Mars. You are putting in a budget request to Elon Musk. Create a one-page conceptual diagram explaining what you will need and why.
{: .challenge}

### Using a diagram editor

There are many simple and powerful tools to create and edit diagrams. These note use [Mermaid JS](https://mermaidjs.github.io/#/), which has a natural "plain text" syntax.

```
graph TD
    subgraph S
        s1(Student) --> m1(Code)
        s2(Student) --> m2(Code)
        s3(Student) --> m3(Code)
    end
    subgraph T
        t(Teacher) --> m(Code)
    end
    m -.- m1 -.- m2 -.- m3
```
{: .source}

> ## Exercise
> Using the [Mermaid Live Editor](https://mermaidjs.github.io/mermaid-live-editor/), create a diagram of your Grimm story. Save the diagram as a text file on your computer.
>> ## Solution
>> See above
> {: .solution}
{: .challenge} 

## The life cycle of data
We will be thinking about how data moves through our organization.

> ## Data Architecture
> Data architecture spans the gap between “data as it is” and “data most suitable for analysis.”
{: .callout}

<div class="mermaid">
graph LR
    a(As it is) --> b(Suitable for analysis)
</div>

As _data analysts_, we are often tempted to focus on what we need and force data to match our needs. 

For example, we might have a dataset capturing job spells,

| Firm | Worker | Start | End |
|------|--------|-------|-----|
| Apple | Jobs | 1976-01-01 | 1985-09-17 |
| Apple | Jobs | 1997-09-17 | 2011-08-24 |
| Apple | Cook | 2011-08-24 | |

but we want to merge this data to annual financial information on firms. To faciliate this merge, we might create annual snapshots of the data

| Firm | Worker | Year |
|------|--------|------|
| Apple | Jobs | 1976 |
| Apple | Jobs | ... |
| Apple | Jobs | 1985 |
| Apple | Jobs | 1997 |
| Apple | Jobs | ...  |
| Apple | Jobs | 2010 |
| Apple | Cook | 2011 |

This duplicates a lot of information (we create a record every year even if things have not changed), but also loses a substantial amount. What if we want to do new analysis on daily stock returns? We would need daily information of who runs Apple, but we have destroyed that information.

As _data architects_, we respect our raw data and use "data as it is" our starting point. But we also keep in mind where we are going, what we want to achieve with our data product.

> ## Exercise
> Review the [example datasets]({{ "setup.html" | relative_url }}). Select two datasets and before looking at them in more detail, pose a question about their structure and content. Then go on the website, explore the data and documentation, and try to answer your question.
>> ## Solution
>> This is a sample of possible questions and answers.
>> 
>> * Does "Habitatges d'ús turístic de la ciutat de Barcelona" contain information on whether an apartment is listed through AirBnB? No.
>> * Is "Government Compensation in California" really at the employee level? Yes, it is reported for each job in each year. But names are not included.
>> * How many trees are there in NYC? The survey identified 666,134 unique trees.  
> {: .solution}
{: .challenge}

In a typical data analysis workflow, we will

1. Collect and discover
2. Profile and clean
3. Normalize and integrate
4. Share and reuse
5. Explore and visualize
6. Structure and analyze
7. Deploy and scale

> ## Hadley Wickham's version
> Hadley Wickham splits data analysis into the following stages. This is helpful, but we want to dig deeper in steps 1-3.
> 1. Import
> 2. Tidy
> 3. Transform
> 4. Visualize
> 5. Model
> 6. Communicate
> 
> (source: [R for Data Science](https://r4ds.had.co.nz/introduction.html))
{: .callout}

<div class="mermaid">
graph LR
	Raw --> Tidy
    subgraph Architecture
        Tidy --> Normalized
        Normalized --> Structured
    end
	Structured --> Analysis
</div>

In fact, we'd like our data product to be reusable for multiple analysis projects. 

Raw data can come in any format. We discuss different formats of [data serialization]({{ "04-serialization/index.html" | relative_url }}). 
Data tidying should not depend on which analytics project we are conducting. Common data quality issues can be checked and fixed via [data profiling]({{ "06-profiling/index.html" | relative_url }}).
We can create a normalized view of the relevant data through [data integration]({{ "05-integration/index.html" | relative_url }}).
What specifically we need will be decided through [data modeling]({{ "02-modeling/index.html" | relative_url }}). And our normalized data can be reshape in the [structure]({{ "03-structures/index.html" | relative_url }}) most suitable for its end use.

<div class="mermaid">
graph LR
	r1[Raw] --> t1[Tidy]
	r2[Raw] --> t2[Tidy]
    subgraph Architecture
        t1 --> Normalized
        t2 --> Normalized
        Normalized --> s1[Structured]
        Normalized --> s2[Structured]
    end
	s1 --> a1[Analysis]
	s2 --> a2[Analysis]
</div>

### Not covered
- Data security
- Analysis
- Production
- Visualization

### Two views of the data life cycle

![Fowler (2015)](https://martinfowler.com/bliki/images/dataLake/contrast.png)

> ## Lake vs warehouse
> Who wouldn't want a "lake" instead of a "warehouse"? But this is, for our purposes, an irrelevant debate. In an overly structured organization with huge IT department and tons of internally generated data, moving towards a "data lake" might be productive. For small analytics teams, gathering data from wherever they can find them, moving towards a "data warehouse" might be more productive. 
> 
> In this course, we strive for a middle ground ("data reservoirs", huh). Learning to plan and structure (like in a DW), and to use tools to work directly on raw data (like in a DL).
{: .discussion}

## Visualizing data architecture

### Stages of planning
1. **Context**: Who needs the data and why? What legal and technological constraints do we face?
2. **Conceptual**: What is the best shape of the data for answering the analysis questions?
3. **Logical**: How do we model how different parts of the data hang together?
4. **Physical**: In what format do we store and ship the data? What are the requirements on physical infrastructure?

### Levels of detail
1. **Context**: Who needs the data and why? What legal and technological constraints do we face?
2. **Data Product**: A usable collection of data and software fit for the analysis question.
3. **Data Set**: A reusable set of data covering one topic (typically) from one source. 
4. **Data Object**: A flat file, database, API storing or giving access to the data.


<div class="mermaid">
graph TD
	Context --> c2["Data Product"]

	subgraph "Data Product"
        c2 --> c3a["Data Set"]
        c2 --> c3b["Data Set"]
        c2 --> c3c["Data Set"]
	end

	subgraph "Data Set"
        c3b --> c4a["Data Object"]
        c3b --> c4b["Data Object"]
        c3b --> c4c["Data Object"]
	end
</div>

> ## Example: Analyze German procurement tenders
> 1. **Context**: As a small business owner, I want to identify firms similar to mine that are winning procurement contracts in Germany so that I can better compete with them. I need to find similar and high-performing firms and don't have a lot of money for proprietary tools and products. My data handling should be GDPR-compliant.
> 2. **Data Product** ("system"): A searchable and queriable database to identify best-performing bidding firms and display their key information. Consists of data collected from Tenders Electronic Daily and OpenCorporates. Includes a standard, open-source search tool.
> 3. **Data Set** ("component"): 
>    * _Contract Award Notices_ from Tenders Electronic Daily. Gather from EU website in CSV format and tidy up so that firms can be matched to OpenCorporates. Key variables to pay attention to: buying agency, selling firm, amount of contract award, data awarded, product (CPV) codes. Can be limited to German buying agencies to save space and effort. Open data with a CC license.
>    * _Offene Register_. A dataset derived from OpenCorporates data, listing German firms with their names, addresses, their officers. Key variables: company name, address, unique identifier. Firms moving across German states change their identifiers so these records should be linked. Open data with a CC license.
>   * _Search tool_. A software tool (Elastic Search? Lucene?) to faciliate searching among firm names and headquarter cities.
> 4. **Data Object** ("code"):
>   * _Contract Award Notices_ in CSV format, one per year. About 500MB per year. Cells contain multivalued fields (multiple winners in one cell, for example) that have to be cleaned up. Firms are not identified with numerical identifier.
>   * _OffeneRegister_ dump in JSON-lines format. Several GB in size.
{: .callout}

> ## Exercise
> What would change if our analysis goal was to estimate the home bias in procurement? We want to study whether German agencies favor German firms and if so, by how much.
>> ## Solution
>> This is statistical analysis of aggregates, not a search of particularly successful firms. We do not need a search component, but we will need more data from other countries on procurement (say, France). We also need to identify different cities in the procurement data and measure the distance between them. There may be more procurement between Stuttgart and Strasbourg because they are close by. 
> {: .solution}
{: .challenge}

> ## Exercise
> Draw a concept map at the context level (enumerating users, constraints and data products) for our analysis of home bias in German procurement.
{: .challenge}

## Key tradeoffs in data architecture
A "data-intensive application" (Kleppmann, 2016) should be
1. Reliable: "continuing to work correctly, even when things go wrong."
2. Scalable: "ability to cope with increased volume of data."
3. Maintainable: "minimize pain during maintenance" via (i) operability, (ii) simplicity, and (iii) evolvability.

An autopilot system of aircrafts should prioritize reliability over anything else. A web app like Twitter should prioritize scalability over anything else.

> As analysts, we value reliability and scabality, but we prioritize **maintainability** over anything else.
> Thus, architecture for analytics is very different from architecture for production. 

The three components of maintainability (Kleppmann, 2016):
1. Operability. Most analytics teams are small with low budget with limited dedicated IT support.
2. Simplicity. A lot of analytics is done by fast-changing teams and it is important for newcomers to understand our data products quickly.
3. Evolvability. Analysis is an iterative process with frequent changes (think R&D, not production). It should be easy to make changes to our data product. 

> ## Exercise
> You have a data processing script written in Python that can process 1 million recods in one hour. Rewriting it in C++ would make it 30 times faster, but would take 100 hours of developer time. If you minimize the sum of developer plus machine time, when would you choose to rewrite the code in C++?
>> ## Solution
>> The Python script processes 1 million records per hour, or 1 hour per million records. The C++ code would process 30 million records per hour, or 2 minutes per million records. The time gain is 58 minutes per million records. The loss in developer time if switch to C++ is 100 hours, or 6,000 minutes. To have the same gain in processing time, we need to process 6000/58 = 103.4 million records. So if our dataset is more than 103.4 million records, it is worth rewriting it in C++. (Note that we have ingored other maintainability aspects. Will our developers be able to make changes to the Python/C++ code?)
> {: .solution}
{: .challenge}

This is not to say that scale does not matter. We will surely encounter datasets big enough not to fit our own laptop. [Episode 3]({{ "03-structures/index.html" | relative_url }}) discusses scalability and speed.
