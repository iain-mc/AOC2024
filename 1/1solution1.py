l = []
r = []

with open(r"C:\Users\iainm\AOC2024\1\input.txt") as inputFile:
    while line := inputFile.readline():
        x,y = line.split()
        l.append(int(x))
        r.append(int(y))

l.sort()
r.sort()

total = 0

for i in range(0, len(l)):
    total += abs(l[i] - r[i])

print(total)

        
