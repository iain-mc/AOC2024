import networkx as nx
import re 

def getNeighbours(m, x, y):
    n = []
    box = [[-1, 0], [0,-1],[0, 1],[1, 0]]

    for b in box:
        i = b[0]
        j = b[1]
        if(((x + i) >= 0) and ((x + i) < len(m[0])) and ((y + j) >= 0 ) and ((y + j) < len(m))):
            n.append(((x + i),(y + j)))
    
    return n


with open(r"C:\Users\iainm\AOC2024\20\input.txt") as inputFile:
    input = inputFile.read().split('\n')

rows = len(input[0])

arr = [list(input[j]) for j in range(rows)]

for r in arr:
    print(''.join(r))

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

spLen = len(nx.shortest_path(G, s, e)) -1

print(spLen)

total = 0 

for y in range(len(arr)):
    for x in range(len(arr[y])):
        if arr[y][x] == '#':
            G.add_node(f"{x},{y}")        
            for n in getNeighbours(arr, x, y):
                if arr[n[1]][n[0]] != '#':
                    G.add_edge(f"{x},{y}", f"{n[0]},{n[1]}")
            newSP = len(nx.shortest_path(G, s, e)) -1
            
            if(spLen - newSP >= 100):
                total = total + 1
            
            G.remove_node(f"{x},{y}")

print(total)