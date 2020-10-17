class Node:
    def __init__(self, val):
        self.l = None
        self.r = None
        self.v = val

    def __str__(self):
        return str(self.v)

class BTree:
    def __init__(self, debug=False):
        self.root = None
        # cach length for easy calculation
        self._len = 0
        self._debug = debug

    def getRoot(self):
        return self.root

    def add(self, val):
        if(self.root == None):
            self.root = Node(val)
            self._len = 1
        else:
            self._add(val, self.root)
            self._len += 1

    def _add(self, val, node):
        if(val < node.v):
            if(node.l != None):
                self._add(val, node.l)
            else:
                node.l = Node(val)
        else:
            if(node.r != None):
                self._add(val, node.r)
            else:
                node.r = Node(val)

    def find(self, val):
        if(self.root != None):
            return self._find(val, self.root)
        else:
            return None

    def _find(self, val, node):
        if self._debug:
            print('Comparing {} with {}.'.format(val, node.v))
        if(val == node.v):
            return node
        elif(val < node.v and node.l != None):
            return self._find(val, node.l)
        elif(val > node.v and node.r != None):
            return self._find(val, node.r)

    def delete(self):
        # garbage collector will do this for us. 
        self.root = None

    def __str__(self):
        if(self.root != None):
            return self._printTree(self.root)

    def __len__(self):
        return self._len

    def _printTree(self, node):
        if node is not None:
            return self._printTree(node.l) + str(node.v) + ' ' + self._printTree(node.r)
        else:
            return ''