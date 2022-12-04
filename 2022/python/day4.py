#! /usr/bin/env python

import minitest
import sys

VERBOSE = sys.argv.pop() in ['-v', '--verbose']


def solve(data):
    dd = [row.strip() for row in data]

    cnt1, cnt2 = 0, 0
    for row in dd:
        s1, s2 = [extract(elves) for elves in row.split(',')]

        if VERBOSE:
            print(s1, s2)

        # luckily we don't have big numbers :)
        # => use manual comparisons to speed up
        if s1.issubset(s2) or s2.issubset(s1):
            cnt1 += 1

        if s1 & s2:
            cnt2 += 1

    return cnt1, cnt2


def extract(elves):
    a, b = map(int, elves.split('-'))
    return set(range(a, b+1))


if __name__ == '__main__':
    TEST_INP = """
    2-4,6-8
    2-3,4-5
    5-7,7-9
    2-8,3-7
    6-6,4-6
    2-6,4-8
    """
    LIVE_INP = '../inputs/day4'
    TEST_RES = (2, 4)
    LIVE_RES = (477, 830)

    with open(LIVE_INP) as f:
        data = f.read().strip().split('\n')
        tdata = TEST_INP.strip().split("\n")

        minitest.assert_all(solve(tdata), TEST_RES, 'TEST_INP')

        res = solve(data)
        minitest.assert_all(res, LIVE_RES, 'LIVE_INP')

        print('res1: ', res[0])
        print('res2: ', res[1])
