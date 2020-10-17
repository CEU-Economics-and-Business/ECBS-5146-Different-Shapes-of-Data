import sys

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

def hash_list():
    for word in 'authority cut love low metal porter trousers'.split():
        print(word, hash(word))

if __name__ == "__main__":
    for line in sys.stdin.readlines():
        print(line, hash(line.strip()))