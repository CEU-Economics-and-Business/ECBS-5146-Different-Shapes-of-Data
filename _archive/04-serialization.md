---
title: "Data Serialization for Ease of Sharing"
teaching: 130
exercises: 70
questions:
- What are the benefits of text file relative to binary formats?
- Why cannot open my data in Excel?
- How do I explore large files?
objectives:
- Understand basic robots.txt structure.
- Use wget to download data from the web.
- Understand character encodings and Unicode points.
- Load and save text file with different character encodings.
- Compare popular serialization formats fixed width, CSV, JSON, XML, YAML, JSONlines, Parquet.
- Explain the tradeoffs in data serialization.
- Use head and wc to explore data stored in text files.
- Explore JSON files with jq.
keypoints:
- Always check your character encoding of your "plain text" data. Then immediately convert it in UTF-8.
- Save data in human readable format to facilitate sharing and maintenance.
---

# Reading
1. [Chapter 4 (pages 107-112)](https://ceulearning.ceu.edu/pluginfile.php/412982/mod_folder/content/0/Martin%20Kleppmann%20-%20Designing%20Data%20Intensive%20Applications.pdf?forcedownload=1) of Kleppmann 2016. 
2. Joel Spolsky's [essay on Unicode](https://www.joelonsoftware.com/2003/10/08/the-absolute-minimum-every-software-developer-absolutely-positively-must-know-about-unicode-and-character-sets-no-excuses/)
1. [`curl` tutorial](https://curl.haxx.se/docs/httpscripting.html)
2. Laiacano, Adam. 2012. "(Re)Organizing the Web’s Data." in McCallum, Q. Ethan (ed), "Bad Data Handbook." O'Reilly.
3. [For loops](http://swcarpentry.github.io/shell-novice/05-loop/index.html) and [shell scripts](http://swcarpentry.github.io/shell-novice/06-script/index.html)

# Setup
1. If you use Windows, install [Git Bash](https://git-scm.com/download/win) and the [Software Carpentry Installer](https://github.com/swcarpentry/windows-installer/releases/download/v0.3/SWCarpentryInstaller.exe), following [these instructions](https://www.youtube.com/watch?v=339AEqk9c-8). If you use Mac or Linux, you don't need to download these.
2. [Download jq](https://stedolan.github.io/jq/download/), a command-line JSON processor.
3. Make sure you have a [text editor](https://carpentries.github.io/workshop-template/#editor) you are comfortable working with.

# Getting data from the web

![How URLs work by Julia Evans](https://pbs.twimg.com/media/ECA-PX3XsAAdaOs?format=jpg&name=large)

Get the page at [https://scrapethissite.com/pages/simple/](https://scrapethissite.com/) using `curl`.
```
curl https://scrapethissite.com/pages/simple/ -o index.html
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

We can save to a different file using the `-o` option.
```
curl https://scrapethissite.com/pages/simple/ -o otherfile.xhtml
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
    curl http://onkormanyzat.gyor.hu/cikklista/uvegzseb.html/$page-oldal -o $page.html
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
> Write a shell script to download all years of wage the for the [California Superior Court](https://publicpay.ca.gov/Reports/RawExport.aspx). (Optional: unzip the files.)
>> ## Solution
>> ```
>> for year in {2013..2019}
>> do
>>    curl "https://publicpay.ca.gov/RawExport/${year}_SuperiorCourt.zip" -o ${year}.zip
>>    unzip ${year}.zip
>> done
>> ```
>> {: .language-bash}
> {: .solution}
{: .challenge}


# Data Serialization
With Data Structures (to be discussed later), we organize our data to optimize performance in lookup, matching, or other analytics question. But for storing data and sharing them with others, we have to convert them into a sequence of bytes.

Take, for example, a binary tree. We have to convert ![](https://upload.wikimedia.org/wikipedia/commons/d/da/Binary_search_tree.svg) into
```
080310010614040713
```
or something similar.


> ## Binary vs text based
> Binary formats have the benefits of taking less storage space and (potentially) being optimized for fast reading and writing. But they may require specialized software to work with. By contrast, text-based formats are more easily exchanged with other users on other systems.
> 
> You can get the best of both worlds by compressing your text-based representation. For example, all .xslx files are ZIP-compressed archives of a bunch of machine- and human-readbale XML files. Much easier to read and write than Microsoft's earlier Excel Binary Format (.xls).
> 
> ```
> bash-5.0$ cp seller.xlsx seller.zip
> bash-5.0$ unzip seller.zip 
> Archive:  seller.zip
>   inflating: _rels/.rels             
>   inflating: docProps/app.xml        
>   inflating: docProps/core.xml       
>   inflating: xl/_rels/workbook.xml.rels  
>   inflating: xl/styles.xml           
>   inflating: xl/workbook.xml         
>   inflating: [Content_Types].xml     
>   inflating: xl/worksheets/sheet1.xml  
>   inflating: xl/sharedStrings.xml  
> ```
> {: .language-bash}
{: .discussion}



# Exploring files
> ## Exercise
> Get the following three tables with `curl` from `https://github.com/CEU-Economics-and-Business/ECBS-5146-Different-Shapes-of-Data/raw/master/data/ted/*.csv`: `seller`, `buyer`, `lot`.
{: .challenge}

```
bash-5.0$ pwd
/Users/koren/Downloads/data-architecture
bash-5.0$ ls -l
total 22392
-rw-r--r--@ 1 koren  staff  4038665 Nov 17 17:33 buyer.csv
-rw-r--r--@ 1 koren  staff  4738428 Nov 17 17:33 lot.csv
-rw-r--r--@ 1 koren  staff  2680572 Nov 17 17:33 seller.csv
```
{: .language-bash}

If you are not in the folder where you exported the tables, navigate there using `cd`.

The command `ls` not only shows us the files in the folder, but also their size. We can display file sizes in human readable form by turning on the `h` option of `ls`,

```
bash-5.0$ ls -lh
total 22392
-rw-r--r--@ 1 koren  staff   3.9M Nov 17 17:33 buyer.csv
-rw-r--r--@ 1 koren  staff   4.5M Nov 17 17:33 lot.csv
-rw-r--r--@ 1 koren  staff   2.6M Nov 17 17:33 seller.csv
```
{: .language-bash}

It is good to review the size of a file before attempting to open it.

# Comma Separated Values
The [CSV format](https://en.wikipedia.org/wiki/Comma-separated_values#Standardization) is a standard plain text format for tabular data.

```
ID_AWARD,ID_LOT_AWARDED,CAE_NAME,ISO_COUNTRY_CODE
8447168,,European Commission-Directorate General for Energy,LU
8447171,,"European Commission, Directorate-General for Environment",BE
8447173,,Gemeinde Unterföhring,DE
8448129,,Verwaltungsgemeinschaft Altfraunhofen,DE
8448343,,Verbandsgemeindewerke St. Goar-Oberwesel,DE
8448585,,Barmherzige Brüder gemeinnützige Krankenhaus GmbH,DE
8448586,,Barmherzige Brüder gemeinnützige Krankenhaus GmbH,DE
8448609,1,IT.NRW,DE
8448610,2,IT.NRW,DE
```

The first row ("header"), contains the column names. There are not other metadata, notably we do not know the data types in each column.

Subsequent rows are a comma-separated list of cells.

Note that the third row, because the column `CAE_NAME` contains a comma, is escaped with double quotes. Otherwise, quotes are unnecessary for strings.

Because one observation is one line, it is easy to count the number of observations in a .csv file. (An exception is if a long text field includes line breaks.)

```
bash-5.0$ wc -l buyer.csv 
   58003 buyer.csv
```
{: .language-bash}

The file `buyer.csv` includes 58003 lines, one of which is the header. It hence has 58002 observations.

> ## Exercise
> What is the number of observations in the `seller` table?
>> ## Solution
>> ```
>> bash-5.0$ wc -l seller.csv 
>>    61702 seller.csv
>> ```
>> {: .language-bash}
>> There are 61,701 observations in `seller.csv`.
> {: .solution}
{: .challenge}

We can explore large .csv files by checking their first few lines. The bash command `head` can do exactly this.

```
bash-5.0$ head seller.csv 
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

We can set how many lines to show with the `-n` option. This can be used to create a smaller (non-random!) sample to explore with our favorite spreadsheet editor.

```
bash-5.0$ head -n2 seller.csv 
ID_AWARD,ID_LOT_AWARDED,WIN_NAME,WIN_COUNTRY_CODE
8447168,,Dialogika GmbH,DE
```
{: language-bash}

> ## Exercise
> Create a 1000-row sample from `seller.csv`. Recall that you can redirect the output of a bash command to a file with `> output.txt` (or whatever file name you give). Make sure your file name ends in .csv so that you can open it with a spreadsheet editor.
>> ## Solution
>> ```
>> bash-5.0$ head -n1000 seller.csv > seller-1000.csv
>> bash-5.0$ ls -lh
>> total 22496
>> -rw-r--r--@ 1 koren  staff   3.9M Nov 17 17:33 buyer.csv
>> -rw-r--r--@ 1 koren  staff   4.5M Nov 17 17:33 lot.csv
>> -rw-r--r--  1 koren  staff    50K Nov 17 18:00 seller-1000.csv
>> -rw-r--r--@ 1 koren  staff   2.6M Nov 17 17:33 seller.csv
>> ```
>> {: .language-bash}
> {: .solution}
{: .challenge}

# Character encoding

### Libre Office gives you complete control over your .csv files
![Libre Office gives you complete control over your .csv files]({{ "/fig/libre-office-open-csv.png" | relative_url }})

### Make sure you select the corrent encoding
![Make sure you select the corrent encoding]({{ "/fig/libre-office-wrong-encoding.png" | relative_url }})

### You can also open a .csv file in a text editor
![You can also open a .csv file in a text editor]({{ "/fig/sublime-text-csv.png" | relative_url }})

> ## Exercise
> Download the [_Verbannten Bücher_ dataset](https://www.berlin.de/berlin-im-ueberblick/geschichte/berlin-im-nationalsozialismus/verbannte-buecher/suche/index.php/index/all.csv?q=) in .csv. Open it in Excel. What is wrong? Display the contents in the shell using `head`.
>> ## Solution
>> ```
>> bash-5.0$ head all.csv 
>> "id";"ssflag";"pagenumberinocrdocument";"authorfirstname";"authorlastname";"title";"firsteditionpublisher";"firsteditionpublicationplace";"firsteditionpublicationyear";"secondeditionpublisher";"secondeditionpublicationplace";"secondeditionpublicationyear";"additionalinfos";"ocrresult"
>> "70526";"2";"0";"Adler";"Alfred";"Praxis und Theorie der Individualpsychologie";"Bergmann";"München";"1930";"";"";"";"";"Adler, Alfred: Praxis und Theorie der Individualpsychologie. München: Bergmann 1930. "
>> "70527";"2";"2";"Bruno";"Adler";"Sämtliche Schriften";"";"";"";"";"";"";"";"Adler, Bruno: Sämtliche Schriften."
>> "70528";"2";"2";"Felix";"Adler";"Der Moralunterricht der Kinder";"Dümmler";"Berlin";"1894";"";"";"";"";"Adler, Felix: Der Moralunterricht der Kinder. Berlin: Dümmler 1894."
>> "70529";"2";"2";"Friedrich (Wolfgang)";"Adler";"Sämtliche Schriften";"";"";"";"";"";"";"";"Adler, Friedrich (Wolfgang): Sämtliche Schriften."
>> "70530";"2";"2";"Georg";"Adler";"Sämtliche Schriften";"";"";"";"";"";"";"";"Adler, Georg: Sämtliche Schriften."
>> "70531";"2";"2";"Max";"Adler";"Sämtliche Schriften";"";"";"";"";"";"";"";"Adler, Max: Sämtliche Schriften."
>> "70532";"2";"2";"Otto";"Adler";"Sämtliche Schriften";"";"";"";"";"";"";"";"Adler, Otto: Sämtliche Schriften."
>> "70533";"2";"2";"Viktor";"Adler";"Sämtliche Schriften";"";"";"";"";"";"";"";"Adler, Viktor: Sämtliche Schriften."
>> "70534";"2";"2";"";"Adolf, Gustav (Pseud.)";"Syphilis. Einstundenspiel aus der Nachkriegszeit";"Jensen";"Swinemünde";"1921";"";"";"";"";"Adolf, Gustav (Pseud.): Syphilis. Einstundenspiel aus der Nachkriegszeit. Swinemünde: Jensen 1921."
>> ```
>> This is actually semicolon-separated, not comma separated.
> {: .solution}
{: .challenge}

Practically everything can read .csv. Here is how to do it in Python.
```
import csv
for row in csv.reader(open('seller.csv', 'rt')):
  print(row)
# can also read the headers from the first line
for row in csv.DictReader(open('seller.csv', 'rt')):
  print(row['WIN_NAME'], row['WIN_COUNTRY_CODE'])
```
{: .language-python}

# JSON (Javascript Object Notation) 
Export the seller table from `DE.sqlite` in JSON using "File", "Export", "Table to JSON". 

```
bash-5.0$ ls -lh
total 64440
-rw-r--r--@ 1 koren  staff   879K Nov 17 19:13 all.csv
-rw-r--r--@ 1 koren  staff   3.9M Nov 17 17:33 buyer.csv
-rw-r--r--  1 koren  staff    10M Nov 17 19:21 buyer.json
-rw-r--r--@ 1 koren  staff   4.5M Nov 17 17:33 lot.csv
-rw-r--r--  1 koren  staff    50K Nov 17 18:00 seller-1000.csv
-rw-r--r--@ 1 koren  staff   2.6M Nov 17 17:33 seller.csv
-rw-r--r--  1 koren  staff   9.4M Nov 17 19:21 seller.json
```
{: .language-bash}

Note that `seller.json` is much larger than `seller.csv`, because of the special boilerplate characters `[], {}` and extra indentation for better viewing.

```
bash-5.0$ head seller.json 
[
    {
        "ID_AWARD": 8447168,
        "ID_LOT_AWARDED": "",
        "WIN_COUNTRY_CODE": "DE",
        "WIN_NAME": "Dialogika GmbH"
    },
    {
        "ID_AWARD": 8447171,
        "ID_LOT_AWARDED": "",
```
{: .language-bash}

In JSON, you can have string and numeric _literals_, _lists_ (arrays) and _dictionaries_ (objects). (See [full definition](http://www.json.org/).)

```
["apple", "banana", "plum"]
```

You have to use double quotes to write strings, single quotes are not acceptable.

```
{"name": "apple", "type": "fruit", "quantity": 2, "unit": "kg"}
```

```
[
  { "name": "apple", 
    "type": "fruit", 
    "quantity": 2, 
    "unit": "kg"},
  { "name": "carrot", 
    "type": "vegetable", 
    "quantity": 1, 
    "unit": "kg"}
]
```
You can use whitespace to make JSON more readable, but pay attention to limiting commas. 

> ## Exercise
> What is wrong with the following JSON string? You can put it in a [JSON validator](https://codebeautify.org/jsonvalidator) to check.
> ```
> [
>  "fruits": [
>   {name: "apple", color: 'red'},
>   {name: "banana", color: 'yellow'},
>   ]
> ```
>> ## Solution
>> 1. Outside parantheses should be curly to create an _object_, not an _array_.
>> 2. Dictionary keys (`name`, `color`) are not quoted.
>> 3. Do not use single quotes.
>> 4. Last element in an array cannot be followed by comma.
>> 5. No closing bracket for object.
> {: .solution}
{: .challenge}

> ## JSON on the web
> JSON has become the de facto standard for data sharing between web applications, maybe because of its link to JavaScript, which is the standard frontend language. It is easy to parse and process.
{: .discussion}

## A JSON document
Take the first JSON document in the _Offene Register_ data.
```
{
  "all_attributes": {
    "_registerArt": "HRB",
    "_registerNummer": "150148",
    "additional_data": {
      "AD": true,
      "CD": true,
      "DK": true,
      "HD": false,
      "SI": true,
      "UT": true,
      "VÖ": false
    },
    "federal_state": "Hamburg",
    "native_company_number": "Hamburg HRB 150148",
    "registered_office": "Hamburg",
    "registrar": "Hamburg"
  },
  "company_number": "K1101R_HRB150148",
  "current_status": "currently registered",
  "jurisdiction_code": "de",
  "name": "olly UG (haftungsbeschränkt)",
  "officers": [
    {
      "name": "Oliver Keunecke",
      "other_attributes": {
        "city": "Hamburg",
        "firstname": "Oliver",
        "flag": "vertretungsberechtigt gemäß allgemeiner Vertretungsregelung",
        "lastname": "Keunecke"
      },
      "position": "Geschäftsführer",
      "start_date": "2018-02-06",
      "type": "person"
    }
  ],
  "registered_address": "Waidmannstraße 1, 22769 Hamburg.",
  "retrieved_at": "2018-11-09T18:03:03Z"
}
```

This is a _denormalized_ data, containing all the relevant relations of the firm.

> ## JSON lines
> Because arrays and objects in JSON have to end with `]` or `}`, we cannot really finish processing a JSON file until we read it all in memory. This can be limiting for large files.
> 
> [JSON lines](http://jsonlines.org/) to the rescue. In a .jsonl file, each line stores a valid JSON document.
{: .callout}

# YAML
[YAML](https://yaml.org/) is essentially JSON for humans. It replaces brackets and other boilerplate with human-readable whitespace. [YAML is my favorite](https://ceu-economics-and-business.github.io/ECBS-5148-Data-Architecture/04-serialization/index.html#yaml), but we will omit it here.

## XML
XML, [Extensible Markup Language](https://en.wikipedia.org/wiki/XML), is an early but robust format for serializing structured documents.

The logic is similar to JSON, but the terminology is a bit different and XML has richer features.

Each XML document has to have a root _element_. Indeed each string or number literal has to be embedded in either an _element_ or an _attribute_ (see later).
```
<basket>
  <fruit>apple</fruit>
  <fruit>banana</fruit>
  <fruit>plum</fruit>
</basket>
```
{:. language-xml}

There is no need to quote strings. The indentation is optional, but improves legibility.

The child elements can have different _tags_.
```
<item>
  <name>apple</name>
  <type>fruit</type>
  <quantity>2</quantity>
  <unit>kg</unit>
</item>
```
If there is only one of each type of child, they can also be encoded as _attributes_.
```
<item name="apple" type="fruit" quantity="2" unit="kg"></item>
```
Note that double quotes even for numbers. When there is nothing between the opening and closing tag, we can write `<item/>` such as
```
<item name="apple" type="fruit" quantity="2" unit="kg"/>
```
It is a matter of choice if we put a piece of data as a child element or as an attribute. Attributes are unique (like keys of a dictionary), but child elements are not. The following is valid XML, for example, but your user will be baffled by the type of fruit you are looking for.
```
<item>
  <name>apple</name>
  <type>fruit</type>
  <quantity>2</quantity>
  <unit>kg</unit>
  <name>banana</name>
</item>
```
By contrast, `<item name="apple" name="banana"/>` is invalid. You can validate [XML online](https://codebeautify.org/xmlvalidator).

The natural distinction is to use entities as elements and attributes as, well, attributes.
```
<basket>
  <item name="apple" type="fruit" quantity="2" unit="kg"/>
  <item name="carrot" type="vegetable" quantity="1" unit="kg"/>
</basket>
```
Or, in a fuller example:
```
<company company_number="K1101R_HRB150148" current_status="currently registered" jurisdiction_code="de" name="olly UG (haftungsbeschränkt)" registered_address="Waidmannstraße 1, 22769 Hamburg." retrieved_at="2018-11-09T18:03:03Z">
  <all_attributes>
    <_registerArt>HRB</_registerArt>
    <_registerNummer>150148</_registerNummer>
    <additional_data>
      <AD>true</AD>
      <CD>true</CD>
      <DK>true</DK>
      <HD>false</HD>
      <SI>true</SI>
      <UT>true</UT>
      <VÖ>false</VÖ>
    </additional_data>
    <federal_state>Hamburg</federal_state>
    <native_company_number>Hamburg HRB 150148</native_company_number>
    <registered_office>Hamburg</registered_office>
    <registrar>Hamburg</registrar>
  </all_attributes>
  <officers>
    <officer name="Oliver Keunecke" position="Geschäftsführer" start_date="2018-02-06" type="person">
      <other_attributes>
        <city>Hamburg</city>
        <firstname>Oliver</firstname>
        <flag>vertretungsberechtigt gemäß allgemeiner Vertretungsregelung</flag>
        <lastname>Keunecke</lastname>
      </other_attributes>
    </officer>
  </officers>
</company>
```

> ## Watch your language
> JSON has *arrays* and *objects*. Objects have *names* and *values*. XML has *elements*. Elements are made of *tags*, *content*, and potentially, *attributes*.
{: .callout}

> ## Exercise
> Represent the following binary tree in a JSON object, using the "word", "left" and "right" tags.
> [![](https://mermaid.ink/img/eyJjb2RlIjoiZ3JhcGggVERcbiAgICBsb3ZlIC0tPnxsZWZ0fCBhdXRob3JpdHlcbiAgICBsb3ZlIC0tPnxyaWdodHwgdHJvdXNlcnNcbiAgICB0cm91c2VycyAtLT58bGVmdHwgY3V0IiwibWVybWFpZCI6eyJ0aGVtZSI6ImRlZmF1bHQiLCJ0aGVtZVZhcmlhYmxlcyI6eyJiYWNrZ3JvdW5kIjoid2hpdGUiLCJwcmltYXJ5Q29sb3IiOiIjRUNFQ0ZGIiwic2Vjb25kYXJ5Q29sb3IiOiIjZmZmZmRlIiwidGVydGlhcnlDb2xvciI6ImhzbCg4MCwgMTAwJSwgOTYuMjc0NTA5ODAzOSUpIiwicHJpbWFyeUJvcmRlckNvbG9yIjoiaHNsKDI0MCwgNjAlLCA4Ni4yNzQ1MDk4MDM5JSkiLCJzZWNvbmRhcnlCb3JkZXJDb2xvciI6ImhzbCg2MCwgNjAlLCA4My41Mjk0MTE3NjQ3JSkiLCJ0ZXJ0aWFyeUJvcmRlckNvbG9yIjoiaHNsKDgwLCA2MCUsIDg2LjI3NDUwOTgwMzklKSIsInByaW1hcnlUZXh0Q29sb3IiOiIjMTMxMzAwIiwic2Vjb25kYXJ5VGV4dENvbG9yIjoiIzAwMDAyMSIsInRlcnRpYXJ5VGV4dENvbG9yIjoicmdiKDkuNTAwMDAwMDAwMSwgOS41MDAwMDAwMDAxLCA5LjUwMDAwMDAwMDEpIiwibGluZUNvbG9yIjoiIzMzMzMzMyIsInRleHRDb2xvciI6IiMzMzMiLCJtYWluQmtnIjoiI0VDRUNGRiIsInNlY29uZEJrZyI6IiNmZmZmZGUiLCJib3JkZXIxIjoiIzkzNzBEQiIsImJvcmRlcjIiOiIjYWFhYTMzIiwiYXJyb3doZWFkQ29sb3IiOiIjMzMzMzMzIiwiZm9udEZhbWlseSI6IlwidHJlYnVjaGV0IG1zXCIsIHZlcmRhbmEsIGFyaWFsIiwiZm9udFNpemUiOiIxNnB4IiwibGFiZWxCYWNrZ3JvdW5kIjoiI2U4ZThlOCIsIm5vZGVCa2ciOiIjRUNFQ0ZGIiwibm9kZUJvcmRlciI6IiM5MzcwREIiLCJjbHVzdGVyQmtnIjoiI2ZmZmZkZSIsImNsdXN0ZXJCb3JkZXIiOiIjYWFhYTMzIiwiZGVmYXVsdExpbmtDb2xvciI6IiMzMzMzMzMiLCJ0aXRsZUNvbG9yIjoiIzMzMyIsImVkZ2VMYWJlbEJhY2tncm91bmQiOiIjZThlOGU4IiwiYWN0b3JCb3JkZXIiOiJoc2woMjU5LjYyNjE2ODIyNDMsIDU5Ljc3NjUzNjMxMjglLCA4Ny45MDE5NjA3ODQzJSkiLCJhY3RvckJrZyI6IiNFQ0VDRkYiLCJhY3RvclRleHRDb2xvciI6ImJsYWNrIiwiYWN0b3JMaW5lQ29sb3IiOiJncmV5Iiwic2lnbmFsQ29sb3IiOiIjMzMzIiwic2lnbmFsVGV4dENvbG9yIjoiIzMzMyIsImxhYmVsQm94QmtnQ29sb3IiOiIjRUNFQ0ZGIiwibGFiZWxCb3hCb3JkZXJDb2xvciI6ImhzbCgyNTkuNjI2MTY4MjI0MywgNTkuNzc2NTM2MzEyOCUsIDg3LjkwMTk2MDc4NDMlKSIsImxhYmVsVGV4dENvbG9yIjoiYmxhY2siLCJsb29wVGV4dENvbG9yIjoiYmxhY2siLCJub3RlQm9yZGVyQ29sb3IiOiIjYWFhYTMzIiwibm90ZUJrZ0NvbG9yIjoiI2ZmZjVhZCIsIm5vdGVUZXh0Q29sb3IiOiJibGFjayIsImFjdGl2YXRpb25Cb3JkZXJDb2xvciI6IiM2NjYiLCJhY3RpdmF0aW9uQmtnQ29sb3IiOiIjZjRmNGY0Iiwic2VxdWVuY2VOdW1iZXJDb2xvciI6IndoaXRlIiwic2VjdGlvbkJrZ0NvbG9yIjoicmdiYSgxMDIsIDEwMiwgMjU1LCAwLjQ5KSIsImFsdFNlY3Rpb25Ca2dDb2xvciI6IndoaXRlIiwic2VjdGlvbkJrZ0NvbG9yMiI6IiNmZmY0MDAiLCJ0YXNrQm9yZGVyQ29sb3IiOiIjNTM0ZmJjIiwidGFza0JrZ0NvbG9yIjoiIzhhOTBkZCIsInRhc2tUZXh0TGlnaHRDb2xvciI6IndoaXRlIiwidGFza1RleHRDb2xvciI6IndoaXRlIiwidGFza1RleHREYXJrQ29sb3IiOiJibGFjayIsInRhc2tUZXh0T3V0c2lkZUNvbG9yIjoiYmxhY2siLCJ0YXNrVGV4dENsaWNrYWJsZUNvbG9yIjoiIzAwMzE2MyIsImFjdGl2ZVRhc2tCb3JkZXJDb2xvciI6IiM1MzRmYmMiLCJhY3RpdmVUYXNrQmtnQ29sb3IiOiIjYmZjN2ZmIiwiZ3JpZENvbG9yIjoibGlnaHRncmV5IiwiZG9uZVRhc2tCa2dDb2xvciI6ImxpZ2h0Z3JleSIsImRvbmVUYXNrQm9yZGVyQ29sb3IiOiJncmV5IiwiY3JpdEJvcmRlckNvbG9yIjoiI2ZmODg4OCIsImNyaXRCa2dDb2xvciI6InJlZCIsInRvZGF5TGluZUNvbG9yIjoicmVkIiwibGFiZWxDb2xvciI6ImJsYWNrIiwiZXJyb3JCa2dDb2xvciI6IiM1NTIyMjIiLCJlcnJvclRleHRDb2xvciI6IiM1NTIyMjIiLCJjbGFzc1RleHQiOiIjMTMxMzAwIiwiZmlsbFR5cGUwIjoiI0VDRUNGRiIsImZpbGxUeXBlMSI6IiNmZmZmZGUiLCJmaWxsVHlwZTIiOiJoc2woMzA0LCAxMDAlLCA5Ni4yNzQ1MDk4MDM5JSkiLCJmaWxsVHlwZTMiOiJoc2woMTI0LCAxMDAlLCA5My41Mjk0MTE3NjQ3JSkiLCJmaWxsVHlwZTQiOiJoc2woMTc2LCAxMDAlLCA5Ni4yNzQ1MDk4MDM5JSkiLCJmaWxsVHlwZTUiOiJoc2woLTQsIDEwMCUsIDkzLjUyOTQxMTc2NDclKSIsImZpbGxUeXBlNiI6ImhzbCg4LCAxMDAlLCA5Ni4yNzQ1MDk4MDM5JSkiLCJmaWxsVHlwZTciOiJoc2woMTg4LCAxMDAlLCA5My41Mjk0MTE3NjQ3JSkifX0sInVwZGF0ZUVkaXRvciI6ZmFsc2V9)](https://mermaid-js.github.io/mermaid-live-editor/#/edit/eyJjb2RlIjoiZ3JhcGggVERcbiAgICBsb3ZlIC0tPnxsZWZ0fCBhdXRob3JpdHlcbiAgICBsb3ZlIC0tPnxyaWdodHwgdHJvdXNlcnNcbiAgICB0cm91c2VycyAtLT58bGVmdHwgY3V0IiwibWVybWFpZCI6eyJ0aGVtZSI6ImRlZmF1bHQiLCJ0aGVtZVZhcmlhYmxlcyI6eyJiYWNrZ3JvdW5kIjoid2hpdGUiLCJwcmltYXJ5Q29sb3IiOiIjRUNFQ0ZGIiwic2Vjb25kYXJ5Q29sb3IiOiIjZmZmZmRlIiwidGVydGlhcnlDb2xvciI6ImhzbCg4MCwgMTAwJSwgOTYuMjc0NTA5ODAzOSUpIiwicHJpbWFyeUJvcmRlckNvbG9yIjoiaHNsKDI0MCwgNjAlLCA4Ni4yNzQ1MDk4MDM5JSkiLCJzZWNvbmRhcnlCb3JkZXJDb2xvciI6ImhzbCg2MCwgNjAlLCA4My41Mjk0MTE3NjQ3JSkiLCJ0ZXJ0aWFyeUJvcmRlckNvbG9yIjoiaHNsKDgwLCA2MCUsIDg2LjI3NDUwOTgwMzklKSIsInByaW1hcnlUZXh0Q29sb3IiOiIjMTMxMzAwIiwic2Vjb25kYXJ5VGV4dENvbG9yIjoiIzAwMDAyMSIsInRlcnRpYXJ5VGV4dENvbG9yIjoicmdiKDkuNTAwMDAwMDAwMSwgOS41MDAwMDAwMDAxLCA5LjUwMDAwMDAwMDEpIiwibGluZUNvbG9yIjoiIzMzMzMzMyIsInRleHRDb2xvciI6IiMzMzMiLCJtYWluQmtnIjoiI0VDRUNGRiIsInNlY29uZEJrZyI6IiNmZmZmZGUiLCJib3JkZXIxIjoiIzkzNzBEQiIsImJvcmRlcjIiOiIjYWFhYTMzIiwiYXJyb3doZWFkQ29sb3IiOiIjMzMzMzMzIiwiZm9udEZhbWlseSI6IlwidHJlYnVjaGV0IG1zXCIsIHZlcmRhbmEsIGFyaWFsIiwiZm9udFNpemUiOiIxNnB4IiwibGFiZWxCYWNrZ3JvdW5kIjoiI2U4ZThlOCIsIm5vZGVCa2ciOiIjRUNFQ0ZGIiwibm9kZUJvcmRlciI6IiM5MzcwREIiLCJjbHVzdGVyQmtnIjoiI2ZmZmZkZSIsImNsdXN0ZXJCb3JkZXIiOiIjYWFhYTMzIiwiZGVmYXVsdExpbmtDb2xvciI6IiMzMzMzMzMiLCJ0aXRsZUNvbG9yIjoiIzMzMyIsImVkZ2VMYWJlbEJhY2tncm91bmQiOiIjZThlOGU4IiwiYWN0b3JCb3JkZXIiOiJoc2woMjU5LjYyNjE2ODIyNDMsIDU5Ljc3NjUzNjMxMjglLCA4Ny45MDE5NjA3ODQzJSkiLCJhY3RvckJrZyI6IiNFQ0VDRkYiLCJhY3RvclRleHRDb2xvciI6ImJsYWNrIiwiYWN0b3JMaW5lQ29sb3IiOiJncmV5Iiwic2lnbmFsQ29sb3IiOiIjMzMzIiwic2lnbmFsVGV4dENvbG9yIjoiIzMzMyIsImxhYmVsQm94QmtnQ29sb3IiOiIjRUNFQ0ZGIiwibGFiZWxCb3hCb3JkZXJDb2xvciI6ImhzbCgyNTkuNjI2MTY4MjI0MywgNTkuNzc2NTM2MzEyOCUsIDg3LjkwMTk2MDc4NDMlKSIsImxhYmVsVGV4dENvbG9yIjoiYmxhY2siLCJsb29wVGV4dENvbG9yIjoiYmxhY2siLCJub3RlQm9yZGVyQ29sb3IiOiIjYWFhYTMzIiwibm90ZUJrZ0NvbG9yIjoiI2ZmZjVhZCIsIm5vdGVUZXh0Q29sb3IiOiJibGFjayIsImFjdGl2YXRpb25Cb3JkZXJDb2xvciI6IiM2NjYiLCJhY3RpdmF0aW9uQmtnQ29sb3IiOiIjZjRmNGY0Iiwic2VxdWVuY2VOdW1iZXJDb2xvciI6IndoaXRlIiwic2VjdGlvbkJrZ0NvbG9yIjoicmdiYSgxMDIsIDEwMiwgMjU1LCAwLjQ5KSIsImFsdFNlY3Rpb25Ca2dDb2xvciI6IndoaXRlIiwic2VjdGlvbkJrZ0NvbG9yMiI6IiNmZmY0MDAiLCJ0YXNrQm9yZGVyQ29sb3IiOiIjNTM0ZmJjIiwidGFza0JrZ0NvbG9yIjoiIzhhOTBkZCIsInRhc2tUZXh0TGlnaHRDb2xvciI6IndoaXRlIiwidGFza1RleHRDb2xvciI6IndoaXRlIiwidGFza1RleHREYXJrQ29sb3IiOiJibGFjayIsInRhc2tUZXh0T3V0c2lkZUNvbG9yIjoiYmxhY2siLCJ0YXNrVGV4dENsaWNrYWJsZUNvbG9yIjoiIzAwMzE2MyIsImFjdGl2ZVRhc2tCb3JkZXJDb2xvciI6IiM1MzRmYmMiLCJhY3RpdmVUYXNrQmtnQ29sb3IiOiIjYmZjN2ZmIiwiZ3JpZENvbG9yIjoibGlnaHRncmV5IiwiZG9uZVRhc2tCa2dDb2xvciI6ImxpZ2h0Z3JleSIsImRvbmVUYXNrQm9yZGVyQ29sb3IiOiJncmV5IiwiY3JpdEJvcmRlckNvbG9yIjoiI2ZmODg4OCIsImNyaXRCa2dDb2xvciI6InJlZCIsInRvZGF5TGluZUNvbG9yIjoicmVkIiwibGFiZWxDb2xvciI6ImJsYWNrIiwiZXJyb3JCa2dDb2xvciI6IiM1NTIyMjIiLCJlcnJvclRleHRDb2xvciI6IiM1NTIyMjIiLCJjbGFzc1RleHQiOiIjMTMxMzAwIiwiZmlsbFR5cGUwIjoiI0VDRUNGRiIsImZpbGxUeXBlMSI6IiNmZmZmZGUiLCJmaWxsVHlwZTIiOiJoc2woMzA0LCAxMDAlLCA5Ni4yNzQ1MDk4MDM5JSkiLCJmaWxsVHlwZTMiOiJoc2woMTI0LCAxMDAlLCA5My41Mjk0MTE3NjQ3JSkiLCJmaWxsVHlwZTQiOiJoc2woMTc2LCAxMDAlLCA5Ni4yNzQ1MDk4MDM5JSkiLCJmaWxsVHlwZTUiOiJoc2woLTQsIDEwMCUsIDkzLjUyOTQxMTc2NDclKSIsImZpbGxUeXBlNiI6ImhzbCg4LCAxMDAlLCA5Ni4yNzQ1MDk4MDM5JSkiLCJmaWxsVHlwZTciOiJoc2woMTg4LCAxMDAlLCA5My41Mjk0MTE3NjQ3JSkifX0sInVwZGF0ZUVkaXRvciI6ZmFsc2V9)
> 
>> ## Solution
>> ```
>> {
>>   "word": "love",
>>   "left": {
>>     "word": "authority"
>>   },
>>   "right": {
>>     "word": "trousers",
>>     "left": {
>>       "word": "cut"
>>     }
>>   }
>> }
>> ```
> {: .solution}
{: .challenge}

> ## Exercise
> Do the same in XML, using an attribute if you can.
>> ## Solution
>> ```
>> <?xml version="1.0" encoding="UTF-8" ?>
>> <root word="love">
>>     <left word="authority"></left>
>>     <right word="trousers">
>>         <left word="cut"></left>
>>     </right>
>> </root>
>> ```
> {: .solution}
{: .challenge}


> ## XML vs JSON vs YAML
> XML is very powerful and extremely widely used as a data interchange format. You can set up XML schemas to validate XML documents. There are even XML database engines. However, it uses a lot of boilerplate (closing tags, for example) and is an eyesore. JSON is much easier on the eyes and YAML is best for humans. Since YAML is not that widely used, JSON seems a good compromise. 
{: .discussion}

