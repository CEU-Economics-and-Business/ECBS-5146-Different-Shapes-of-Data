---
title: Different Shapes of Data. APIs.
teaching: 90
questions:
- What the popular flat file formats used by data analysts?
- How I get data from the internet?
objectives:
- Familiarize popular data file format
- Build data files in different formats
- Understanding URLs used on the internet
- Introducing APIs as data sources
- Exercise REST APIs

keypoints:
- \#CSV
- \#XML
- \#JSON
- \#API
- \#POSTMAN
- \#EUROSTAT API
- \#WORLDBANK API

---

> ## Table of Content
>[Prerequisites for this chapter](#setup)  
>[Flat files as data store](#flat)  
>[CSV](#csv)  
>[XML](#xml)  
>[JSON](#json)  
>[Anatomy of a URL](#url)  
>[Getting data from internet](#internet)  
>[Using Eurostat API](#euro)   
{: .discussion}


<br><br>
<a name="setup"/>
> ## Prerequisites for this chapter
>   * Install: [Postman](https://www.postman.com/downloads/)  
>
>   * Read: Chapter: "When Databases Attack: A Guide for When to Stick to Files" from "Bad Data Handbook"
{: .prereq} 




<br><br>
<a name="flat"/>
## Flat files as data store

#### Advantages
* No additional software required other than OS built in
* You can start exploring the data right away
* Store in any format, invent your own
* Simple
* (Most of them are) Human readable


#### Disadvantages
* Security
* Self managed (e.g. backup)
* Encoding
* Learning time
* Scalability


<br><br>
<a name="csv"/>
## *.csv

![CSV]({{ page.root }}/artifacts/dsd/csv.png)

> ## Format
> ```
>Column name1,Column name2 --> <Header_line>
>Value1,Value2 --> <Record_1_line>
>Value3,Value4 --> <Record_2_line>
>```
>{: .language-html}
{:.callout}

<br/>

- CSV stands for **comma-separated values**
- Used to store tabular data
- Not the *other Excel format* (Popular spreadsheet tools can handle it, but it is not recommended for serious analysts) 
- Not standardized, but has some common characteristics:
    - Optional header
    - Each line after header is a record
    - Record has as much values as defined in the header
    - Values are separated by comma, yet other separators are also allowed (often semicolons) 
    - Values might be quoted, to avoid confusion with separator
    - Beware: line ending can vary from OS to OS, so during the processing you might need to try multiple combinations (\n\r)

<br/>

> ## Example
>```
>First Name;Last Name;Job Title
>Kate,Middleton,Princess
>Bill,Gates,Retired
>Ronald,McDonald,Clown
>```
>{: .language-html}
{:.callout}








<br><br>
<a name="xml"/>
## *.xml


> ## Format
>```
><element>information</element>
><element attribute=“information”>information</element>
><element attribute=“information”/>
><element>
>	<nested-element>information</nested-element>
></element>
>```
>{: .language-html}
{:.callout}


<br/>

- XML stands for **Extensible Markup Language**
- Used to exchange tabular and hierarchical data on web
- The operation of loading in code is called parsing
- Webpage markup XHTML is a subset of XML
- Criticism: verbose, complex and redundant
- Alternative: JSON

<br/>

> ## Example - Variation 1
>```
><persons>
>   <person>
>	    <first_name>Kate</first_name>
>	    <last_name>Middleton</last_name>
>	    <job_title>Princess</job_title>
>   </person>
>   <person>
>	    <first_name>Bill</first_name>
>	    <last_name>Gates</last_name>
>	    <job_title>Retired</job_title>
>   </person>
>   <person>
>	    <first_name>Ronald</first_name>
>	    <last_name>McDonald</last_name>
>	    <job_title>Clown</job_title>
>   </person>
></persons>
>```
>{: .language-html}
{:.callout}


<br/>

> ## Example - Variation 2
>```
><persons>
>   <person>
>   	<name first=“Kate” last=“Middleton”/>
>   	<job title=“Princess”/>
>   </person>
>   <person>
>   	<name first=“Bill” last=“Gates”/>
>   	<job title=“Retired”/>
>   </person>
>   <person>
>   	<name first=“Ronald” last=“McDonald”/>
>   	<job title=“Clown”/>
>   </person>
></persons>
>```
>{: .language-html}
{:.callout}

<br/>

> ## Example - Variation 3
>```
><persons>
>   <person first_name=“Kate” last_name=“Middleton” job_title=“Princess”/>
>   <person first_name=“Bill” last_name=“Gates” job_title=“Retired”/>
>   <person first_name=“Ronald” last_name=“McDonald” job_title=“Clown”/>
></persons>
>```
>{: .language-html}
{:.callout}


<br><br>
<a name="json"/>
## *.json

TBD

<br/><br/><br/>
>## JSON exercise
> TBD 
{: .challenge} 

<a name="url"/>
## Anatomy of a URL 

![URL]({{ page.root }}/artifacts/dsd/url.jpeg)


<br/>
<a name="internet"/>
## Getting data from internet

#### Web scraping
* Data scraping used for extracting data from websites
* Its is not the most robust way to get data (website might change, legal issues)
* Anyway sometimes this is the only way to get the data
* Beyond the scope of this course, you will have lessons later in the program

#### Data through APIs
* Right way to offer data
* Instead of a webpage, server returns a flat file in various formats (csv, json etc)
* Simplest way is REST
* Sometimes is password protected



<br/>
<a name="euro"/>
>## Example - Eurostat API 
>Eurostat is offering a wide range of databases: [https://ec.europa.eu/eurostat/web/main/data/database](https://ec.europa.eu/eurostat/web/main/data/database)
>* Navigate to: Data navigation tree > Database by themes > General and regional statistics	> City statistics (urb) > Cities and greater cities (urb_cgc) > Population on 1 January by age groups and sex - cities and greater cities (urb_cpop1)
>* Click on Data Explorer (second icon) and you'll get this: [https://appsso.eurostat.ec.europa.eu/nui/show.do?dataset=urb_cpop1&lang=en](https://appsso.eurostat.ec.europa.eu/nui/show.do?dataset=urb_cpop1&lang=en)
>* Check the dimensions of this dataset, play around with slicing and dicing
>* Browse to [https://ec.europa.eu/eurostat/web/json-and-unicode-web-services/getting-started/rest-request](https://ec.europa.eu/eurostat/web/json-and-unicode-web-services/getting-started/rest-request) and read it carefully.
>* Now lets build our first query with this: [https://ec.europa.eu/eurostat/web/json-and-unicode-web-services/getting-started/query-builder](https://ec.europa.eu/eurostat/web/json-and-unicode-web-services/getting-started/query-builder)
>* Insert the db name: "urb_cpop1" and click next
>* Now you can specify some dimension values like: Geo selection > Fixed > Bruxelles and indic_ur > DE1003V - Population on the 1st of January, female
>* Click "Generate query filter" and you'll get this URL: [http://ec.europa.eu/eurostat/wdds/rest/data/v2.1/json/en/urb_cpop1?indic_ur=DE1003V&cities=BE001C1&precision=1](http://ec.europa.eu/eurostat/wdds/rest/data/v2.1/json/en/urb_cpop1?indic_ur=DE1003V&cities=BE001C1&precision=1)
>* Try this URL in a browser. What do you see?
>* The more convenient way to work with REST APIs is Postman. Lets paste the previous URL in postman.
{:.callout}


<br/><br/><br/>
>## Exercise - Worldbank API
> TBD 
{: .challenge} 






