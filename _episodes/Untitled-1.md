
MATCH (o:Officer) 
WHERE toLower(o.name) CONTAINS "the duchy of lancaster"
MATCH p=(o)-[r:OFFICER_OF *..2]-()
RETURN p

MATCH (o:Officer) 
WHERE toLower(o.name) CONTAINS "the duchy of lancaster"
MATCH p=(o)-[*..2]-(e:Address)
RETURN p

MATCH (o:Officer) 
WHERE toLower(o.name) CONTAINS "the duchy of lancaster"
MATCH p=(o)-[*..1]-()
RETURN p

MATCH (o:Officer) 
WHERE toLower(o.name) CONTAINS "the duchy of lancaster"
RETURN o

MATCH p=(o:Officer)-[*..2]-()
WHERE o.name CONTAINS "Ross"
RETURN p