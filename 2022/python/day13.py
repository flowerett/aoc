#! /usr/bin/env python

import minitest
import sys
import functools as ft
import itertools as it

VERBOSE = sys.argv.pop() in ['-v', '--verbose']
TWO = [[2]]
SIX = [[6]]


def solve(data):
    dd = prep(data)

    r1 = task1(dd)
    r2 = task2(dd)

    return r1, r2


def task2(dd):
    d2 = prep_t2(dd)

    # sorting by function is removed from v3 (you can sort only by key)
    # so you have to use functools.cmp_to_key
    # https://learnpython.com/blog/python-custom-sort-function/
    # or monkey patch object's cmparison functions of your own:
    # https://github.com/python/cpython/blob/main/Lib/functools.py#L203
    d2 = sorted(d2, key=ft.cmp_to_key(comp))

    return (d2.index(TWO)+1) * (d2.index(SIX)+1)


def task1(dd):
    res = 0
    for i, row in enumerate(dd):
        rc = comp(*row)
        # print(f'comp {i+1}: ', rc)
        if rc < 0:
            res += i+1
    return res


def comp(x, y):
    tx, ty = type(x), type(y)
    match (tx, ty):
        case tx, ty if tx == int and ty == int:
            return x - y
        case tx, ty if tx == int and ty == list:
            return comp([x], y)
        case tx, ty if tx == list and ty == int:
            return comp(x, [y])
        case tx, ty if tx == list and ty == list:
            return comp_lists(x, y)


def comp_lists(xl, yl):
    for x, y in zip(xl, yl):
        v = comp(x, y)
        if v:
            return v
    return len(xl) - len(yl)


def prep(data):
    dd = []
    for row in data:
        a, b = map(lambda c: eval(c.strip()), row.split('\n'))
        dd.append([a, b])
    return dd


def prep_t2(data):
    dd = []
    for a, b in data:
        dd.append(a)
        dd.append(b)

    dd.append(TWO)
    dd.append(SIX)

    return dd


if __name__ == '__main__':
    TEST_INP = """
    [1,1,3,1,1]
    [1,1,5,1,1]

    [[1],[2,3,4]]
    [[1],4]

    [9]
    [[8,7,6]]

    [[4,4],4,4]
    [[4,4],4,4,4]

    [7,7,7,7]
    [7,7,7]

    []
    [3]

    [[[]]]
    [[]]

    [1,[2,[3,[4,[5,6,7]]]],8,9]
    [1,[2,[3,[4,[5,6,0]]]],8,9]
    """
    LIVE_INP = '../inputs/day13'
    TEST_RES = (13, 140)
    LIVE_RES = (5557, 22425)

    with open(LIVE_INP) as f:
        data = f.read().strip().split('\n\n')

    tdata = TEST_INP.strip().split('\n\n')
    minitest.assert_all(solve(tdata), TEST_RES, 'TEST_INP')

    r1, r2 = solve(data)
    minitest.assert_all((r1, r2), LIVE_RES, 'LIVE_INP')

    print('res1: ', r1)
    print('res2: ', r2)
