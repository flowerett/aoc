#! /usr/bin/env python

import minitest
import sys
import re
from collections import defaultdict
import itertools as it
import functools as ft
import copy as cp
from collections import deque
import heapq

VERBOSE = sys.argv.pop() in ['-v', '--verbose']
FROM_SNAFU = {'2': 2, '1': 1, '0': 0, '-': -1, '=': -2}
TO_SNAFU = {4: '2', 3: '1', 2: '0', 1: '-', 0: '='}


def solve(data: list):
    dd = [row.strip() for row in data]

    nums = map(to_dec, dd)
    dec_sum = sum(nums)
    if VERBOSE:
        print('sum: ', dec_sum)

    return from_dec(dec_sum)


def to_dec(snafu: str):
    di = reversed([FROM_SNAFU[d] for d in list(snafu)])
    num = 0
    for i, n in enumerate(di):
        num += n * 5**i
    return num


def from_dec(num: int):
    reg = []
    num -= 1
    while num > 0:
        num -= 2
        d = num % 5
        num //= 5
        reg.append(d)

    if VERBOSE:
        print('reminder', num, 'last dig', reg[0])

    snf = [TO_SNAFU[d] for d in reversed(reg)]

    return ''.join(snf)


if __name__ == '__main__':
    TEST_INP = """
    1=-0-2
    12111
    2=0=
    21
    2=01
    111
    20012
    112
    1=-1=
    1-12
    12
    1=
    122
    """

    LIVE_INP = '../inputs/day25'
    TEST_RES = '2=-1=0'
    LIVE_RES = '20===-20-020=0001-02'

    with open(LIVE_INP) as f:
        data = f.read().strip().split('\n')

    tdata = TEST_INP.strip().split('\n')

    minitest.assert_one(solve(tdata), TEST_RES, 'TEST_INP')

    r = solve(data)

    minitest.assert_one(r, LIVE_RES, 'LIVE_INP')

    print('res: ', r)
