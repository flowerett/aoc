#! /usr/bin/env python

import minitest
import sys
import operator as op

VERBOSE = sys.argv.pop() in ['-v', '--verbose']


def solve(data):
    h = {}
    for row in data:
        k, v = format(row)
        h[k] = v

    r1 = int(run(h, 'root'))
    r2 = task2(h)

    return r1, r2


def task2(h):
    """
    the right part is constant
    got lucky to have my left part function linear
    in other cases it should be done with a binary search:
      https://github.com/jonathanpaulson/AdventOfCode/blob/master/2022/21.py#L52
    or with a library for symbolic computations like sympy:
      https://github.com/hyper-neutrino/advent-of-code/blob/main/2022/day21p2.py#L3
    """
    a, b, _op = h['root']

    bb = run(h, b, 0)
    a0 = run(h, a, 0)
    a1 = run(h, a, 1)
    return int((bb-a0)/(a1-a0))


def run(h, key, ii='t1'):
    if ii != 't1' and (key == 'humn'):
        return ii

    el = h[key]
    if type(el) == int:
        return el
    else:
        l, r, op = el
        a, b = run(h, l, ii), run(h, r, ii)
        return op(a, b)


OP = {'+': op.add, '-': op.sub, '*': op.mul, '/': op.truediv}


def format(row):
    k, v = row.strip().split(': ')

    if v.isdigit():
        el = int(v)
    else:
        a, op, b = v.split(' ')
        el = (a, b, OP[op])
    return (k, el)


if __name__ == '__main__':
    TEST_INP = """
    root: pppw + sjmn
    dbpl: 5
    cczh: sllz + lgvd
    zczc: 2
    ptdq: humn - dvpt
    dvpt: 3
    lfqf: 4
    humn: 5
    ljgn: 2
    sjmn: drzm * dbpl
    sllz: 4
    pppw: cczh / lfqf
    lgvd: ljgn * ptdq
    drzm: hmdt - zczc
    hmdt: 32
    """

    LIVE_INP = '../inputs/day21'
    TEST_RES = (152, 301)
    LIVE_RES = (364367103397416, 3782852515583)

    with open(LIVE_INP) as f:
        data = f.read().strip().split('\n')

    tdata = TEST_INP.strip().split('\n')

    minitest.assert_all(solve(tdata), TEST_RES, 'TEST_INP 1')

    r1, r2 = solve(data)

    minitest.assert_all((r1, r2), LIVE_RES, 'LIVE_INP')

    print('res1: ', r1)
    print('res2: ', r2)
