#! /usr/bin/env python

# import itertools
# import functools as ft
import minitest


def solve(data):
    return [int(x) for x in data]


if __name__ == '__main__':
    TEST_INP = '../inputs/day1t'

    with open(TEST_INP) as f:
        data = f.read().strip().split('\n')

        r = solve(data)

        print('res: ', r)
