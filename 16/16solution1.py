import networkx as nx
import re 

def getCost(d, s, n):
    match d:
        case 'n':
            if n[1] > s[1]:
                return (2001, 's') 
            
            if n[1] < s[1]:
                return (1, 'n') 
            
            if n[0] < s[0]:
                return (1001, 'w') 
            
            if n[0] > s[0]:
                return (1001, 'e') 
        case 's':
            if n[1] > s[1]:
                return (1, 's') 
            
            if n[1] < s[1]:
                return (2001, 'n') 
            
            if n[0] < s[0]:
                return (1001, 'w') 
            
            if n[0] > s[0]:
                return (1001, 'e') 
        case 'w':
            if n[1] > s[1]:
                return (1001, 's') 
            
            if n[1] < s[1]:
                return (1001, 'n') 
            
            if n[0] < s[0]:
                return (1, 'w') 
            
            if n[0] > s[0]:
                return (2001, 'e') 
        case 'e':
            if n[1] > s[1]:
                return (1001, 's') 
            
            if n[1] < s[1]:
                return (1001, 'n') 
            
            if n[0] < s[0]:
                return (2001, 'w') 
            
            if n[0] > s[0]:
                return (1, 'e') 

def getPathCost(p):
    s = (p[0]).split(',')
    t = 0 
    d = 'e'

    for n in p[1:]:
        n = n.split(',')
        r = getCost(d, s, n)
        t = t + r[0]
        d = r[1]
    return t

def getNeighbours(m, x, y):
    n = []
    box = [[-1, 0], [0,-1],[0, 1],[1, 0]]

    for b in box:
        i = b[0]
        j = b[1]
        if(((x + i) >= 0) and ((x + i) < len(m[0])) and ((y + j) >= 0 ) and ((y + j) < len(m))):
            n.append(((x + i),(y + j)))
    
    return n

with open(r"C:\Users\iainm\AOC2024\16\input.txt") as inputFile:
    rows = inputFile.read().split('\n')

arr = []
for r in rows:
    arr.append(list(r))

G = nx.Graph()

for y in range(len(arr)):
    for x in range(len(arr[y])):
        if arr[y][x] == 'S':
            s = f"{x},{y}"

        if arr[y][x] == 'E':
            e = f"{x},{y}"
        
        if arr[y][x] != '#':
            G.add_node(f"{x},{y}")        
            for n in getNeighbours(arr, x, y):
                if arr[n[1]][n[0]] != '#':
                    G.add_edge(f"{x},{y}", f"{n[0]},{n[1]}")


paths = nx.all_shortest_paths(G, s, e)

lowest = float('inf')
for path in paths:
    cost = getPathCost(path)
    print(cost)
    if cost < lowest:
        lowest = cost
        steps = len(path) 

print(lowest)
print(steps)
