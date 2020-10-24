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

For this exercise we will use Git bash on windows (Linux, Mac have built-in Linux shell, so you don't need to install anything). For windows install Git for windows: https://gitforwindows.org/ More info in Git bash: https://www.atlassian.com/git/tutorials/git-bash.


## Preapring the exercise artifacts

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

To get the required artifacts (flat files for exercises) navigate to a folder suiteable for exercises (like Documents, CEU class folder etc) and clone the course repo:

Example:
```
cd Documents/
mkdir bash
git clone https://github.com/CEU-Economics-and-Business/ECBS-5146-Different-Shapes-of-Data
```
{: .language-bash}



## Basic commands

`cat` -
Print the file to the screen.
```
cat birdstrikes.csv
```
{: .language-bash}

`less` -
Explore the csv
```
less birdstrikes.csv
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

First 10 lines, skipping the 1st: 
```
tail -n+2 birdstrikes.csv | head -10
```
{: .language-bash}

`>` - Put the first 10 lines into an other file (note that instead of -n 10, we used a simplified version)
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
head -n 5 birdstrikes.csv | tail -n 1
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
cat birdstrikes.csv | grep -v Airplane
```
{: .language-bash}
`grep -i` -
Ignore case
```
cat birdstrikes.csv | grep -i airplane
```
{: .language-bash}
## Others

`wc` - show the line, word and character count of birdstrikes
```
wc birdstrikes.csv
```
{: .language-bash}
```wc -l```
shows only the line count

> ## Exercise 2
> Show the word, line and character count of the first 10 lines
{: .challenge}

> ## Exercise 3
> How many incidents were in California (only output line count)
{: .challenge}

## Cutting / printing parts of a line

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

tail -n+2 birdstrikes.csv | cut -d ';' -f6 | sort | uniq | wc -l
```
{: .language-bash}

`uniq -c` -
How many incidents were there by state?
```
tail -n+2 birdstrikes.csv | cut -d ';' -f6 | sort | uniq -c
```
{: .language-bash}

## Scripts

`bash script` - procedural programing able to implement an algorithm.

In the next example, the script analyzing negative sentiment of the books given as parameter to the script.

First we create the file for the script:
```
nano sentiment.sh
```
{: .language-bash}

Then, here is the script itself:
```
dictionary=(sad sorrow death dead pain poor misery)
count=0

for i in "${dictionary[@]}"; 
do 
	
	((smallcount=$(grep -o -c $i $1)))
	((count+=$smallcount))
	echo $i:$smallcount
done

words=$(cat $1|wc -w)
ratio=$(($words/$count))

echo ---
echo total:$count
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

On the end we run the script with a book stored in txt format:
```
sh sentiment.sh Hamlet.txt
```
{: .language-bash}


> ## Homework (Optional, no need to submit)
> 
> * Show the first 3 Helicopter incidents outside of Colorado
> * How many incidents did happen were cost is bigger than 0
> * In which Area did the most expensive incident happen that was caused by a Small bird?
{: .challenge}

