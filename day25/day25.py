import fileinput
from collections import deque

decode_dict = {"0": 0, "1": 1, "2": 2, "-": -1, "=": -2}
encode_dict = {0: "0", 1: "1", 2: "2", 3: "=", 4: "-"}


def decode(char_list: list) -> int:
    char_list.reverse()
    result = 0
    for i, c in enumerate(char_list):
        result += decode_dict[c] * pow(5, i)
    return result


def encode(number: int) -> str:
    result = [0]
    reconstructing_number = number
    index = 0

    while pow(5, index + 1) < number:
        index += 1

    for i in range(index, -1, -1):
        current_value = reconstructing_number // pow(5, i)
        result.append(current_value)
        reconstructing_number -= current_value * pow(5, i)

    for i in range(len(result) -1, -1, -1):
        if result[i] > 4:
            result[i] -= 5
            result[i - 1] += 1
        if result[i] > 2:
            result[i - 1] += 1

    if result[0] == 0:
        result.remove(0)

    return "".join([encode_dict[x] for x in result])


if __name__ == '__main__':
    sum = 0
    for line in fileinput.input("input.txt"):
        sum += decode([c for c in line if c != "\n"])
    print(sum)
    print(encode(sum))
