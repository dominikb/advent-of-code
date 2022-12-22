from sympy import *
import sys

humn = symbols('humn')
equ = sys.argv[1]
print(solve(equ))