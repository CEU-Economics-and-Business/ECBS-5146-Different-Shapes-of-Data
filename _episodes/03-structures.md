---
title: "Data Structures for Scalability"
teaching: 100
exercises: 100
questions:
- How does my solution scale as the problem becomes bigger?
- Why should I care about algorithmic complexity?
- What is the fastest data structure for searching a value?
objectives:
- Classify search algorithms according to algorithmic complexity.
- Explain the basic idea behind hash tables.
- Build a binary tree from simple ordered data.
- Express the algorithmic complexity of simple algorithms written in pseudocode.
- Compare different data structures.
- Describe linked lists, binary trees and hash tables.
- Contrast worst-case and average algorithmic complexities.
- Understand O() notation.
keypoints:
- If your algorithm is worse than O(n), think harder.
- Indexing takes unordered lists of data and converts them into data structures suitable for efficient lookup.
- "Hash tables > search trees > unordered lists"
---

# Reading
1. [Algorithmic complexity and big-O notation](https://skerritt.blog/big-o/)
2. [Review logarithmic functions](https://github.com/kiss-oliver/ba-pre-session-2019/blob/master/02_functions_of_one_variable/02_slides.pdf)

## Python
1. Download and unzip [pypy](https://pypy.org/download.html#python-3-6-compatible-pypy3-6-v7-2-0). We will use the `pypy3` executable to run simple Python scripts.
2. Review how [for loops](https://realpython.com/python-for-loop/) and [dictionaries](https://realpython.com/python-dicts/) work in Python.

## Optional reading
1. [Tree data structures](https://www.freecodecamp.org/news/all-you-need-to-know-about-tree-data-structures-bceacb85490c/)
2. [Binary search](https://medium.com/karuna-sehgal/a-simplified-interpretation-of-binary-search-246433693e0b) (Ignore the Java and JavaScript code examples.)
3. [Indexing in SQLite](https://medium.com/@JasonWyatt/squeezing-performance-from-sqlite-indexes-indexes-c4e175f3c346)

## Review of Python
### For loops
```
for fruit in ['apple', 'banana', 'plum']:
    print(fruit)
```
{: .language-python}
The Python for loop loops over a collection. Indentation matters. If we want to loop over number, we have to create a collection first.

```
for number in range(5):
    print(number)
```
{: .language-python}
The `range(5)` starts from 0, and ends in 4, so that it has 5 elements.

> ## Exercise
> Write a foor loop printing the first five square numbers.
>> ## Solution
>> ```
>> for number in range(5):
>>     print((number + 1)**2)
>> ```
>> {: .language-python}
> {: .solution}
{: .challenge}

## Lists and dictionaries
Lists are ordered collections of elements. They can be accessed by their index, starting from 0.
```
fruits = ['apple', 'banana', 'plum']
fruits[0] == 'apple'
len(fruit) == 3
# list can contain any element, including other lists
medley = [(2, 'apple'), (3, 'banana')]
for component in medley:
    quantity = component[0]
    fruit = component[1]
# elements can be mixed
everything = [42, 'life', 'universe', 'everything']
# check if element in list
42 in everything
# True
```
{: .language-python}

Tuples are special lists, that cannot be changed after being created ("immutable"). They are created with `()`, rather than `[]`.

Dictionaries are _unordered_ collections of _keys_ and _values_.
```
user = {'name': 'John Doe', 'email': 'john@doe.org'}
print(user.keys())
# dict_keys(['name', 'email'])
print(user.values())
# dict_values(['John Doe', 'john@doe.org'])
print(user['name'])
# John Doe
user['phone'] = '212-123-4567'
print(user)
# {'name': 'John Doe', 'email': 'john@doe.org', 'phone': '212-123-4567'}
print(len(user))
# 3
# check if key in list
'name' in user
# True
# can only check keys, not values
'John Doe' in user
# False
# each key can happen only once
user['phone'] = '617-123-4567'
print(user)
# {'name': 'John Doe', 'email': 'john@doe.org', 'phone': '617-123-4567'}
```
{: .language-python}


# Algorithmic complexity

```
for item = 1 to 5
    sleep for 1 second
```
{: .source}

```
from time import sleep
for item in range(5):
    sleep(1)
```
{: .language-python}

```
for item = 1 to 5
    for other_item = 1 to 2
        sleep for 1 second
```
{: .source}

> ## Exercise
> How long does the following pseudo-code take to run?
> ```
> for item in A B C
>     for other_item in D E
>         sleep for 1 second
> ```
> {: .source}
> > ## Solution
> > The outer loop runs 3 times. The inner loop runs 2 times. Each run takes 1 second, so total runtime is 6 seconds.
> {: .solution}
{: .challenge}

```
for item = 1 to 100
    for other_item = 1 to 100
        if item > other_time
            break loop and stop
        else
            sleep for 1 second
```
{: .source}

```
from time import sleep, time
begin = time()
for item in range(100):
    for other_item in range(100): 
        if item > other_item:
            break
        else:
            sleep(1)
print(time() - begin)
```
{: .language-python}


> ## Exercise
> How long does the following pseudo-code run?
> ```
> for item = 1 to N
>     for other_item = 1 to item
>         sleep for 1 second
> ```
> {: .source}
> > ## Solution
> > If the outer index has value i, the inner loop runs i times. The outer loop iterates over i, so the sleep command runs 1 + 2 + 3 + ... + N times. We know from Euler that this sum is N (N + 1) / 2, so the program takes as many seconds. In Big-O notation, this is O(n^2).
> {: .solution}
{: .challenge}

We use the `sleep` command to illustrate that what matters is the number of times a loop runs, not the runtime of a single run.

> ## Why Big-O notation
> We care about what happens when our problem becomes "very large." As the size of the problem grows without bound, just throwing more resources at it won't help. For large-enough n, an O(n) problem will take more time on a supercomputer than an O(log n) problem will take on your laptop.
> Big-O notation helps uncover the big-picture challenges that defy easy solution.
{: .callout}

### Less than linear runtime

How many times does the following loop run?
```
# a loop to keep breaking a stick in halves
while length_of_stick > LIMIT
    length_of_stick = length_of_stick / 2
```
{: .source}

> ## Challenge (optional)
> Give a simple algorithm to find all divisors of a positive integer `n`. What is its algorithmic complexity?
>> ## Solution
>> [Solution](https://www.geeksforgeeks.org/find-divisors-natural-number-set-1/)
> {: .solution}
{: .challenge}

# Searching for a value
## Data structures

### List (data structure)

{% assign table_data = site.data.structure.indexable %}
{% assign table_caption = "A data table as a list of rows" %}
{% include table.html %}

> ## Exercise
> What is the algorithmic complexity of finding a word in the data table above?
>> ## Solution
>> We have to loop through all the rows to check them against the search word. In the worst case, this takes `n` steps, so the complexity is `O(n)`.
> {: .solution}
{: .challenge}

> ## Challenge (optional)
> Write a for loop in Python that finds a word in `word_list`. Fill in the blanks.
> ```
> word_to_search = 'trousers'
> word_list = ['love', 'authority', 'trousers', 'cut', 'porter', 'low', 'metal']
> for word in ___:
>     if ___ == ___:
>         print(___)
> ```
> {: .language-python}
>> ## Solution
>> ```
>> word_to_search = 'trousers'
>> word_list = ['love', 'authority', 'trousers', 'cut', 'porter', 'low', 'metal']
>> for word in word_list:
>>     if word == word_to_search:
>>         print(word)
>> ```
>> {: .language-python}
> {: .solution}
{: .challenge}


If the list is sorted, a bisection (binary) search can drastically improve search time.

### Ordered list (data structure)

{% assign table_data = site.data.structure.bisection %}
{% assign table_caption = "A sorted list of values" %}
{% include table.html %}

### Bisection search

[Bisection search visualized](http://www.cs.armstrong.edu/liang/animation/web/BinarySearch.html)

```
def bisection(what, sorted_list):
    if len(sorted_list) == 0:
        return 'Not found.'
    middle_index = int(len(sorted_list) / 2)
    if what == sorted_list[middle_index]:
        return sorted_list[middle_index]
    if what < sorted_list[middle_index]:
        return bisection(what, sorted_list[:middle_index])
    else:
        return bisection(what, sorted_list[middle_index+1:])
```
{: .language-python}

> ## Exercise
> For each value in the table above, calculate how many comparison steps does a _bisection search_ take? What is the average and the worst number of steps? What is the Big-O complexity of bisection search?
{: .challenge}

Download `bisection.py` to the folder from which you are running `pypy3`. This Python code implements a binary tree like this.

Check you answer with the following code.
```
from bisection import bisection
list_to_search = [5, 6, 8, 11, 12, 14, 16]
bisection(5, list_to_search, debug=True)
```
{: .language-python}

### Binary tree (data structure)
In fact, sorting is quite expensive algorithmically. Since we have to do it anyway, we create a data structure more suited for searching, the _binary tree_. In this tree, each node has at most two branches. The left branch is an element less than, the right branch is an element greater than the current element.

> ## Exercise
> Take the following binary search tree. For each value stored in it, calculate how many comparison steps are needed to find them in the tree. What is the worst-case and the average number of steps?
> ![](https://upload.wikimedia.org/wikipedia/commons/d/da/Binary_search_tree.svg)
> > ## Solution
> >
> > | Value | Steps |
> > |-------|-------|
> > | 1 | 3 |
> > | 3 | 2 |
> > | 4 | 4 |
> > | 6 | 3 |
> > | 7 | 4 |
> > | 8 | 1 |
> > | 10 | 2 |
> > | 13 | 4 |
> > | 14 | 3|
> > 
> > Elements: 9. Worst-case: 4 steps. Average: 2.9 steps.
> {: .solution}
{: .challenge}

Download `btree.py` to the folder from which you are running `pypy3`. This Python code implements a binary tree like this.
```
from btree import BTree
tree = BTree()
tree.add('love')
tree.add('authority')
tree.add('trousers')
tree.add('cut')
print(tree)
# authority cut love trousers
love = tree.find('love')
print(love)
```
{: .language-python}

> ## Exercise
> Create a binary tree with the debug option turned on, `tree = BTree(debug=True)`. Add all the seven words above to this tree, in the order in which they appear. Then find `'love'` and `'metal'`. How many comparisons do they each take?
{: .challenge}


> ## Quadtree (optional)
> Not everything can be sorted on the real line. Take geo-coordinates, for example. Is (47.6698, 17.6588) bigger than (47.4816, 19.1300)? These points can be arranged in a [quadtree](https://en.wikipedia.org/wiki/Quadtree), in which every node has at most _four_ children, rather than two as in a binary tree. A point to the North-West would become the first child, a point to the North-East the second, etc.
> 
> ![Source: https://commons.wikimedia.org/wiki/User:David_Eppstein/](https://upload.wikimedia.org/wikipedia/commons/8/8b/Point_quadtree.svg)
> 
> Show that looking for a point in a quadtree has `O(log n)` complexity.
> 
> [Searching for points in three dimensions](https://www.youtube.com/watch?v=G67eMq1YwmI)
{: .callout}

To illustrate the performance of binary trees, we are going to generate some random words to search over. Download `random_words.py` to the folder from which you are running `pypy3`. You can use it like this:

```
from random_words import *
for word in random_word_generator(10):
    print(word)
```
{: .language-python}

```
from random_words import *
from btree import BTree
word_tree = BTree(debug=True)
# add 1 milliomn words
for word in random_word_generator(1000000):
    word_tree.add(word)    
len(word_tree)
# 1000000
word_tree.find('abcdefg')
# should make about 20-25 comparisons
```
{: .language-python}

> ## Exercise
> Suppose you categorize your files into folders. To maintain a clear folder structure, each folder contains at most seven files or subfolders. Given your logical structure, you always know for sure which subfolder to look into when searching a file.
> 
> You have 15,000 files to organize. What is the worst-case number of steps for finding a file?
{: .challenge}

With bisection search, binary trees or similar data structures, search time is O(log n). SQLite indexes use balanced trees.

This is very good, but we can do even faster!


## Indexing

> **Indexing** takes unordered lists of data and converts them into data structures suitable for efficient lookup.

{% assign table_data = site.data.structure.id-index %}
{% assign table_caption = "A sorted index of `id`" %}
{% include table.html %}

{% assign table_data = site.data.structure.word-index %}
{% assign table_caption = "A sorted index of `word`" %}
{% include table.html %}

### Hash table (data structure)
> In a well-dimensioned hash table, the average cost (number of instructions) for each lookup is independent of the number of elements stored in the table.

> ## Hash function
> 1. Uniformity
> 2. Defined range
> 3. Pre-image resistant
> 4. Collision resistant
> 5. One-way function
{: .callout}

[cryptographic hash function](https://en.wikipedia.org/wiki/Cryptographic_hash_function)


What if we had an index where we knew exactly where to look for keys?

{% assign table_data = site.data.structure.positional-index %}
{% assign table_caption = "A positional index of `id`" %}
{% include table.html %}

But how to this with text data? Create a function that returns a numeric value in a bounded range for every piece of text. The output of the function should cover the entire range fairly equally and should be easy to calculate. This is a *hash function*.

See, for example:
```
def hash(word):
    '''
    Return a hash based on the sum of characters in the word. 
    a = 1, b = 2, etc
    The hash is an integer between 1 and 20.
    '''
    sum_of_digits = 0
    for char in word.lower():
        sum_of_digits += ord(char) - ord('a') + 1
    return (sum_of_digits) % 20 + 1
```
{: .language-python}

{% assign table_data = site.data.structure.word-hash-index %}
{% assign table_caption = "A hash index of `word`" %}
{% include table.html %}

#### Finding "love"
```
"love" = 12 + 15 + 22 + 5 = 54
54 mod 20 = 14
14 + 1 = 15
```
{: .source}
We should be looking for "love" in the 15th position.

#### Finding "hate"
```
"hate" = 8 + 1 + 20 + 5 = 34
34 mod 20 = 14
14 + 1 = 15
```
{: .source}
The word "hate" also has the same hash ("hash collision"), so it should be in the 15th position. But it is not.

> ## Challenge (optional)
> [Watch this clip](https://www.youtube.com/watch?v=IN4CiToDGNg&t=22m48s) of searching for a lost transit pass in the lost-and-found office. What is the complexity of this search algorithm? (Hint: it is not O(n).)
> ### English transcript
> > You have lost your pass, yes? Sit.  
> > This is not it.  
> > Let's see. This neither.  
> > These are from yesterday.  
> > No. Not here. It wasn't left here.  
> 
> > ## Solution
> > Because each time a pass is checked, it is put back into the pile, this process is slower than O(n). If checked passes went to a new pile, this would be searching in a linked list with O(n) time. However, each pass can be picked up twice or more, slowing down the process. The likelihood of checking again increases with n. In the worst case, the pass is not found in finite time. The average number of check required is O(n log n).
> >
> > This relates to the [coupon collector's problem](https://en.wikipedia.org/wiki/Coupon_collector%27s_problem). 
> {: .solution}
{: .challenge}

You almost never have to create binary trees and hash tables yourself. But you have to understand how they work to know when to use them.

[create index in sqlite](https://www.sqlitetutorial.net/sqlite-index/)

> ## Exercise
> Using `DE.sqlite`, create an index of `WIN_NAME` on the table `seller`. Then search for sellers with the name "Siemens AG". Have SQLite explain the query with `EXPLAIN QUERY PLAN`.
>> ## Solution
>> ```
>> EXPLAIN QUERY PLAN SELECT * FROM seller WHERE WIN_NAME = 'Siemens AG';
>> ```
>> {: .language-sql}
>> With just 61,701 rows, you will not notice any difference in performance. But with 100 millions, this will matter. 
> {: .solution}
{: .challenge}

In Python, _dictionaries_ are implemented as hash tables. [Time complexity of data structure operationsin Python](https://wiki.python.org/moin/TimeComplexity)

> ## Exercise
> Create a dictionary of 10 million random words as keys and the number 1 as value, by filling in the blanks.
> ```
> wd = {}
> for word in random_word_generator(___):
>     wd[___] = ___
> ```
> {: .language-python}
{: .challenge}

# Comparing two values

Suppose we have two lists of student names and want to select all students who appear on both. In SQL, this is called an `INNER JOIN`.

```
for one_student in Anna Cecilia Balazs Daniel
    for other_student in Greg Daniel Anna Pavel
        if one_student == other_student
            yield one_student
```
{: .source}
The complexity of this algorithm is O(nk), with n and k the number of students in each list. (Don't worry, this not how `INNER JOIN` is implemented.)

> ## Exercise
> Count how many sellers also appear as buyers in `DE.sqlite`. Show how this is using the index of winner names.
>> ## Solution
>> ```
>> select count(distinct(WIN_NAME)) from seller inner join buyer on seller.WIN_NAME = buyer.CAE_NAME;
>> ```
>> {: .language-sql}
> {: .solution}
{: .challenge}

> ## Exercise
> We have written a naive double-loop join algorithm in Python to match 1,000 firms with those in a list of a 200 politically connected firms. The code takes 10 minutes to run. After a data update, we will have 500 politically connected firms, and 20,000 candidate firms to match with them. How long will this matching run?
> > ## Solution
> > The naive algorithm makes 1000 x 200 = 200,000 comparisons in 10 minutes, so 1,000 comparisons take 3 seconds. On the bigger data, we would do 20000 x 500 = 10 million comparisons. This takes 500 minutes, that is, 8 hours and 20 minutes.
> {: .solution}
{: .challenge}


