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


with open(r"C:\Users\iainm\AOC2024\18\input.txt") as inputFile:
    bytes = inputFile.read().split('\n')
    
rows, cols = (71, 71)
arr = [['.' for i in range(cols)] for j in range(rows)]

for r in arr:
    print(''.join(r))

G = nx.Graph()

for y in range(len(arr)):
    for x in range(len(arr[y])):
        if arr[y][x] == '.':
            G.add_node(f"{x},{y}")
            for n in getNeighbours(arr, x, y):
                G.add_edge(f"{x},{y}", f"{n[0]},{n[1]}")

for byte in bytes:
    x, y = byte.split(',')
    x = int(x)
    y = int(y)
    G.remove_node(f"{x},{y}")
    if not nx.has_path(G, "0,0", "70,70"):
        print(f"{x},{y}")
        sys.exit() 

print(G.number_of_nodes())
print(len(nx.shortest_path(G, "0,0", "70,70")) -1)