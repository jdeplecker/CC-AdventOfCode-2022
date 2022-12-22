from collections import defaultdict, deque
import fileinput
import re


class Node:
    top = None
    right = None
    down = None
    left = None
    is_wall = False
    rotate = defaultdict(int)

    def __init__(self, is_wall=False) -> None:
        super().__init__()
        self.is_wall = is_wall

    def __str__(self) -> str:
        return f"top={self.top}, right={self.right}, down={self.down}, left={self.left}"


nodes = defaultdict(Node)

node_to_start: Node = None
line_was_empty = False


def construct_nodes():
    global node_to_start
    for x, char in enumerate(line):
        if char != "." and char != "#":
            continue
        if not node_to_start:
            node_to_start = (x, y)

        nodes[x, y] = Node(False if char == "." else True)

        if (x - 1, y) in nodes:
            nodes[x, y].left = (x - 1, y)
            nodes[x - 1, y].right = (x, y)
        if (x, y - 1) in nodes:
            nodes[x, y].top = (x, y - 1)
            nodes[x, y - 1].down = (x, y)


directions = ["right", "down", "left", "top"]
current_dir = deque(directions, maxlen=4)


def fix_links():
    #   1 4
    #   3
    # 5 6 
    # 2  

    for i in range(50):
        # 1 to 5
        nodes[50, i].left = (0, 149 - i)
        nodes[50, i].rotate["left"] = 2
        nodes[0, 149 - i].left = (50, i)
        nodes[0, 149 - i].rotate["left"] = 2
        # 1 to 2
        nodes[50 + i, 0].top = (0, 150 + i)
        nodes[50 + i, 0].rotate["left"] = 1
        nodes[0, 150 + i].left = (50 + i, 0)
        nodes[0, 150 + i].rotate["top"] = -1
        # 2 to 4
        nodes[i, 199].down = (100 + i, 0)
        nodes[100 + i, 0].top = (i, 199)
        # 2 to 6
        nodes[150 + i, 49].right = (50 + i, 149)
        nodes[150 + i, 49].rotate["down"] = -1
        nodes[50 + i, 149].down = (150 + i, 49)
        nodes[50 + i, 149].rotate["right"] = 1
        # 3 to 4
        nodes[99, 50 + i].right = (100 + i, 49)
        nodes[99, 50 + i].rotate["down"] = -1
        nodes[100 + i, 49].down = (99, 50 + i)
        nodes[100 + i, 49].rotate["right"] = 1
        # 3 to 5
        nodes[50, 50 + i].left = (i, 100)
        nodes[50, 50 + i].rotate["top"] = -1
        nodes[i, 100].top = (50, 50 + i)
        nodes[i, 100].rotate["left"] = 1
        # 4 to 6
        nodes[150, 49 - i].right = (99, 100 + i)
        nodes[150, 49 - i].rotate["left"] = 2
        nodes[99, 100 + i].right = (150, 49 - i)
        nodes[99, 100 + i].rotate["left"] = 2


for y, line in enumerate(fileinput.input("input.txt")):
    construct_nodes()
    if line_was_empty:
        fix_links()

        current_node = node_to_start
        for commands in re.findall("\d+|[RL]", line):
            if commands.isnumeric():
                for i in range(int(commands)):
                    next_node_candidate = nodes[current_node].__getattribute__(current_dir[0])
                    if next_node_candidate in nodes and not nodes[next_node_candidate].is_wall:
                        current_node = next_node_candidate
                        # print(current_dir[0], current_node)
                        current_dir.rotate(nodes[next_node_candidate].rotate[current_dir[0]])
            elif commands == "R":
                current_dir.rotate(-1)
                # print("R", current_dir[0])
            else:
                current_dir.rotate(1)
                # print("L", current_dir[0])

        print(current_dir[0], current_node)
        print(1000 * (current_node[1] + 1) + 4 * (current_node[0] + 1) + directions.index(current_dir[0]))

    line_was_empty = len(line) == 1
