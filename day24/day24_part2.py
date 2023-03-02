import fileinput
from collections import defaultdict
from math import gcd


def encode_dir(char):
    return {"^": 1, "v": 10, "<": 100, ">": 1000}[char]


def init_valley():
    valley = defaultdict(int)
    width = 0
    height = 0
    for y, line in enumerate(fileinput.input("input.txt")):
        width = len(line) - 3
        height = y - 1
        for x, char in enumerate(line):
            if char != "#" and char != "." and char != "\n":
                valley[x - 1, y - 1] = encode_dir(char)
    return valley, width, height


def calculate_next_state(valley_state, width, height):
    next_valley = defaultdict(int)
    for storm in valley_state:
        current_storm = valley_state[storm]
        up = current_storm % 10
        down = current_storm % 100 - up
        left = current_storm % 1000 - up - down
        right = current_storm % 10000 - up - down - left
        next_valley[storm[0], (storm[1] - 1) % height] += up
        next_valley[storm[0], (storm[1] + 1) % height] += down
        next_valley[(storm[0] - 1) % width, storm[1]] += left
        next_valley[(storm[0] + 1) % width, storm[1]] += right

    return next_valley


def is_valid_step(current_pos, step, valley_state):
    step_pos = (current_pos[0] + step[0], current_pos[1] + step[1])
    return (0 <= step_pos[0] < width and 0 <= step_pos[1] < height) and \
        all_valleys[(valley_state + 1) % len(all_valleys)][step_pos] == 0


def calculate_step_score(valley_state, pos_to_eval, depth=10):
    if depth == 0:
        return (goal_pos[0] - pos_to_eval[0]) + (goal_pos[1] - pos_to_eval[1])

    min_step_score = 100000
    for step in possible_steps:
        if is_valid_step(pos_to_eval, step, valley_state):
            min_step_score = min(
                min_step_score,
                calculate_step_score(valley_state + 1, (pos_to_eval[0] + step[0], pos_to_eval[1] + step[1]), depth - 1),
                (goal_pos[0] - pos_to_eval[0]) + (goal_pos[1] - pos_to_eval[1]))
    return min_step_score


if __name__ == '__main__':
    init_state, width, height = init_valley()

    print(init_state, width, height)
    all_valleys = [init_state]

    for i in range((width * height) // gcd(width, height) - 1):
        all_valleys.append(calculate_next_state(all_valleys[-1], width, height))

    elf_pos = (0, 0)
    goal_pos = (width - 1, height - 1)
    steps = [(0, 1)]
    valley_state = 1
    possible_steps = [(0, -1), (0, 1), (-1, 0), (1, 0), (0, 0)]

    while elf_pos != goal_pos:
        closest_step = (0, 0)
        closest_step_score = 100000
        for step in possible_steps:
            if is_valid_step(elf_pos, step, valley_state):
                step_score = calculate_step_score(valley_state + 1, (elf_pos[0] + step[0], elf_pos[1] + step[1]))
                if step_score < closest_step_score:
                    closest_step = step
                    closest_step_score = step_score

        steps.append(closest_step)
        elf_pos = (elf_pos[0] + closest_step[0], elf_pos[1] + closest_step[1])
        valley_state = (valley_state + 1) % len(all_valleys)

        print(elf_pos, closest_step)

    goal_pos = (0, 0)
    valley_state = (valley_state + 1) % len(all_valleys)

    while elf_pos != goal_pos:
        closest_step = (0, 0)
        closest_step_score = 100000
        for step in possible_steps:
            if is_valid_step(elf_pos, step, valley_state):
                step_score = calculate_step_score(valley_state + 1, (elf_pos[0] + step[0], elf_pos[1] + step[1]))
                if step_score < closest_step_score:
                    closest_step = step
                    closest_step_score = step_score

        steps.append(closest_step)
        elf_pos = (elf_pos[0] + closest_step[0], elf_pos[1] + closest_step[1])
        valley_state = (valley_state + 1) % len(all_valleys)

        print(elf_pos, closest_step)

    goal_pos = (width - 1, height - 1)
    valley_state = (valley_state + 1) % len(all_valleys)

    while elf_pos != goal_pos:
        closest_step = (0, 0)
        closest_step_score = 100000
        for step in possible_steps:
            if is_valid_step(elf_pos, step, valley_state):
                step_score = calculate_step_score(valley_state + 1, (elf_pos[0] + step[0], elf_pos[1] + step[1]))
                if step_score < closest_step_score:
                    closest_step = step
                    closest_step_score = step_score

        steps.append(closest_step)
        elf_pos = (elf_pos[0] + closest_step[0], elf_pos[1] + closest_step[1])
        valley_state = (valley_state + 1) % len(all_valleys)

        print(elf_pos, closest_step)
    print(len(steps) + 1)
