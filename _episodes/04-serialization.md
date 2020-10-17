---
title: "Data Serialization for Ease of Sharing"
teaching: 130
exercises: 70
questions:
- What are the benefits of text file relative to binary formats?
- Why cannot open my data in Excel?
- How do I explore large files?
objectives:
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
1. [Chapter 4 (pages 107-112)](https://ceulearning.ceu.edu/mod/resource/view.php?id=288212) of Kleppmann 2016. 
2. Joel Spolsky's [essay on Unicode](https://www.joelonsoftware.com/2003/10/08/the-absolute-minimum-every-software-developer-absolutely-positively-must-know-about-unicode-and-character-sets-no-excuses/)

# Setup
1. If you use Windows, install [Git Bash](https://git-scm.com/download/win) and the [Software Carpentry Installer](https://github.com/swcarpentry/windows-installer/releases/download/v0.3/SWCarpentryInstaller.exe), following [these instructions](https://www.youtube.com/watch?v=339AEqk9c-8). If you use Mac or Linux, you don't need to download these.
2. [Download jq](https://stedolan.github.io/jq/download/), a command-line JSON processor.
3. Make sure you have a [text editor](https://carpentries.github.io/workshop-template/#editor) you are comfortable working with.

# Data Structures vs Data Serialization
With Data Structures, we organize our data to optimize performance in lookup, matching, or other analytics question. But for storing data and sharing them with others, we have to convert them into a sequence of bytes.

Take, for example the binary tree in the last episode. We have to convert ![](https://upload.wikimedia.org/wikipedia/commons/d/da/Binary_search_tree.svg) into
```
080310010614040713
```
or something similar.


> ## Binary vs text based
> Binary formats have the benefits of taking less storage space and (potentially) being optimized for fast reading and writing. But they may require specialized software to work with. By contrast, text-based formats are more easily exchanged with other users on other systems.
> 
> You can get the best of both worlds by compressing your test-based representation. For example, all .xslx files are ZIP-compressed archives of a bunch of machine- and human-readbale XML files. Much easier to read and write than Microsoft's earlier Excel Binary Format (.xls).
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
> Open `DE.sqlite` in the DB Browser for SQLite. Export the following three tables to .csv: `seller`, `buyer`, `lot` using "File", "Export", "Tables to CSV".
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

# Binary and fixed width formats

Take a tabular dataset with rows and columns.
```
bash-5.0$ cat cg18dc63-1000.txt 
E181201            19011462101010    I                           1BE BE    01  COM       000000000073360000000000000000000000035456000000035456                     3     C 11EXW            000000000000                       01
E181201            19011462101010    I                           1FR FR    01  COM       000000000254590000000000000000000000102671000000102671                     3     C 11EXW            000000000000                       01
E181201            19011462101010    I                           1PT PT    01  COM       000000000042070000000000000000000000018037000000018037                     3     C 11EXW            000000000000                       01
E181248            19011162113390    I                           1FR FR    48  COM       000000000019000000000000000000000000191149000000191149                     3     C 11CFR            000000000000                       48
E181248            19011162113390    I                           1SE SE    48  COM       000000000011000000000000000000000000091039000000091039                     3     C 11FOB            000000000000                       48
E181248            19011162113390    I                           1FR FR    48  COM       000000000030000000000000000000000000269543000000269543                     3     C 11FOB            000000000000                       48
E181248            19011162113390    I                           1PT PT    48  COM       000000000001000000000000000000000000005449000000005449                     3     C 11CFR            000000000000                       48
E181248            19011162113390    I                           1CY CY    48  COM       000000000050000000000000000000000000240098000000240098                     3     C 11FOB            000000000000                       48
E181201            19011162179000    I                           1RO RO    01  COM       000000000006500000000000000000000000022945000000027300                     3     C 21CIF            000000000000                       01
E181201            1812276204420090  D                           1MX ES    01  EX 1000   000000000000500000000000001000000000007400000000000000EUR            0     4 BE  T 11CIF            000000000000                       26
E181202            19011162034319    I                           1FR FR    02  COM       000000000694000000000001388000000002484520000002484520                     3     C 11CFR            000000000000                       02
E181202            19011162034319    I                           1PT PT    02  COM       000000000004000000000000008000000000017025000000017025                     3     C 11CFR            000000000000                       02
E181202            19011162034319    I                           1FR FR    02  COM       000000002448000000000004896000000008959036000008959036                     3     C 11CFR            000000000000                       02
```
{: .source}

## Columnar 
Storing rows after rows has the benefit that the file can be read sequentially. I can have a quick peek in my data with `head cg18dc63-1000.txt`. Reading the whole data, however, can be slow for large datasets. This format is also difficult to compress, because patterns are complex.

In a columnar format, we would write out column 1 first, then column 2, etc. Something like
```
EEEEE...
181201181201181202181248181248...
``` 
This is much easier to compress because similar values are repeated in a somewhat regular pattern.

This is the key idea behind the [Apache Parquet](https://databricks.com/glossary/what-is-parquet) format, which is compressed to a fraction of the typical data table size and is very fast to read and write.

Hadoop and Spark can work with `parquet` files, so do Python (with `pandas`) and R (more complicated, but should work with `arrow` library).

```
for row in csv.reader(open('seller.csv')):
....     for i, cell in enumerate(row):
....         if i in columns:
....             columns[i].append(cell)
....         else:
....             columns[i] = [cell]
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

> ## Exercise
> How would you model the _Offene Register_ on an Entity Relation Diagram?
>> ## Solution
>> ```
>> classDiagram
>> class Company
>> class Officer
>> Company "many" .. "many" Officer : (position, start_date)
>> ```
> {: .solution}
{: .challenge}

> ## JSON lines
> Because arrays and objects in JSON have to end with `]` or `}`, we cannot really finish processing a JSON file until we read it all in memory. This can be limiting for large files.
> 
> [JSON lines](http://jsonlines.org/) to the rescue. In a .jsonl file, each line stores a valid JSON document.
{: .callout}

# YAML
[YAML](https://yaml.org/) is essentially JSON for humans. It replaces brackets and other boilerplate with human-readable whitespace.

```
- apple
- banana
- plum
```

There is no need to quote strings.

```
name: apple
type: fruit
quantity: 2
unit: kg
```

You can validate [YAML online](https://codebeautify.org/yaml-validator).

```
- name: apple 
  type: fruit 
  quantity: 2 
  unit: kg
- name: carrot 
  type: vegetable 
  quantity: 1
  unit: kg
```

> ## Benefits of YAML
> 1. Human readable and editable
> 2. Can be processed sequentially
{: .discussion}

Although is much more human readable than JSON, you do not see much data being exchanged in this format. One exception is configuration settings which are often directly edited by humans. For example, if you are writing a document in [(R)Markdown](https://bookdown.org/yihui/rmarkdown/html-document.html), you may have a header like
```
---
title: Habits
author: John Doe
date: March 22, 2005
output: html_document
---
```
This is a YAML-formatted configuration header.

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

> ## Exercise
> Represent the entites in the following nursery rhyme in XML. To save typing, just use two of each, not seven.
> > As I was going to St Ives,  
> > Upon the road I met seven wives;  
> > Every wife had seven sacks,  
> > Every sack had seven cats,  
> > Every cat had seven kits:  
> > Kits, cats, sacks, and wives,  
> > How many were going to St Ives?  
> 
>> ## Solution
>> ```
>> <me going_to="St Ives">
>>     <wife>
>>         <sack>
>>             <cat>
>>                 <kit/>
>>                 <kit/>
>>             </cat>
>>             <cat>
>>                 <kit/>
>>                 <kit/>
>>             </cat>
>>         </sack>
>>         <sack>
>>             <cat>
>>                 <kit/>
>>                 <kit/>
>>             </cat>
>>             <cat>
>>                 <kit/>
>>                 <kit/>
>>             </cat>
>>         </sack>
>>     </wife>
>> </me>
>> ```
> {: .solution}
{: .challenge}

> ## XML vs JSON vs YAML
> XML is very powerful and extremely widely used as a data interchange format. You can set up XML schemas to validate XML documents. There are even XML database engines. However, it uses a lot of boilerplate (closing tags, for example) and is an eyesore. JSON is much easier on the eyes and YAML is best for humans. Since YAML is not that widely used, JSON seems a good compromise. 
{: .discussion}

## Query structured documents (optional)

XPath and jq.

### jq
JSON files have a well-defined structure, but we need a language and a tool to query them. We can do this in Python or any other programming language.
```
import json
seller = json.load(open('seller.json', 'rt'))
seller[0]
seller[0]['WIN_NAME']
```
{: .language-python}

```
{'ID_AWARD': 8447168, 'ID_LOT_AWARDED': '', 'WIN_COUNTRY_CODE': 'DE', 'WIN_NAME': 'Dialogika GmbH'}
'Dialogika GmbH'
```
{: .output}

The command line tool `jq` can also extract information from JSON files. (Not to be confused with jquery, which is a frontend JavaScript framework.) It has its separate query language, which we will practice in the [jq playground](https://jqplay.org/).

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

`jq '.[0]'` will return
```
{
  "name": "apple",
  "type": "fruit",
  "quantity": 2,
  "unit": "kg"
}
```
{: .output}

`jq '.[0].name'` will return
```
"apple"
```
{: .output}

We can loop over a list and return a property for each element, like `.[].name`.
```
"apple"
"carrot"
```
{: .output}

We can also use `jq` to create new JSON objects by nesting our query in `[]` and `{}`, like `[{fruit: .[].name}]`
```
[
  {
    "fruit": "apple"
  },
  {
    "fruit": "carrot"
  }
]
```
{: .output}

> ## Exercise
> Write a `jq` query to list the units of fruits and vegetables in our basket. It should return a proper JSON list.
>> ## Solution
>> `[.[].unit]`
> {: .solution}
{: .challenge}

We can combine queries with the pipe operator `|`. This is useful for filtering, for example.
Both `.[] | select(.type == "fruit")` and `.[] | select(.name | contains("pp"))`
result in 
```
{
  "name": "apple",
  "type": "fruit",
  "quantity": 2,
  "unit": "kg"
}
```
{: .output}

To invoke `jq` in bash, write the query in single (not double) quotes.
```
bash-5.0$ jq '.[0]' seller.json 
{
  "ID_AWARD": 8447168,
  "ID_LOT_AWARDED": "",
  "WIN_COUNTRY_CODE": "DE",
  "WIN_NAME": "Dialogika GmbH"
}
```
{: .language-bash}

> ## Exercise
> Display the country codes of each seller in `seller.json` in bash. 
>> ## Solution
>> `jq '.[].WIN_COUNTRY_CODE' seller.json`
> {: .solution}
{: .challenge}

There are some built-in function, such as `length`, `map` and `group_by`. To count the objects in a JSON file,
```
jq 'length' seller.json 
```
{: .language-bash}

```
jq 'group_by(.WIN_COUNTRY_CODE) | map({country: .[0].WIN_COUNTRY_CODE, number: length})' seller.json 
```
{: .language-bash}

We can convert JSON files to CSV, for example.
```
jq 'group_by(.WIN_COUNTRY_CODE) | map({country: .[0].WIN_COUNTRY_CODE, number: length}) | .[]@csv' seller.json 
```
{: .language-bash}

> ## Exercise 
> Convert the JSON lines file in _Offene Register_ to proper JSON using `jq`.
> > ## Solution
> > ```
> > cat offeneregister-1000.jsonl | jq -cs '.' > offeneregister-1000.json
> > ```
> > {: .language-bash}
> {: .solution}
{: .challenge}

```
~/D/t/c/2/d/d/okf ❯ head -n5 offeneregister-1000.jsonl | jq ".officers[] | {name: .name, city: .other_attributes.city, position: .position}"
{
  "name": "Oliver Keunecke",
  "city": "Hamburg",
  "position": "Geschäftsführer"
}
...
{
  "name": "Wolfgang Adamiok",
  "city": "Mommenheim",
  "position": "Geschäftsführer"
}
```
{: .language-bash}

> ## Exercise
> Using `jq`, create a list of JSON objects ("JSON lines"), with each record corresponding to a person-entry in the _Offene Register_, with the following fields: name, city, firm identifier.
> > ## Solution
> > ```
> > jq '. as $parent | .officers[] | {name: .name, firm: $parent.company_number, city: .other_attributes.city, position: .position}' offeneregister-1000.jsonl
> > ```
> > {: .language-bash}
> {: .solution}
{: .challenge}

```
jq -r '(map(keys) | add | unique) as $cols | map(. as $row | $cols | map($row[.])) as $rows | $cols, $rows[] | @csv' officer.json > officer.csv
```
{: .language-bash}

