---
title: Different Shapes of Data. APIs.
teaching: 90
questions:
-
objectives:
- 
keypoints:
- \#CSV
- \#XML
- \#JSON
- \#API
- \#POSTMAN

---


## Prerequisite: Installing Postman 

Install Postman from here: [https://www.postman.com/downloads/](https://www.postman.com/downloads/)


## Anatomy of a URL 

![How URLs work by Julia Evans](https://pbs.twimg.com/media/ECA-PX3XsAAdaOs?format=jpg&name=large)


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




## Using Eurostat API

Eurostat is offering a wide range of databases: [https://ec.europa.eu/eurostat/web/main/data/database](https://ec.europa.eu/eurostat/web/main/data/database)


* Navigate to: Data navigation tree > Database by themes > General and regional statistics	> City statistics (urb) > Cities and greater cities (urb_cgc) > Population on 1 January by age groups and sex - cities and greater cities (urb_cpop1)

* Click on Data Explorer (second icon) and you'll get this: [https://appsso.eurostat.ec.europa.eu/nui/show.do?dataset=urb_cpop1&lang=en](https://appsso.eurostat.ec.europa.eu/nui/show.do?dataset=urb_cpop1&lang=en)

* Check the dimensions of this dataset, play arond with slicing and dicing

* Browse to [https://ec.europa.eu/eurostat/web/json-and-unicode-web-services/getting-started/rest-request](https://ec.europa.eu/eurostat/web/json-and-unicode-web-services/getting-started/rest-request) and read it carefully.

* Now lets build our first query with this: [https://ec.europa.eu/eurostat/web/json-and-unicode-web-services/getting-started/query-builder](https://ec.europa.eu/eurostat/web/json-and-unicode-web-services/getting-started/query-builder)

* Insert the db name: "urb_cpop1" and click next

* Now you can specify some dimension values like: Geo selection > Fixed > Bruxelles and indic_ur > DE1003V - Population on the 1st of January, female

* Click "Generate query filter" and you'll get this URL: [http://ec.europa.eu/eurostat/wdds/rest/data/v2.1/json/en/urb_cpop1?indic_ur=DE1003V&cities=BE001C1&precision=1](http://ec.europa.eu/eurostat/wdds/rest/data/v2.1/json/en/urb_cpop1?indic_ur=DE1003V&cities=BE001C1&precision=1)

* Try this URL in a browser. What do you see?

* The more convenienet way to work with REST APIs is Postman. Lets paste the previous URL in postman.



#Exercise:

Worldbank






