#! /usr/bin/env python

# import itertools
# import functools as ft
import minitest


def solve(data):
    sums = []
    for ss in data:
        dd = [int(x) for x in ss.split('\n')]

        psum = sum(dd)
        sums.append(psum)

    r1 = max(sums)

    r2 = sum(sorted(sums, reverse=True)[:3])

    return r1, r2


if __name__ == '__main__':
    TEST_INP = '../inputs/day1t'
    LIVE_INP = '../inputs/day1'
    TEST_RES = (24000, 45000)
    DAY1_RES = (70369, 203002)

    with open(TEST_INP) as f:
        data = f.read().strip().split('\n\n')
        minitest.assert_all(solve(data), TEST_RES, 'TEST_INP')

    with open(LIVE_INP) as f:
        data = f.read().strip().split('\n\n')

        r1, r2 = solve(data)
        minitest.assert_all((r1, r2), DAY1_RES, 'LIVE_INP')

        print('res1: ', r1)
        print('res2: ', r2)
