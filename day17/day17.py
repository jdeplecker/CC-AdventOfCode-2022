from collections import defaultdict
from copy import deepcopy

with open(r"input.txt") as f:
    s = f.read().strip()
# s = ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>"

MAX_ROCKS = 1000000000000

rock_shapes = {
    0: [[0, 0], [1, 0], [2, 0], [3, 0]],
    1: [[1, 0], [0, 1], [1, 1], [2, 1], [1, 2]],
    2: [[0, 0], [1, 0], [2, 0], [2, 1], [2, 2]],
    3: [[0, 0], [0, 1], [0, 2], [0, 3]],
    4: [[0, 0], [1, 0], [1, 1], [0, 1]]
}

cave = defaultdict(bool)


def move_horizontal(rock, amount):
    for x, y in rock:
        if x + amount > 6:
            return False
        if x + amount < 0:
            return False
        if cave[x + amount, y]:
            return False
    for coord in rock:
        coord[0] += amount
    return True


def move_vertical(rock, amount):
    for x, y in rock:
        if y + amount < 0:
            return False
        if cave[x, y + amount]:
            return False
    for coord in rock:
        coord[1] += amount
    return True


def settle(rock):
    for x, y in rock:
        cave[x, y] = True


def get_rock_profile():
    highest_ys = [-17 for _ in range(7)]
    for (x, y), v in cave.items():
        if v:
            highest_ys[x] = max(highest_ys[x], y)
    highest_rock = max(highest_ys)
    return tuple(m - highest_rock for m in highest_ys)


def calc_max_y():
    maxy = 0
    for (_, y), v in cave.items():
        if v:
            maxy = max(maxy, y)
    return maxy


if __name__ == '__main__':
    seen = {}

    rock_count = 0
    rock_index = 0
    skipped_ys = 0
    streams = [c for c in s]
    stream_index = 0
    rock = deepcopy(rock_shapes[0])
    move_vertical(rock, 3)
    move_horizontal(rock, 2)

    while rock_count < MAX_ROCKS:
        stream = streams[stream_index]
        stream_index = (stream_index + 1) % len(streams)

        move_horizontal(rock, 1 if stream == ">" else -1)

        if not move_vertical(rock, -1):
            settle(rock)
            max_y = calc_max_y()
            rock_count += 1
            rock_index = rock_count % len(rock_shapes)
            rock = deepcopy(rock_shapes[rock_index])
            move_vertical(rock, 4 + max_y)
            move_horizontal(rock, 2)

            # print("\n".join("".join("#" if cave[x, y] else "." for x in range(7)) for y in range(25, -1, -1)))
            # input()

            rock_profile = get_rock_profile()
            if (rock_profile, rock_index, stream_index) in seen:
                old_rock_count, old_maxy = seen[rock_profile, rock_index, stream_index]
                skipped_rocks = (MAX_ROCKS - rock_count) // (rock_count - old_rock_count)
                rock_count += (rock_count - old_rock_count) * skipped_rocks
                skipped_ys += skipped_rocks * (max_y - old_maxy)

            seen[rock_profile, rock_index, stream_index] = (rock_count, max_y)
        # print(rock)

    print(calc_max_y() + 1 + skipped_ys)
