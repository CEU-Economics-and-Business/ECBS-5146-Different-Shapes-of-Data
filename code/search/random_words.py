import random
import string
from math import ceil, log

N = 1000000

def random_word_generator(number, stringLength=7):
    """Generate a random string of fixed length """
    for n in range(number):
        yield ''.join(random.choice(string.ascii_lowercase) for i in range(stringLength))

word_list = [word for word in random_word_generator(N)]
word_dictionary = {word: None for word in word_list}
