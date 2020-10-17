from random_words import *
from time import time


t0 = time()

for word in word_list:
	word_list.index(word)

t1 = time()
print(t1 - t0)