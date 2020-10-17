---
title: "Data Profiling for Better Quality"
teaching: 85
exercises: 75
questions:
- How do I explore my data for common data entry errors?
- How do I extract numeric information from malformatted data?
- How do I normalize mistyped text data?
objectives:
- Use string functions in OpenRefine to normalize text data.
- Explore data in OpenRefine with facets and filters.
- Use OpenRefine to split and reshape data.
- Use simple regular expressions to exract numerical information from textual data.
- Save, edit and replay changes in OpenRefine on different datasets.
- Reshape data long from variable name patterns.
- Compare different methods of Entity Resolution.
- Normalize strings referring to people and corporations using regular expressions.
- Apply Levenshtein and other fuzzy distance metrics.
keypoints:
- OpenRefine gives an interactive overview of your data as it is.
- Experiment with various text replace functions, clustering and regular expressions.
- Save all your steps in a .json file.
- If your data is large, conduct cleaning on a random sample.
- There is always a tradeoff between false positives and false negatives in entity resolution.
- Normalize records before comparing them to minimize the necessary number of comparisons.
---

## Reading
1. [Falsehoods about names](https://www.kalzumeus.com/2010/06/17/falsehoods-programmers-believe-about-names/)
2. [Beider-Morse phonetic matching](https://stevemorse.org/phonetics/bmpm2.htm)

## Review and transform textual data (25 mins)

1. [Thomas Padilla's tutorial](http://thomaspadilla.org/dataprep/). 
2. Create project.
3. Text faceting, multiple editing.
4. Go through various clustering options, including Levenshtein distance. These still don't match "Titan" to "Titan Books". 
5. Illustrate GREL transformations `value.replace('.', '')` and `value.replaceChars('.', '')`. 
6. Also, simple regex to extract publication dates, `value.find(/\d{4}/)[0]`. Convert `toNumber()`. Check with Numeric facet.
7. Export project.
8. Undo/redo. Export .json script.

> ## Exercise (10 mins)
> Cluster and edit the Author-Persons column. How many distinct authors are there?
>> ## Solution
>> Edit cells / Transform / Cluster and edit. Select "fingerprint" first, then "ngram-fingerprint", then "Beider-Morse". Only then switch to Nearest neighbor and select "levenshtein" with radius of 1.0. With these steps, you can reduce the number of distinct authors from about 5,400 to about 4,000.
> {: .solution}
{: .challenge}

[The Carpentries](https://librarycarpentry.org/lc-open-refine/)



## Reshape data

Read `gdp-wide.csv` and reshape it in long format using OpenRefine. Select rows matching "World" and save as .csv.

![]({{ "/fig/gdp-wide.png" | relative_url }})

> ## Gotcha
> When using "Edit cells / Fill down" to fill in missing values for multiple columns, remember to turn on viewing Records, not Rows.
{: .callout}


![]({{ "/fig/gdp-long.png" | relative_url }})

![]({{ "/fig/gdp-long-number.png" | relative_url }})

> ## Challenge
> Read `WDI-3indicators.csv`. Create a tidy .csv file of merchandise trade data.
{: .challenge}

### TED
Open `TED.sqlite` in DB browser. Select a random sample of rows from the `messy` table.
```
create view random_sample as 
    select ID_AWARD, ID_LOT_AWARDED, CAE_NAME, CAE_NATIONALID, CAE_ADDRESS, CAE_TOWN, CAE_POSTAL_CODE, ISO_COUNTRY_CODE, ISO_COUNTRY_CODE_ALL, WIN_NAME, WIN_NATIONALID, WIN_ADDRESS, WIN_TOWN, WIN_POSTAL_CODE, WIN_COUNTRY_CODE
    from messy 
    order by random() 
    limit 5000;
```
{: .language-sql}
Save as CSV.

Open in OpenRefine. Split the name of winners into separate rows.

> ## Exercise
> Split the address of winners into separate rows. Do it for all address components.
{: .challenge}

### Undo and redo in OpenRefine

Select relevant columns: `ID_AWARD`, `WIN_*`. Save as `award-winner.csv`.
Save steps in JSON file. Illustrate going back in time.
Replay same JSON on larger file.

Now replace numbers in `WIN_TOWN`.

> ## Exercise 
> Save the JSON file of all the steps we have done, including removing the numbers from `WIN_TOWN`. Replay these changes on the larger sample.
{: .challenge}

> ## Challenge
> Edit the original JSON file to make the same edits for Contracting Agencies (`CAE_*`). Split into rows, fill down, remove numbers from city. Create an `award-cae.csv`.
{: .challenge}

# Entity Resolution
Read a [short introduction](https://dev.to/korenmiklos/wish-i-could-be-like-david-watts-2edp) to the problem of entity resolution.

## Appreciate uncertainty
The first guiding principle of entity resolution is to embrace the imperfections. There is no perfect method, you are just balancing two types of error. _False positives_ occur when you link two observations that, in reality, refer to two different entities. _False negatives_ occur when you fail to link two observations that, in reality, represent the same entity. You can always decrease one type of error at the expense of the other by selecting a more or less stringent matching method.

The accuracy of your method can be characterized by its _precision_ and _recall rates_.

![](https://upload.wikimedia.org/wikipedia/commons/thumb/2/26/Precisionrecall.svg/700px-Precisionrecall.svg.png)

Typically the business costs of false positives are larger (you don't want to send a customer's account statement to someone else). But the costs of false negatives can be substantial too (users signing up twice for your freemium service).

|------|-----------|
| Name | Person ID |
|------|-----------|
| Viktor | 1 |
| Victor | 1 |
| Victoria | 2|
| Yevgeniy | 3 |
| Evgeni | 3 |

> ## Exercise
> Compute the pairwise [Levenshtein distances](https://planetcalc.com/1721/) between _lowercase_ names. This counts the number of character edits you have to make for string A to exactly match string B. For example, "Vi**k**tor" is at 1 distance from "Vi**c**tor".
>> ## Solution
>> ![]({{ "/fig/levenshtein.png" | relative_url }})
> {: .solution}
{: .challenge}

> ## Exercise
> Suppose your ER algorithm accepts names as referring to the same entity if they are within Levenshtein distance _d_. What are the false positive and false negative counts for different values of _d_? What are the precision and recall rates?
>> ## Solution
>> ![]({{ "/fig/precision-recall.png" | relative_url }})
> {: .solution}
{: .challenge}

You may have seen these type of errors in binary classification problems. Indeed, ER can be aided by supervised machine learning. Suppose we have a set of features _X_ in each record that are potentially informative about their entity. I need to decide, for each _X1_ and _X2_, whether they refer to the same entity, that is, whether _f(X1, X2)=1_. Given a training sample on _y = f(X1, X2)_, this is a standard machine learning problem.

### How do I get a training sample? 
1. I can hand label a training sample. This should not be a random sample, because matches/duplicates are rare. Because for a sample size _k_ I have to make O(k^2) comparisons, this is very costly.
2. For a subset of observation, I may have unique identifiers. For example, I have collected noy only names, but also student IDs in one year. 

```
SELECT WIN_NAME, WIN_NATIONALID, WIN_ADDRESS, WIN_POSTAL_CODE, WIN_TOWN, WIN_COUNTRY_CODE 
    FROM messy 
    WHERE NOT WIN_NATIONALID = "";
```
{: .language-sql}


## Appreciate complexity
The second guiding principle is to appreciate the computational complexity. If you are unsure about your data, you have to compare every observation with every other, making `N(N-1)/2` comparisons in a dataset with `N` observations. (See box on why it is sufficient to make _pairwise_ comparisons.) In a large dataset this becomes prohibitively many comparisons. For example, if you want to deduplicate users from a dataset with 100,000 observations (a small dataset), you have to make 10 _billion_ comparisons. Throughout the ER process, you should be looking for ways to reduce the number of necessary comparisons.

Comparing each pair of _N_ records is of complexity O(N^2). Avoid doing this.

How do we reduce complexity? Creating an index can help but it will take up a large space. For example, we can index all [n-grams](https://en.wikipedia.org/wiki/N-gram) appearing in the text.

|------|-----------|
| Name | 2-grams |
|------|-----------|
| Viktor | vi,ik,kt,to,or |
| Victor | vi,ic,ct,to,or |
| Victoria | vi,ic,ct,to,or,ri,ia |
| Yevgeniy | ye,ev,vg,ge,en,ni,iy |
| Evgeni | ev,vg,ge,en,ni |

Then we can look at only pairs that have at least one n-gram in common. This would search in a hash index so would not need any comparison. We would only search within groups sharing n-grams.

In the example above, "Viktor" would never be compared to "Yevgeny", only to "Victor" and "Victoria".

Alternatively, we can create an index based on the first letter (these are rarely mistyped). But then we would miss "Evgeni" = "Yevgeniy".

> ## Exercise
> Suppose you have a dataset of `n` records that you want to disambiguate. It takes 1ms to compare any pair of records and decide whether they belong to the same entity. You can also classify each record into one of 10 equal-sized groups, but this is slow: it takes 1s per record. There are no matches outside groups, so if you create groups, you only need to compare records within groups.
> 
> Draw a diagram of the time needed for disambiguation as a function of `n`, with and without grouping. For what values of `n` do you want to create groups? Explain. 
{: .challenge}

## Three types of ER
1. Deduplicate a list
2. Merge two lists
3. Check against a whitelist


## Four steps to ER
1. Normalize
2. Bin
3. Match
4. Merge

First you __normalize__ your data by eliminating typos, alternative spellings, to bring the data to a more structured, more comparable format. For example, a name "Dr David George Watts III" may be normalized to "watts, david." Normalization can give you a lot of efficiency because your comparisons in the next step will be much easier. However, this is also where you can loose the most information if you are over-normalizing. 

Normalization (a.k.a. standardization) is a function that maps your observation to a simpler (often text) representation. During a normalization, you only use one observation and do not compare it to any other observation. That comes later. You can compare to (short) _white lists_, though. For example, if your observations represent cities, it is useful to compare the `city_name` field to a list of known cities and correct typos. You can also convert text fields to lower case, drop punctuation and _stop words_, round or bin numerical values.

If there is a canonical way to represent the information in your observations, use that. For example, the US Postal Services standardizes US addresses (see figure) and [provides an API](https://www.usps.com/business/web-tools-apis/address-information-api.htm) to do that. 

![](https://thepracticaldev.s3.amazonaws.com/i/dy4d171gkjmql3lltxr4.png)

To minimize the number of comparisons, you typically only evaluate _potential matches_. This is where normalization can be helpful, as you only need to compare observations with normalized names of "watts, david," or those within the same city, for example. Decide on the __bins__ you are comparing within.

Then you __match__ pairs of observations which are close enough according to your metric. The metric can allow for typos, such as a _Levenshtein distance_. It can rely on multiple fields such as name, address, phone number, date of birth. You can assign weights to each of these fields: matching on phone number may carry a large weight than matching on name. You can also opt for a _decision tree_: only check the date of birth and phone number for very common names, for example.

Once you matched related observations, you have to __merge__ the information they provide about the entity they represent. For example, if you are matching "Dr David Watts" and "David Watts," you have to decide whether the person is indeed a "Dr" and whether you are keeping that information. The merge step involves aggregating information from the individual observations with whatever aggregation function you feel appropriate. You can fill in missing fields (if, say, you find the phone number for David Watts in one observation, use it throughout), use the most complete text representation (such as "Dr David George Watts III"), or simply keep all the variants of a field (by creating a _set_ of name variants, for example, {"David Watts", "Dr David Watts", "Dr David George Watts III"}). 

> ## Exercise
> What is the computational complexity of each of these steps?
>> ## Solution
>> Normalization is O(n). Binning is typically O(n), although building more complex data structures may take more time. Matching is O(nk), where _k_ is the typical size of a bin. Merging is O(m), where _m_ is the number of actual matches.
> {: .solution}
{: .challenge}
