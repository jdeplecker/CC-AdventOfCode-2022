import fileinput
import re
from collections import deque

input = [list(map(int, re.findall("-?\d+", l)))[0] * 811589153 for l in fileinput.input("input.txt")]
positions = deque(range(len(input)), maxlen=len(input))

for _ in range(10):
    for input_index, number in enumerate(input):
        current_pos = positions.index(input_index)
        positions.rotate(-current_pos)
        temp_pos = positions.popleft()
        positions.rotate(-input[temp_pos])
        positions.appendleft(input_index)

print(positions)
pos_zero = positions.index(input.index(0))
positions.rotate(-pos_zero)
output = [input[positions[x % len(input)]] for x in [1000, 2000, 3000]]
print(sum(output))
