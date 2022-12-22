from collections import defaultdict, deque
import fileinput
import re


class Node:
    top = None
    right = None
    down = None
    left = None
    is_wall = False

    def __init__(self, is_wall=False) -> None:
        super().__init__()
        self.is_wall = is_wall

    def __str__(self) -> str:
        return f"top={self.top}, right={self.right}, down={self.down}, left={self.left}"


nodes = defaultdict(Node)

node_to_start: Node = None
max_ys_per_x = {}
min_ys_per_x = {}
line_was_empty = False


def construct_nodes():
    global node_to_start
    latest_free_x = -1
    first_free_x = -1
    for x, char in enumerate(line):
        if char != "." and char != "#":
            continue
        if not node_to_start:
            node_to_start = (x, y)
        if first_free_x == -1:
            first_free_x = x
        if not x in min_ys_per_x:
            min_ys_per_x[x] = y

        nodes[x, y] = Node(False if char == "." else True)
        latest_free_x = x
        max_ys_per_x[x] = y

        if (x - 1, y) in nodes:
            nodes[x, y].left = (x - 1, y)
            nodes[x - 1, y].right = (x, y)
        if (x, y - 1) in nodes:
            nodes[x, y].top = (x, y - 1)
            nodes[x, y - 1].down = (x, y)
    nodes[first_free_x, y].left = (latest_free_x, y)
    nodes[latest_free_x, y].right = (first_free_x, y)


directions = ["right", "down", "left", "top"]
current_dir = deque(directions, maxlen=4)

for y, line in enumerate(fileinput.input("input.txt")):
    construct_nodes()
    if line_was_empty:
        for x, max_y in max_ys_per_x.items():
            nodes[x, min_ys_per_x[x]].top = (x, max_y)
            nodes[x, max_y].down = (x, min_ys_per_x[x])

        current_node = node_to_start
        for commands in re.findall("\d+|[RL]", line):
            if commands.isnumeric():
                for i in range(int(commands)):
                    next_node_candidate = nodes[current_node].__getattribute__(current_dir[0])
                    if next_node_candidate in nodes and not nodes[next_node_candidate].is_wall:
                        current_node = next_node_candidate
                        # print(current_dir[0], current_node)
            elif commands == "R":
                current_dir.rotate(-1)
                # print("R", current_dir[0])
            else:
                current_dir.rotate(1)
                # print("L", current_dir[0])

        print(current_dir[0], current_node)
        print(1000 * (current_node[1] + 1) + 4 * (current_node[0] + 1) + directions.index(current_dir[0]))

    line_was_empty = len(line) == 1
