import networkx as nx
import re 
import numpy as np

def hasT(t):

    for n in t:
        if n.startswith('t'):
            return True
    
    return False

def isTriple(G, n):
    triples = set()
    for n1 in list(nx.all_neighbors(G, n)):
        for n2 in list(nx.all_neighbors(G, n1)):
            if(n2 == n): continue
            for n3 in list(nx.all_neighbors(G, n2)):
                if n3 == n:
                    triples.add(frozenset({n, n1, n2}))
    
    return list(triples)

with open(r"C:\Users\iainm\AOC2024\23\input.txt") as inputFile:
    edges = inputFile.read().split('\n')

G = nx.Graph()

for edge in edges:
    e1, e2 = edge.split('-')
    G.add_edge(e1,e2)


max = 0 
triples = []
for n in G.nodes:
    clique = isTriple(G, n)
    if(len(clique) > max):
        max = len(clique)
        largest = clique 

    triples = triples + isTriple(G, n)
    
print(largest)

combined = set()
for s in largest:
    combined = combined.union(s)

nl = (list(combined))
nl.sort()
print(','.join(nl))