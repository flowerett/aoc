#! /usr/bin/env python

from collections import defaultdict

with open('../inputs/day12', 'r') as f:
    data = f.read().strip().split("\n")

g = defaultdict(set)
for row in data:
    a, b = row.split('-')
    g[a].add(b)
    g[b].add(a)


def traverse(n, seen, dup):
    if n == 'end':
        return 1
    elif n.islower() and n in seen:
        if n == "start" or not dup:
            return 0
        dup = False

    total = 0
    for nxt in g[n]:
        snext = seen | {n}
        total += traverse(nxt, snext, dup)
    return total


print(traverse('start', set(), False))
print(traverse('start', set(), True))
