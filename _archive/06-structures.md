---
title: "Data Structures for Scalability"
teaching: 50
exercises: 30
questions:
- How does my solution scale as the problem becomes bigger?
- Why should I care about algorithmic complexity?
- What is the fastest data structure for searching a value?
objectives:
- Classify search algorithms according to algorithmic complexity.
- Build a binary tree from simple ordered data.
- Express the algorithmic complexity of simple algorithms written in pseudocode.
- Compare different data structures.
- Describe linked lists and binary trees.
- Understand O() notation.
keypoints:
- If your algorithm is worse than O(n), think harder.
- Indexing takes unordered lists of data and converts them into data structures suitable for efficient lookup.
- "Hash tables > search trees > unordered lists"
---

# Prerequisites

## Python
1. Download and unzip [pypy](https://pypy.org/download.html#python-3-6-compatible-pypy3-6-v7-2-0). We will use the `pypy3` executable to run simple Python scripts.
2. Review how [for loops](https://realpython.com/python-for-loop/) and [dictionaries](https://realpython.com/python-dicts/) work in Python.

## Reading
1. [Algorithmic complexity and big-O notation](https://skerritt.blog/big-o/)
2. [Review logarithmic functions](https://github.com/kiss-oliver/ba-pre-session-2019/blob/master/02_functions_of_one_variable/02_slides.pdf)
3. [Tree data structures](https://www.freecodecamp.org/news/all-you-need-to-know-about-tree-data-structures-bceacb85490c/)
4. [Binary search](https://medium.com/karuna-sehgal/a-simplified-interpretation-of-binary-search-246433693e0b) (Ignore the Java and JavaScript code examples.)

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
> for item in list
>     for other_item in list
>         sleep for 1 second
> ```
> {: .source}
> > ## Solution
> > The outer loop runs once for each element in the list (N). The inner loop also runs once for each element. The total runtime is N-squared seconds.
> {: .solution}
{: .challenge}

> ## Why Big-O notation
> We care about what happens when our problem becomes "very large." As the size of the problem grows without bound, just throwing more resources at it won't help. For large-enough n, an O(n^2) problem will take more time on a supercomputer than an O(n) problem will take on your laptop.
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


If the list is sorted, a [bisection (binary) search](https://ceu-economics-and-business.github.io/ECBS-5148-Data-Architecture/03-structures/index.html#bisection-search) can drastically improve search time.

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
tree = BTree(debug=True)
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

With bisection search, binary trees or similar data structures, search time is O(log n). SQLite indexes use balanced trees.

This is very good, but we can do even faster!


