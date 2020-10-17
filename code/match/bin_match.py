import csv

class Index:
    def __init__(self, rows, callable):
        self._index = {}
        self._callable = callable
        for row in rows:
            self.add(row)

    def __len__(self):
        return len(self._index)

    def add(self, row):
        keys = self._callable(row)
        srow = hash_dict(row)
        if not isinstance(keys, list):
            keys = [keys]
        for key in keys:
            if key in self._index:
                self._index[key].add(srow)
            else:
                self._index[key] = set(srow)

    def get(self, key):
        return self._index[key]

    def search(self, row):
        output = set()
        keys = self._callable(row)
        if not isinstance(keys, list):
            keys = [keys]
        for key in keys:
            output = output.union(self.get(key))
        return output

def hash_dict(dct):
    return tuple((key, dct[key]) for key in dct)

def bigram(text):
    return [''.join(ngram) for ngram in zip(text, text[1:])]

def csv_index(file, field_names):
    return Index(csv.DictReader(file), lambda x: tuple(x[k].lower() for k in field_names))

