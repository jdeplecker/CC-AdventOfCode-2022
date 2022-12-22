import fileinput
import re
from collections import deque, namedtuple

from sympy import parse_expr, Symbol, Eq, solve

OperationElement = namedtuple("OperationElement", "name a b operation")
operations_to_finish_later = deque()
solved_elements = {}


def solve_string(input_string):
    x = Symbol('x', real=True)
    lhs = parse_expr(input_string.split('=')[0], local_dict={'x': x})
    rhs = parse_expr(input_string.split('=')[1], local_dict={'x': x})

    print(lhs, "=", rhs)
    return solve(Eq(lhs, rhs), x)


for l in fileinput.input("input.txt"):
    digits = re.findall("-?\d+", l)
    elements = re.findall("[a-z]{4}", l)
    operations = re.findall("[\+\-\*\/]", l)
    # print(l, digits, elements, operations)
    if len(digits) == 1:
        solved_elements[elements[0]] = digits[0]
    else:
        name, a, b = elements
        operations_to_finish_later.append(OperationElement(name, a, b, operations[0] if name != "root" else "="))

solved_elements["humn"] = "x"

while len(operations_to_finish_later) > 0:
    operation_element = operations_to_finish_later.popleft()
    if operation_element.a in solved_elements and operation_element.b in solved_elements:
        solved_elements[operation_element.name] = f"({solved_elements[operation_element.a]} {operation_element.operation} {solved_elements[operation_element.b]})"
    else:
        operations_to_finish_later.append(operation_element)

print(solved_elements["root"][1:-1])
print(solve_string(solved_elements["root"][1:-1]))