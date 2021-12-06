#! /usr/bin/env python

import functools as ft
import minitest


def solve(data):
    data = list(map(int, data))
    return grow(data, 80), grow(data, 256)


def grow(data, days):
    fish = []

    for f in data:
        fish.append([f, 1])

    for _d in range(days):
        num_new = 0

        for i, f in enumerate(fish):
            if f[0] == 0:
                fish[i][0] = 6
                num_new += fish[i][1]
            else:
                fish[i][0] -= 1

        if num_new > 0:
            fish.append([8, num_new])

    return ft.reduce(lambda sum, f: sum + f[1], fish, 0)


if __name__ == '__main__':

    TEST_INP = """
    3,4,3,1,2
    """
    TEST_RES = (5934, 26984457539)

    data = TEST_INP.strip().split(',')
    minitest.assert_all(solve(data), TEST_RES, 'TEST_INP')

    DAY6_RES = (372300, 1675781200288)
    with open('../inputs/day6', 'r') as f:
        data = f.read().strip().split(',')
        r1, r2 = solve(data)
        minitest.assert_all((r1, r2), DAY6_RES, 'DAY6_INP')

        print('res1: ', r1)
        print('res2: ', r2)
