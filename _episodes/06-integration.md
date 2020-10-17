---
title: "Data Integration for Better Information"
teaching: 110
exercises: 35
questions:
- How do I enrich my data with public information?
- What to do if two data sources use different identifiers?
- How can I effectively share metadata?
objectives:
- Recognize standards most often used for identifiers (ISO-3166, ISO-8601).
- Understand basic robots.txt structure.
- Use wget to download data from the web.
- Use for loops in bash to automate data transformations.
- Create conversion tables to respect architectural boundaries of data.
- Create a Data Package to share data and metadata together.
keypoints:
- Use canonical identifiers for entities whenever you can.
- Defer joining tables to the last possible moment.
- Use a concordance table to join data from different sources.
---



# Setup
1. [Download and install](https://gist.github.com/evanwill/0207876c3243bbb6863e65ec5dc3f058) `wget`

# Reading
1. [`wget` tutorial](https://shapeshed.com/unix-wget/)
2. Laiacano, Adam. 2012. "(Re)Organizing the Web’s Data." in McCallum, Q. Ethan (ed), "Bad Data Handbook." O'Reilly.
3. [For loops](http://swcarpentry.github.io/shell-novice/05-loop/index.html) and [shell scripts](http://swcarpentry.github.io/shell-novice/06-script/index.html)

# Getting data from the web

![How URLs work by Julia Evans](https://pbs.twimg.com/media/ECA-PX3XsAAdaOs?format=jpg&name=large)

Get the page at [https://scrapethissite.com/pages/simple/](https://scrapethissite.com/) using `wget`.
```
wget https://scrapethissite.com/pages/simple/
```
{: .language-bash}

This saves `index.html`, which is an XML document. Well, HTML, but proper XHTMLs are a subset of XML.

```
bash-5.0$ head index.html 
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Countries of the World: A Simple Example | Scrape This Site | A public sandbox for learning web scraping</title>
    <link rel="icon" type="image/png" href="/static/images/scraper-icon.png" />

    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="A single page that lists information about all the countries in the world. Good for those just get started with web scraping.">
```
{: .language-bash}

We can save to a different file using the `-O` (uppercase) option.
```
wget https://scrapethissite.com/pages/simple/ -O
```
{: .language-bash}

We will not study HTML parsing, the Bad Data Habdbook and [https://scrapethissite.com/](https://scrapethissite.com/) provides good lessons.

> ## Steps of web scraping
> 1. Reconnaissance
>   - Site permissions, `robots.txt`
>   - Structure of content
> 2. Get the data
>   - For loops and wgets
>   - Save the raw data as it is
> 3. Parse the data
>   - Process HTML (grep, regex, XML parsers)
>   - Often you need more URLs from here 
> 4. Update local data base
{: .discussion}


### Get data about contracts with the city of Győr

[`http://onkormanyzat.gyor.hu/cikklista/uvegzseb.html/1-oldal`](http://onkormanyzat.gyor.hu/cikklista/uvegzseb.html/1-oldal)

1. The contents of [`http://onkormanyzat.gyor.hu/robots.txt`](http://onkormanyzat.gyor.hu/robots.txt
)
```
User-agent: *
Disallow: /adatok
Disallow: /data/files
Allow: /
```
The URLs we want to scrape are at `/cikk`, so we are good to go. Also make sure the check any legal language about restrictions. Note that Hungarian copyright law allows you to make copies of published website content __for research purposes__.


2. Find the patterns in URLs `http://onkormanyzat.gyor.hu/cikklista/uvegzseb.html/{}-oldal`.

Write a for loop in bash.
```
for page in {1..129}
do
    echo $page
done
```
{: .language-bash}

We can also put this in a script.

Using the URL pattern we discovered,
```
for page in {1..5}
do
    wget http://onkormanyzat.gyor.hu/cikklista/uvegzseb.html/$page-oldal -O $page.html
done
```
{: .language-bash}

```
bash-5.0$ ls -lh
total 84440
-rw-r--r--  1 koren  staff    41K Dec  3 05:43 1.html
-rw-r--r--  1 koren  staff    42K Dec  3 05:43 2.html
-rw-r--r--  1 koren  staff    42K Dec  3 05:43 3.html
-rw-r--r--  1 koren  staff    42K Dec  3 05:43 4.html
-rw-r--r--  1 koren  staff    42K Dec  3 05:43 5.html
```
{: .language-bash}


The content of [`https://publicpay.ca.gov/robots.txt`](https://publicpay.ca.gov/robots.txt)
```
User-agent: *
Disallow: /ScriptResource.axd
Disallow: /scriptresource.axd
Disallow: /WebResource.axd
Disallow: /webresource.axd
Disallow: /Reserved.ReportViewerWebControl.axd
Disallow: /reserved.reportviewerwebcontrol.axd
```

> ## Exercise
> Write a shell script to download all years of wage the for the [California Superior Court](https://publicpay.ca.gov/Reports/RawExport.aspx).
{: .challenge}

# Merge on data by canonical identifiers
We want to check whether procurement winners come from rich and large countries. Get GDP data from [https://datahub.io/core/gdp](https://datahub.io/core/gdp)

```
$ wget -q https://datahub.io/core/gdp/r/gdp.csv
$ head gdp.csv
Country Name,Country Code,Year,Value
Arab World,ARB,1968,25760683041.0857
Arab World,ARB,1969,28434203615.4829
Arab World,ARB,1970,31385499664.0672
Arab World,ARB,1971,36426909888.3928
Arab World,ARB,1972,43316056615.4562
Arab World,ARB,1973,55018394945.5825
Arab World,ARB,1974,105145803084.377
Arab World,ARB,1975,116337021938.341
Arab World,ARB,1976,144846175400.488
```
{: .language-bash}
We have 3-letter country (and region) codes. But in `seller.csv` we have 2-letter codes.
```
$ head seller.csv 
ID_AWARD,ID_LOT_AWARDED,WIN_NAME,WIN_COUNTRY_CODE
8447168,,Dialogika GmbH,DE
8447171,,Ecologic Institute gemeinnützige GmbH,DE
8448828,,Josef Meier GmbH &amp; Co. KG Hoch- und Tiefbau,DE
8450085,,Ingenieurbüro Grohmann GmbH,DE
8450155,,Harnisch Creative Planning GmbH,DE
8450240,,Rupprecht Consult Forschung und Beratung GmbH,DE
8452251,1,Architekten Hermann Kaufmann ZT GmbH,AT
8452254,4,Brückner Dietz GmbH,DE
8455072,3,Heraeus Medical GmbH,DE
```
{: .language-bash}

Luckily, we have a **concordance table** between all kinds of [country codes](https://datahub.io/core/country-codes).

> ## Geeking out
> If you work with any kind of official statistical classification, you will come across these [UN-published concordance tables](https://unstats.un.org/unsd/classifications/Econ#Correspondences) sooner or later.
{: .callout}

We see that the 2-letter codes are often (but not always) the first 2 letters of the 3-letter code. **Danger zone!**

<iframe src="https://datahub.io/core/country-codes/r/0.html" width="100%" height="300px" frameborder="0"></iframe>

> ## Exercise
> Download the country code list with `wget`.
>> ## Solution
>> `wget -q https://datahub.io/core/country-codes/r/country-codes.csv`
> {: .solution}
{: .challenge}

> ## Picking your own identifiers
> 1. **If there is a well established identifier for the entity you are describing, use that.** People have Social Security Numbers, firms have Employer Identification Numbers, regions have NUTS or FIPS codes, countries have ISO 3166 codes. Do not invent your own key unless you absolutely have to.
> 2. **Your identifier should be human readable, not just machine readable.** A sequentially increasing integer ID is not very helpful. Nor is an SHA1 hash such as dc6e5923f968db05aee116d94d11792385a9fcca8. Depending on context, combining 2-3 letters and 8-10 digits works best.
> 3. **Identifiers for one type of entity should be easily distinguishable from identifiers for another type of entity.** When you look at an id, you should immediately see what entity it refers to. Everyone in the U.S. knows “08540” is a ZIP-code and “770-10-2831” is a Social Security Number.
> 4. **Use hyphens or other punctuation to denote hierarchy in identifiers.** The ZIP+4 code “53075-1108” clearly delineates the 5-digit ZIP code from the 4-digit routing number. URLs are the best example of hierarchical keys: “github.com/korenmiklos/dc-economics-data” refers to one of my GitHub repos, but you can use this structure to generate URLs for my other repos, or GitHub repos of others.
>> For example, you could use F-DE-01234567 to refer to a German firm. F-HU-12345678 would be a Hungarian firm. (Note the use of 2-letter ISO-3166 country codes.) P-1234567890 could be a person.
{: .discussion}

Depending on the type of entity you are modeling, look out for these existing unique identifiers.

companies
: tax identifier, Employer Identification Number (EIN), EU VAT identifier, Open Corporates ID

individuals
: Social Security Number, email address

regions
: FIPS, NUTS, ZIP-code (although a ZIP code does not refer to an area)

countries
: ISO 3166 standard, 2-letter, 3-letter or numeric identifier

## Joining tables
Once you have the identifiers, you can do the merge in SQL or your software of choice.

### Import .csv files into SQLite
Use File / Import / Table from CSV. Make sure to select "Column names in first line."

### Join three tables

```
SELECT WIN_NAME, WIN_COUNTRY_CODE, "ISO3166-1-Alpha-3"
	FROM seller 
	LEFT JOIN countrycodes
	ON seller.WIN_COUNTRY_CODE = countrycodes."ISO3166-1-Alpha-2";
```
{: .language-sql}

<div class="mermaid">
classDiagram
Country Codes "one" <.. "many" GDP
Country Codes "one" <.. "many" TED
class Country Codes {
    iso-3166-2
    iso-3166-3
}
class GDP {
    iso-3166-3
    gdp
}
class TED {
    iso-3166-2
    WIN_NAME
}
</div>

<iframe src="https://mermaidjs.github.io/mermaid-live-editor/#/view/eyJjb2RlIjoiY2xhc3NEaWFncmFtXG5Db3VudHJ5IENvZGVzIFwib25lXCIgPC4uIFwibWFueVwiIEdEUFxuQ291bnRyeSBDb2RlcyBcIm9uZVwiIDwuLiBcIm1hbnlcIiBURURcbmNsYXNzIENvdW50cnkgQ29kZXMge1xuICAgIGlzby0zMTY2LTJcbiAgICBpc28tMzE2Ni0zXG59XG5jbGFzcyBHRFAge1xuICAgIGlzby0zMTY2LTNcbiAgICBnZHBcbn1cbmNsYXNzIFRFRCB7XG4gICAgaXNvLTMxNjYtMlxuICAgIFdJTl9OQU1FXG59XG4iLCJtZXJtYWlkIjp7InRoZW1lIjoiZGVmYXVsdCJ9fQ" width="100%" height="300px"></iframe>

```
SELECT WIN_NAME, WIN_COUNTRY_CODE, "ISO3166-1-Alpha-3", Value as GDP
	FROM seller 
	LEFT JOIN countrycodes
	ON seller.WIN_COUNTRY_CODE = countrycodes."ISO3166-1-Alpha-2"
	LEFT JOIN gdp
	ON countrycodes."ISO3166-1-Alpha-3" = gdp.CountryCode AND gdp.Year = 2016;
```
{: .language-sql}

> ## Why not convert country code?
> You may be tempted to convert `WIN_COUNTRY_CODE` to a 3-digit ISO-3166 code during the data cleaning. This limits maintainability, however. When you add more data, you will bring in more winning countries which have not yet been converted. It is better to keep a separate concordance table and only join the tables when you actually need them.
{: .discussion}

```
SELECT count(DISTINCT WIN_COUNTRY_CODE) FROM seller;
```
{: .language-sql}

# Saving metadata in a Data Package
Frictionless Data (a brand name of the Open Knowledge Foundation), has a number of [lighweight specifications](https://frictionlessdata.io/specs/) for data sharing.

### The simplest possible `datapackage.json`
```
{
  "resources": [
    {
      "name": "countrycodes",
      "path": "country-codes.csv"
    }
  ]
}
```
Creating a data package for sharing
```
bash-5.0$ mkdir country-codes
bash-5.0$ cp country-codes.csv country-codes/
bash-5.0$ cp datapackage.json country-codes/
bash-5.0$ ls -lh country-codes/
total 264
-rw-r--r--  1 koren  staff   127K Dec  3 07:01 country-codes.csv
-rw-r--r--  1 koren  staff   102B Dec  3 07:02 datapackage.json
bash-5.0$ zip country-codes.zip country-codes/*
  adding: country-codes/country-codes.csv (deflated 68%)
  adding: country-codes/datapackage.json (deflated 28%)
```
{: .language-bash}

### A more complex example
[datapackage.json](https://pkgstore.datahub.io/core/gdp/9/datapackage.json) for GDP data on datahub.io.

Save this and open in [http://create.frictionlessdata.io/](http://create.frictionlessdata.io/)

> ## Challenge
> Create a data package descriptor (`datapackage.json`) for the TED winner data with country GDP. Save the JSON file and the three CSV files in a ZIP archive.
{: .challenge}

