---
title: NoSQL.
teaching: 180
questions:
- What is polyglot persistence and how solves the data storge problems of the present days?
- What are the common treats of NoSQL solutions?
- How can a data analyst choose the appropriate data solution tailored to her/his task?


objectives:
- Understanding the polyglot persistence
- Understanding eventual consistency
- Understanding SQL VS NoSQL
- Understanding NoSQL families 
- Introducing Key-Value Stores
- Introducing Apache Zeppelin
- Practice with Redis
- Introducing Time Series DBMS 
- Introducing Document Stores
- Practice of MongoDB with Airbnb data
- Introducing Column Stores
- Introducing Search Engines
- Practice of Solr with Kaggle Flight data
- Introducing Graph DBMS
- Practice of Neo4J with Paradise Papers

keypoints:
- \#BASE
- \#NOSQL FAMILIES
- \#APACHE ZEPPELIN
- \#REDIS
- \#MONGO
- \#SOLR
- \#NETWORK SCIENCE
- \#NEO4J
- \#PARADISE PAPERS



---

> ## Table of Content
> [Lecture PPTX]({{ page.root }}/artifacts/nosql/nosql.pptx)
>
> [Redis](#redis)
>
> [MongoDB](#mongo)
>
> [Solr](#solr)
>
> [Neo4j](#neo4j)
{: .discussion}
  

<br/><br/>
<a name="redis"/>
## Redis



#### Links to help you
[https://redis-py.readthedocs.io/en/stable/index.html](https://redis-py.readthedocs.io/en/stable/index.html)

[https://redis.io/commands#](https://redis.io/commands#)

<br>

#### Exercise interface: [http://de1.ceudsd.com](http://de1.ceudsd.com) (Jupyter Notebook)
#### [Exercise notebook]({{ page.root }}/artifacts/nosql/redis_class.ipynb) 

Username/Password will be distributed during class. Ask on Teams if you haven't got one. 

<br/><br/>

#### Connect to Redis with Python 
```
import redis
r = redis.Redis(host='localhost', port=8082)
```
{: .language-python}

#### Set a value with a key
```
r.set('laszlo_sallo', 'bar')
```
{: .language-python}

#### Get value by key
```
r.get('laszlo_sallo')
```
{: .language-python}

#### Overwrite with expiration
```
r.set('laszlo_sallo','efwefwefgwerg',ex=5)
```
{: .language-python}

#### Is it there?
```
r.get('laszlo_sallo')
```
{: .language-python}

#### Set a number
```
r.set('laszlo_sallo_nr', 10)
r.get('laszlo_sallo_nr')
```
{: .language-python}

#### Increase number value
```
r.incr("laszlo_sallo_nr")
r.get('laszlo_sallo_nr')
```
{: .language-python}

#### Store multiple key-value
```
r.mset({'laszlo_sallo_one': 1, 'laszlo_sallo_two': 2, 'laszlo_sallo_three': 3})
```
{: .language-python}

#### Display all keys stored in DB
```
r.keys()
```
{: .language-python}

#### Retrieve multiple values by key
```
r.mget('laszlo_sallo_one','laszlo_sallo_three')
```
{: .language-python}

> ## REDIS Exercise 
> USING THE DOCUMENTATION, FIND HOW TO DELETE A VALUE BY KEY AND HOW TO CHECK THE EXISTENCE OF A KEY.
{: .challenge}



<br/><br/><br/>
<a name="mongo"/>
## MongoDB



#### Links to help you

[https://docs.mongodb.com/manual/](https://docs.mongodb.com/manual/)

[https://www.w3schools.com/python/python_mongodb_getstarted.asp](https://www.w3schools.com/python/python_mongodb_getstarted.asp)

[AirBnb dataset](https://docs.atlas.mongodb.com/sample-data/sample-airbnb/)

<br/>

#### [Exercise notebook]({{ page.root }}/artifacts/nosql/mongo_class.ipynb) 

<br/>

#### Connect to MongoDB with Python 

```
import pymongo
import pprint
mongo = pymongo.MongoClient("mongodb://localhost:27017")
```
{: .language-python}

<br/>
#### Select a database

If database does not exist, will be created with the first data write (eg. insert line)

```
db = mongo["mydatabase"]
```
{: .language-python}

<br/>
#### Create a collection

```
customers = db["laszlo_sallo"]
```
{: .language-python}



<br/>
#### Insert a document
```
id = customers.insert_one({ "name": "John", "address": "Boston Highway 37" }).inserted_id
```
{: .language-python}

<br/>
#### Find 

Find the customer inserted by id. Pretty print the result.
```
pprint.pprint(customers.find_one({"_id": id}))
```
{: .language-python}

Find multiple customers by "name" field. Inverse sort by "address". Limit to 5. In order to print the result we iterating over the result set and pretty print each resulting JSON.


```
for customer in customers.find({"name": "John"}).sort("address",-1).limit(5):
    pprint.pprint(customer)
```
{: .language-python}

<br/>
#### Count 

```
customers.count_documents({"name": "John"})
```
{: .language-python}

<br/>


#### Distinct

Insert a row with another John into the new collection and then 
find the customers called "John" which address starts with "Bos" and print out distinct addresses.

```
id = customers.insert_one({ "name": "John", "address": "Boole 01" }).inserted_id

for customer in customers.find({"name":"John","address": {"$regex": "^Boston"}}).distinct("address"):
    pprint.pprint(customer)
```
{: .language-python}

<br/>
#### List collections stored in the database
```
db.list_collection_names()
```
{: .language-python}

<br/>
#### Airbnb Sample database
```
airbnb = db["airbnb"]
pprint.pprint(airbnb.find_one())
```
{: .language-python}

<br/>
#### Advance filtering

Filter by a deeper JSON field. Print only part of JSON.

```
for listing in airbnb.find({ "address.country": "Spain" }).limit(10):
    pprint.pprint(listing['address']['government_area'])
```
{: .language-python}

> ## MONGO Exercise 
> COUNT HOW MANY AIRBNB LISTINGS WE HAVE IN THE SAMPLE DATABASE HAVING "COUNTRY_CODE" "US" OR "ADDRESS.MARKET" STARTWITH "M" (USE MONGODB DOCUMENTATION)
>> ## Solution
>> Just a hint, the solution in SQL is something like:
>> ~~~
>> SELECT COUNT(*) FROM airbnb WHERE country_code='US' OR market LIKE 'M%'
>> ~~~
>> {: .language-sql} 
> {: .solution} 
{: .challenge}




<br/><br/><br/>
<a name="solr"/>
## Solr

#### Links to help you
[https://cwiki.apache.org/confluence/display/solr/The+Standard+Query+Parser](https://cwiki.apache.org/confluence/display/solr/The+Standard+Query+Parser)

[http://yonik.com/solr/query-syntax/](http://yonik.com/solr/query-syntax/)

<br/>

#### Exercise interface: [http://solr.ceudsd.com/solr/#/flightdelays/query](http://solr.ceudsd.com/solr/#/flightdelays/query)
#### [Exercise notebook]({{ page.root }}/artifacts/nosql/solr_class.ipynb) 


<br/><br/>

#### A simple query

SOLR has different connectors to programming languages. For simple query testing, we don’t need to program because SOLR is offering so called HTTP Rest interface. These are basically url calls from a browser.

The simplest query (the result is limited by default to 10):
```
http://solr.ceudsd.com/solr/flightdelays/select?q=*:*
```
{: .output}

<br/>
In SQL, this would be something like:
```
SELECT * FROM flightdelays LIMIT 10;
```
{: .language-sql}


<br/>
#### Ranges 

List records from the last 10 years where tail number is N520JB:


```
http://solr.ceudsd.com/solr/flightdelays/select?fl=DISTANCE,ORIG_CITY,DEST_CITY&q=TAIL_NUMBER:N838UA AND DATE:[NOW-10YEARS TO *]&sort=DISTANCE desc&rows=5
```
{: .output}

<br/>
In SQL, this would be something like:
```
SELECT distance,orig_city,dest_city FROM flightdelays 
  WHERE tail_number='N520JB' AND date >= DATE_SUB(NOW(),INTERVAL 10 YEAR) 
  ORDER BY distance DESC 
  LIMIT 5;
```
{: .language-sql}

<br/><br/>
#### String search / Fuzzy search
List records where tail numbers starting with any character, followed by “2”, followed by 2 any character, followed by "jb". Display only tail number in the result set:
```
http://solr.ceudsd.com/solr/flightdelays/select?fl=TAIL_NUMBER&q=TAIL_NUMBER:?8???a
```
{: .output}

Fuzzy searches is based on the Damerau-Levenshtein Distance or Edit Distance algorithm. Fuzzy searches discover terms that are similar to a specified term without necessarily being an exact match. To perform a fuzzy search, use the tilde ~ symbol at the end of a single-word term

In the next example we list records with destination city close to "columbas" by distance of 2. The distance referred to here is the number of term movements needed to match the specified phrase.
```
http://solr.ceudsd.com/solr/flightdelays/select?fl=DEST_CITY&q=DEST_CITY:kolumbas~2
```
{: .output}

<br/>
#### Facets

Same as before, but this time return back distinct destination cities as well:
```
http://solr.ceudsd.com/solr/flightdelays/select?q=DEST_CITY:Boise~3&facet.field=DEST_CITY_str&facet=on&rows=0
```
{: .output}

<br/>
This previous result sounds like a combined result of the following SQLs:
```
SELECT * FROM flightdelays WHERE DEST_CITY LIKE 'columbas%' LIMIT 10;

SELECT dest_city, COUNT(*) FROM flightdelays 
  WHERE DEST_CITY LIKE 'columbas%' 
  GROUP BY dest_city;
```
{: .language-sql}


<br/>
#### Geo spacial search

Return back records within a circle defined by center point of 39.85,-104.66 [lat,lon] and diameter of 2 kilometer. Display only ORIG_CITY and ORIG_LOCATION_p in the result set and facests for ORIG_CITY_str.

```
http://solr.ceudsd.com/solr/flightdelays/select?d=2&facet.field=ORIG_CITY_str&facet=on&fl=ORIG_CITY,ORIG_LOCATION_p,&fq={!geofilt}&pt=39.85,-104.66&q=*:*&sfield=ORIG_LOCATION_p
```
{: .output}

> ## SOLR Exercise 
> HOW MANY FLIGHTS ARRIVED IN SAN FRANCISCO WITH NO DELAY ALTHOUGH THEY DEPARTED AT LEAST 50 MINS BEHIND THE SCHEDULE?
{: .challenge}

<br/><br/>

#### Connect to SOLR with Python 

```
import pysolr
from requests.auth import HTTPBasicAuth
import pprint

solr = pysolr.Solr('http://localhost:8081/solr/flightdelays',auth=HTTPBasicAuth('xxx','xxx'))
```
{: .language-python}

<br/>
#### Query the first 10 records

```
results = solr.search('*:*')
for result in results:
    pprint.pprint(result)
```
{: .language-python}

<br/>
#### A more complicated query

List records from the last 10 years where tail number is N520JB:

```
results = solr.search('TAIL_NUMBER:N838UA AND DATE:[NOW-10YEARS TO *]',fl="DISTANCE,ORIG_CITY,DEST_CITY",sort="DISTANCE desc",rows=10)
for result in results:
    pprint.pp(result,width=50)
```
{: .language-python}



<br/><br/><br/>
<a name="neo4j"/>
## Neo4j

#### Links to help you

(https://neo4j.com/developer/cypher-query-language/)

(http://neo4j.com/docs/developer-manual/current/cypher/)

(https://cloudfront-files-1.publicintegrity.org/offshoreleaks/neo4j/guide/index.html)

 <br/>
#### Exercise interface: [https://sandbox.neo4j.com/](https://sandbox.neo4j.com/)

Register and start a sandbox with "Paradise Papers by ICIJ"

<br/><br/>

#### Simple queries

In Neo4J the SELECT is called MATCH. One of the simplest query is selecting 25 Officer nodes :

```
MATCH (n:Entity) 
RETURN n.name LIMIT 25

```
{: .language-cypher}

<br/>
In SQL, this would be something like:
```
SELECT n.name FROM Entity AS n LIMIT 25;
```
{: .language-sql}


We can use WHERE clause to filter our result:
```
MATCH (o:Officer)
WHERE o.countries CONTAINS 'Hungary'
RETURN o
```
{: .language-cypher}

<br/>
In SQL, this would be something like:
```
SELECT o.countries FROM officer AS o WHERE o.countries LIKE '%Hungary%';
```
{: .language-sql}




> ## NEO4J Exercise 1 
> RETURN THE FIRST 10 ADDRESS NODES
{: .challenge}

> ## NEO4J Exercise 2
> HOW MANY PROPERTIES AN ADDRESS NODE HAS? 
{: .challenge}

> ## NEO4J Exercise 3 
> RETURN THE FIRST 10 COUNTRIES OF THE ADDRESS NODE. WHAT IS THE LAST COUNTRY IN THE LIST?
{: .challenge}

> ## NEO4J Exercise4 
> HOW MANY ADDRESS NODES HAS 'Mexico' AND 'Monaco' IN THEIR ADDRESS PROPERTY?
{: .challenge}

<br/>
####  Joins

Find the Officers and the Entities linked to them (double MATCH)

```
MATCH (o:Officer) 
MATCH p=(o)-[r]-(c:Entity)
RETURN p
LIMIT 50
```
{: .language-cypher}

<br/>
In SQL, this would be something like:
```
SELECT * 
FROM officer as o  
INNER JOIN Entity as c 
USING (relationship)
```
{: .language-sql}


Find the nodes associated "the duchy of lancaster":
```
MATCH (o:Officer) 
WHERE toLower(o.name) CONTAINS "the duchy of lancaster"
MATCH p=(o)-[r]-(c)
RETURN p

```
{: .language-cypher}



Same, but this time return the nodes 2 hops away:
```
MATCH (o:Officer) 
WHERE toLower(o.name) CONTAINS "the duchy of lancaster"
MATCH p=(o)-[*..2]-(c)
RETURN p
```
{: .language-cypher}



<br/>

####  Count

Which country has the most addresses 
```
MATCH (n:Address) 
RETURN n.countries, count(*)
ORDER BY count(*) DESC
LIMIT 10
```
{: .language-cypher}

> ## NEO4J Exercise 5 
> LIST THE NAME AND NUMBER CONNECTIONS OF THE TOP 10 MOST CONNECTED OFFICERS FROM BULGARIA.WHO IS THE NO1?
{: .challenge}



