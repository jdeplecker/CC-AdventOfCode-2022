import fileinput
import re
from collections import deque, namedtuple

OperationElement = namedtuple("OperationElement", "name a b operation")
operations_to_finish_later = deque()
solved_elements = {}

op = {
    '+': lambda x, y: x + y,
    '-': lambda x, y: x - y,
    '*': lambda x, y: x * y,
    '/': lambda x, y: x / y
}

for l in fileinput.input("input.txt"):
    digits = list(map(int, re.findall("-?\d+", l)))
    elements = re.findall("[a-z]{4}", l)
    operations = re.findall("[\+\-\*\/]", l)
    # print(l, digits, elements, operations)
    if len(digits) == 1:
        solved_elements[elements[0]] = digits[0]
    else:
        name, a, b = elements
        operations_to_finish_later.append(OperationElement(name, a, b, operations[0]))

while len(operations_to_finish_later) > 0:
    operation_element = operations_to_finish_later.popleft()
    if operation_element.a in solved_elements and operation_element.b in solved_elements:
        solved_elements[operation_element.name] = int(op[operation_element.operation](solved_elements[operation_element.a], solved_elements[operation_element.b]))
    else:
        operations_to_finish_later.append(operation_element)

print(solved_elements)