---
title: "Command Line Exercises"
teaching: 10
exercises: 60
questions:
- What tool a data analyst can use to explore the content of a large data file? (e.g. a large CSV with hundreds of thousands of lines)
- What tool a data analyst can use to modify the content of a large data file?

objectives:
- Basic understanding of Linux bash
- Practice of viewing/editing/modifying a large csv file
- Quick intro to Linux scripts

keypoints:
- As analyst, Linux bash can be a handy tool to work with large data files 
- Some version of Linux bash can be used on any popular OS (Windows/Mac/Linux)

---

## Setup

For this exercise we will use Git. 

Instructions for Windows: 
* Install Git for Windows: <https://gitforwindows.org/> 
* This installs Git bash too. More info on Git bash: <https://www.atlassian.com/git/tutorials/git-bash>
* Please run and check (and double check) that Git Bash works properly. Type `pwd` and see if you get a response.

Instructions for Mac:
* You should have Git installed by default
* Open a Terminal appilcation and type: `git --version` - if you get back something like `git version 2.24.3 (Apple Git-128)` you should be ok. 
* If you don't have git or you have an older version, type `brew install git`


## Preparing the exercise artifacts

First, let's check some file navigation. Your current location:
```
pwd
```
{: .language-bash}

List files in your current folder in two different formats:
```
ls
ls -l
```
{: .language-bash}

To get the required artifacts (flat files for exercises) navigate to a folder suitable for exercises (like Documents, CEU class folder etc) and clone the course repo:

Example:
```
cd Documents/
mkdir bash
git clone https://github.com/CEU-Economics-and-Business/ECBS-5146-Different-Shapes-of-Data
cd ECBS-5146-Different-Shapes-of-Data/artifacts/bash/
```
{: .language-bash}



## Basic commands

`cat` -
Print the file to the screen.
```
cat birdstrikes.csv
```
{: .language-bash}


`head` -
Print the first 3 lines to the file to the screen
```
head -n 3 birdstrikes.csv
```
{: .language-bash}

What is `-n`? Check it in the manual
```
head --help
```
{: .language-bash}
`tail` -
Check the last 5 lines of the file
```
tail -n 5 birdstrikes.csv
```
{: .language-bash}


`>` - Save the first 10 lines into another file (note that instead of -n 10, we used a simplified version)
```
head -10 birdstrikes.csv > first10.csv
```
{: .language-bash}
list the result
```
cat first10.csv
```
{: .language-bash}

`|` - concatenating command. Show the 10th line only: 
```
head -n 10 birdstrikes.csv | tail -n 1
```
{: .language-bash}

> ## Exercise 1
> Copy the 6th and 7th line of birdstrikes into the myprettypony.csv
{: .challenge}

## Filtering

`grep` -
Only show incidents from California
```
cat birdstrikes.csv | grep California 
```
{: .language-bash}
`grep -v` -
Only show incidents NOT with Airplanes
```
cat birdstrikes.csv | grep -v California
```
{: .language-bash}
`grep -i` -
Ignore case
```
cat birdstrikes.csv | grep -i CALIFORNIA
```
{: .language-bash}

## Word count

`wc` - show the line, word and character count of birdstrikes
```
wc birdstrikes.csv
```
{: .language-bash}
```wc -l```
shows only the line count

> ## Exercise 2
> How many words we have in the first 10 lines of birdstrikes?
{: .challenge}

> ## Exercise 3
> How many incidents were in California (only output line count)
{: .challenge}

## Cut / printing out parts of a line

What is name of the 1st column:
```
cat birdstrikes.csv | cut -d ';' -f1 | head -1
```
{: .language-bash}


* `cut` - Display the first 10 records of *damage* (column 4) and the *cost* (column 10) columns

```
cat birdstrikes.csv | cut -d ';' -f4,10 | head -11
```
{: .language-bash}

Similar to previous example, but now writing all columns, except *damage* (column 4) and *cost* (column 10) into a new file:
```
cat birdstrikes.csv | cut -d ';' --complement -f4,10 > new.csv
cat birdstrikes.csv | cut -d ';' -f1-3,5-9,11- > new.csv

head -5 new.csv

```
{: .language-bash}




> ## Exercise 4
> Write 17th record of *state* and the *bird size* columns from birdstrikes, in file called *onerepublic.csv*. What is the result if run 'cat onerepublic.csv'?
{: .challenge}

## Sorting

```
sort birdstrikes.csv
```
{: .language-bash}

Reverse sort by *damage* (column 4)
```
cat birdstrikes.csv | sort -k4 -t ';' -r | head -10
```
{: .language-bash}

> ## Exercise 5
> What was the cost of the most expensive incident?
{: .challenge}

## Distinct/Unique values

`sort | uniq` - 
Distinct states in birdstrikes:
```
cat birdstrikes.csv | cut -d ';' -f6 | sort | uniq | wc -l
```
{: .language-bash}

`uniq -c` -
How many incidents were there by state?
```
tail -n+2 birdstrikes.csv | cut -d ';' -f6 | sort | uniq -c
```
{: .language-bash}

## Scripts
> ## Sentiment analysis 
> In the next example, we would like to present a small script for sentiment analysis of books. You will see, that using the commands above and adding a bit of procedural logic by bash scripting, we can easily create a basic sentiment analyzer.
> <br/>
>
>
> This script is focusing on counting certain negative words and calculating the ratio against the number of words in a book. The script could be improved (as the image below suggests) to look for context, distribution in time and ultimately check the positive words as well, for a bit more balanced analytics. 
>
>
> ![](https://peerchristensen.netlify.app/post/2018-06-07-fair-is-foul-and-foul-is-fair-a-tidytext-entiment-analysis-of-shakespeare-s-tragedies_files/figure-html/unnamed-chunk-11-1.png)
> Source of image: [Fair is foul, and foul is fair: a tidytext sentiment analysis of Shakespeare’s tragedies](https://peerchristensen.netlify.app/post/fair-is-foul-and-foul-is-fair-a-tidytext-entiment-analysis-of-shakespeare-s-tragedies/)
{: .callout}

<br/><br/>

First, we create the file for the script:
```
nano sentiment.sh
```
{: .language-bash}

Then, here is the script itself:
```
dictionary=(sad sorrow death dead pain poor misery)
totalcount=0

for i in "${dictionary[@]}"; 
do
	((wordcount=$(grep -o -c $i $1)))
	((totalcount+=$wordcount))
	echo $i:$wordcount
done

words=($(wc -w $1))
ratio=$(($words/$totalcount))

echo ---
echo total:$totalcount
echo words:$words
echo ratio:$ratio

echo ---
if [ "$ratio" -gt 1000 ]; then
	echo Sentiment: this book is not sad
else
	echo Sentiment: this book is sad
fi
```
{: .language-bash}

On the end, we run the script with a book stored in txt format:
```
sh sentiment.sh Hamlet.txt
```
{: .language-bash}

> ## Book recommendation
>
> If you want to get deeper into the magic land of command lines, a new book is available for free: [Data Science at the Command Line](https://www.datascienceatthecommandline.com/1e/index.html)
>
{: .callout}


> ## Homework (Optional, no need to submit)
> 
> * Show the first 3 Helicopter incidents outside of Colorado
> * How many incidents did happen were cost is bigger than 0
> * In which Area did the most expensive incident happen that was caused by a Small bird?
{: .challenge}



