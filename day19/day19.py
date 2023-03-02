import re
from collections import namedtuple
from random import random

with open('input.txt') as inputfile:
    lines = [b.strip() for b in inputfile.readlines()]

Rule = namedtuple('Rule', 'id ore clay obsidian geode')
rules = []
for line in lines:
    numbers = re.findall(r'\d+', line)
    a, b, c, d, e, f, g = [int(x) for x in numbers]
    rule = Rule(a, b, c, (d, e), (f, g))
    rules.append(rule)


def runOne(rule, minutes):
    ore = 0
    clay = 0
    obsidian = 0
    geode = 0
    oreRobots = 1
    clayRobots = 0
    obsidianRobots = 0
    geodeRobots = 0
    oreBuilding = False
    clayBuilding = False
    obsidianBuilding = False
    geodeBuilding = False

    for i in range(minutes):
        rnd = random()
        if ore >= rule.geode[0] and obsidian >= rule.geode[1]:
            ore -= rule.geode[0]
            obsidian -= rule.geode[1]
            geodeBuilding = True
        elif rnd <= 0.3 and ore >= rule.ore:
            ore -= rule.ore
            oreBuilding = True
        elif rnd <= 0.7 and ore >= rule.obsidian[0] and clay >= rule.obsidian[1]:
            ore -= rule.obsidian[0]
            clay -= rule.obsidian[1]
            obsidianBuilding = True
        elif rnd <= 0.9 and ore >= rule.clay:
            ore -= rule.clay
            clayBuilding = True
        else:
            pass

        ore += oreRobots
        clay += clayRobots
        obsidian += obsidianRobots
        geode += geodeRobots

        if geodeBuilding:
            geodeBuilding = False
            geodeRobots += 1
        elif obsidianBuilding:
            obsidianBuilding = False
            obsidianRobots += 1
        elif clayBuilding:
            clayBuilding = False
            clayRobots += 1
        elif oreBuilding:
            oreBuilding = False
            oreRobots += 1

    return geode


results = []
for r in range(len(rules)):
    rule = rules[r]
    runs = []
    for i in range(500000):
        geodes = runOne(rule, 24)
        runs.append(geodes)
    results.append((rule.id * max(runs)))

print(f'results: {sum(results)}')

