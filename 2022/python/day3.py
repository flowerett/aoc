#! /usr/bin/env python

import minitest


def solve(data):
    dd = [row.strip() for row in data]
    return t1(dd), t2(dd)


def t1(data):
    sum = 0
    for row in data:
        mid = len(row) // 2
        s1, s2 = set(row[:mid]), set(row[mid:])
        c = s1.intersection(s2).pop()
        sum += to_prio(c)

    return sum


def t2(dd):
    sum = 0
    for gr in chunk(dd):
        sets = [set(r) for r in gr]
        c = set.intersection(*sets).pop()
        sum += to_prio(c)

    return sum


# Same with numpy
# import numpy as np

# nchunks = len(enum) // n
# np.array_split(enum, nchunks)
def chunk(enum, n=3):
    for i in range(0, len(enum), n):
        yield enum[i:i+n]


def to_prio(cc):
    if cc.isupper():
        return ord(cc) - ord('A') + 27
    else:
        return ord(cc) - ord('a') + 1


if __name__ == '__main__':
    TEST_INP = """
    vJrwpWtwJgWrhcsFMMfFFhFp
    jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
    PmmdzqPrVvPwwTWBwg
    wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
    ttgJtRGJQctTZtZT
    CrZsJsPPZsGzwwsLwLmpwMDw
    """
    LIVE_INP = '../inputs/day3'
    TEST_RES = (157, 70)
    LIVE_RES = (7446, 2646)

    tdata = TEST_INP.strip().split("\n")
    minitest.assert_all(solve(tdata), TEST_RES, 'TEST_INP')

    with open(LIVE_INP) as f:
        data = f.read().strip().split('\n')

        r1, r2 = solve(data)
        minitest.assert_all((r1, r2), LIVE_RES, 'LIVE_INP')

        print('res1: ', r1)
        print('res2: ', r2)
