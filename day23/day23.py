import random
from collections import defaultdict, deque, namedtuple
import fileinput

Direction = namedtuple("Direction", "name positions_to_check")
directions = deque([
    Direction("north", [(-1, -1), (0, -1), (1, -1)]),
    Direction("south", [(-1, 1), (0, 1), (1, 1)]),
    Direction("west", [(-1, -1), (-1, 0), (-1, 1)]),
    Direction("east", [(1, -1), (1, 0), (1, 1)])],
    maxlen=4)


class Cell:
    def __init__(self, current_elf=None) -> None:
        super().__init__()
        self.current_elf = current_elf
        self.id = random.random()
        self.proposing_elves = []

    def __str__(self) -> str:
        return f"elf={self.current_elf}, proposing_elves={self.proposing_elves}"


class Elf:
    def __init__(self, position) -> None:
        super().__init__()
        self.position = position


cells = defaultdict(Cell)


def init_elves():
    elves = []
    for y, line in enumerate(fileinput.input("input.txt")):
        for x, char in enumerate(line):
            if char == "#":
                elf = Elf((x, y))
                elves.append(elf)
                cells[x, y].current_elf = elf
    return elves


def is_direction_valid(position: tuple, direction: Direction):
    for x_to_check, y_to_check in direction.positions_to_check:
        if cells[position[0] + x_to_check, position[1] + y_to_check].current_elf is not None:
            return False
    return True


if __name__ == '__main__':
    elves = init_elves()

    for round in range(10):
        for elf in elves:
            if not all([is_direction_valid(elf.position, direction) for direction in directions]):
                for direction in directions:
                    if is_direction_valid(elf.position, direction):
                        direction_to_step = direction.positions_to_check[1]
                        cells[elf.position[0] + direction_to_step[0], elf.position[1] + direction_to_step[
                            1]].proposing_elves.append(elf)
                        break

        minx, maxx, miny, maxy = 100000, -100000, 100000, -100000
        for cell in cells:
            if len(cells[cell].proposing_elves) == 1:
                elf = cells[cell].proposing_elves[0]
                # print("moving elf", elf.position, cell)
                cells[elf.position].current_elf = None
                elf.position = cell
                cells[cell].current_elf = elf
            cells[cell].proposing_elves.clear()
            if cells[cell].current_elf is not None:
                minx = min(minx, cell[0])
                maxx = max(maxx, cell[0])
                miny = min(miny, cell[1])
                maxy = max(maxy, cell[1])
        directions.rotate(-1)
        print("Round", round + 1)
        for y in range(miny, maxy + 2):
            for x in range(minx, maxx + 2):
                print("." if cells[x, y].current_elf is None else "#", end="")

            print("")
        print(minx, maxx, miny, maxy, len(elves))
        print((maxx - minx + 1) * (maxy - miny + 1) - len(elves))
