#! /usr/bin/env python

# import itertools
# import math
import functools as ft
import minitest


def wrap(row):
    l, w, h = [int(i) for i in row.split('x')]
    # min = sorted([l,w,h])[0:2]
    # slack = math.prod(min)
    a, b = sorted([l, w, h])[0:2]

    paper = 2*l*w + 2*w*h + 2*h*l + a*b

    ribbon = 2*a+2*b + l*w*h
    return paper, ribbon


def solve(data):
    d = map(wrap, data)
    r1, r2 = ft.reduce(lambda x, y: (x[0] + y[0], x[1] + y[1]), d)

    return r1, r2


if __name__ == '__main__':
    TEST_INP = '../inputs/day2t'
    TEST_RES = (101, 48)

    with open(TEST_INP) as f:
        data = f.read().strip().split('\n')
        minitest.assert_all(solve(data), TEST_RES, 'TEST_INP')

    DAY2_RES = (1586300, 3737498)
    with open('../inputs/day2', 'r') as f:
        data = f.read().strip().split('\n')
        r1, r2 = solve(data)

        minitest.assert_all((r1, r2), DAY2_RES, 'DAY2_INP')

        print('res1: ', r1)
        print('res2: ', r2)
