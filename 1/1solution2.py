l = []
r = []

with open(r"C:\Users\iainm\AOC2024\1\input.txt") as inputFile:
    while line := inputFile.readline():
        x,y = line.split()
        l.append(int(x))
        r.append(int(y))

total = 0

for i in l:
    c = 0
    for j in r:
        if (i == j):
           c += 1
    total += (i * c)

print(total)

        
