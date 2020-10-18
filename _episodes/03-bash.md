# Command Line Exercises

## Setup

Let's set up our own user folder. Let's copy the birdstrikes file to our own directory:
```
pwd
ls
cp /home/backup/birdstrikes.csv ./
ls
ls -l
```

## Basic commands

`cat` -
Print the file to the screen.
```
cat birdstrikes.csv
```

`less` -
Explore the csv
```
less birdstrikes.csv
```

`head` -
Print the first 3 lines to the file to the screen
```
head -n 3 birdstrikes.csv
```

`man` -
What is `-n`? Check it in the manual
```
man head
```

`tail` -
Check the last 5 lines of the file
```
tail -n 5 birdstrikes.csv
```

`>` - Put the first 10 lines into an other file
```
head -n 10 birdstrikes.csv > first10.csv
```

list the result
```
cat first10.csv
```

* `|` - concatenating command. Show the 10th line only: 
```
head -n 5 birdstrikes.csv | tail -n 1
```

### ***Exercise 1***
Copy the 6th and 7th line of birdstrikes into the myprettypony.csv

## Filtering

`grep` -
Only show incidents from California
```
cat birdstrikes.csv | grep California 
```

`grep -v` -
Only show incidents NOT with Airplanes
```
cat birdstrikes.csv | grep -v Airplane
```

`grep -i` -
Ignore case
```
cat birdstrikes.csv | grep -i airplane
```

## Others

`wc` - show the line, word and character count of birdstrikes
```
wc birdstrikes.csv
```

```wc -l```
shows only the line count

### ***Exercise 2***

Show the word, line and character count of the first 10 lines

### ***Exercise 3***

How many incidents were in California (only output line count)

## Cutting lines

```
cat birdstrikes.csv | cut -d ';' -f5 | head -10
```

* `cut` - Display only 20 rows with *damange* and the *cost* columns
```
cat birdstrikes.csv | cut -d ';' -f4,10
```
### ***Exercise 4***

Write *state* and the *bird size* columns of the 18th line in birdstrikes in file called *onerepublic.csv*. What is the result if run 'cat onerepublic.csv'

## Sorting

```
sort birdstrikes.csv
```

DESC sort by *id*
```
cat birdstrikes.csv | sort -k1 -t ';' -n -r
```


### ***Exercise 5***
What was the cost of the most expensive incident?


## Distinct/Unique values

* `sort | uniq` - 
How many distinct states we have in birdstrikes?
```
cat birdstrikes.csv | cut -d ';' -f6 | sort | uniq | wc -l
```


* `uniq -c` -
How many incidents were there by state?
```
cat birdstrikes.csv | cut -d ';' -f6 | sort | uniq -c
```


## Scripts

* `bash script` - Write a script that gets the first column

```
# nano myfirstscript.sh

cat birdstrikes.csv | cut -d ';' -f5 | head -3


# chmod a+x myfirstscript.sh
# ./myfirstscript.sh
```

* input parameter and for cycle

```
#!/bin/bash

echo DISPLAY $1x times:

for (( i=1; i<=$1; i++ ))
do
  echo $i
  cat birdstrikes.csv | cut -d ';' -f5 | head -3
done

```

## Homework (Optional, no need to submit)

* Show the first 3 Helicopter incidents outside of Colorado
* How many incidents did happen were cost is bigger than 0
* In which Area did the most expensive incident happen that was caused by a Small bird?


