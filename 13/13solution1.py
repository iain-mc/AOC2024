import numpy as np
import re 

with open(r"C:\Users\iainm\AOC2024\13\input.txt") as inputFile:
    equations = inputFile.read().split('\n\n')
    total = 0
    for equation in equations:
        r = re.findall('Button A: X\\+(\d+), Y\\+(\d+)\\nButton B: X\\+(\d+), Y\\+(\d+)\nPrize: X=(\d+), Y=(\d+)',equation)     
        a1, a2, b1, b2, r1, r2 = r[0]
        A = np.array([[int(a1),int(b1)],[int(a2),int(b2)]])
        B = np.array([(int(r1) + 10000000000000), (int(r2) + 10000000000000)])
        C = np.linalg.solve(A,B)

        if(round(C[0], 4).is_integer() and round(C[1], 4).is_integer()):
            pa = C[0]
            pb = C[1]
            total = total + (pa * 3) + pb
    print(total)