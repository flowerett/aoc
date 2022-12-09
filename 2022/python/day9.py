#! /usr/bin/env python

import minitest
import sys

# VERBOSE = sys.argv.pop() in ['-v', '--verbose']

DIRS = {'R': (1, 0), 'L': (-1, 0), 'U': (0, 1), 'D': (0, -1)}


def solve(data, num_k):
    dd = map(extract, data.strip().split('\n'))

    acc = set()
    kns = [(0, 0)] * num_k

    for mv, steps in dd:
        for _ in range(steps):
            kns[0] = move_head(mv, kns[0])
            for i in range(1, len(kns)):
                h, t = kns[i-1], kns[i]
                kns[i] = move_tail(h, t)

            acc.add(kns[-1])

    return len(acc)


def extract(row):
    dir, snum = row.strip().split()
    return DIRS[dir.strip()], int(snum)


def move_head(mv, hd):
    return tuple(a+b for a, b in zip(mv, hd))


def move_tail(h, t):
    xh, yh = h
    xt, yt = t
    dx = xh - xt
    dy = yh - yt
    match abs(dx), abs(dy):
        case 2, 0:
            return xt + step(dx), yt
        case 0, 2:
            return xt, yt + step(dy)
        case adx, ady if adx == 2 or ady == 2:
            return xt + step(dx), yt + step(dy)
        case _:
            return xt, yt


def step(x):
    return (x == abs(x)) and 1 or -1


if __name__ == '__main__':
    TINP1 = """
  R 4
  U 4
  L 3
  D 1
  R 4
  D 1
  L 5
  R 2
  """

    TINP2 = """
  R 5
  U 8
  L 8
  D 3
  R 17
  D 10
  L 25
  U 20
  """

    LIVE_INP = '../inputs/day9'
    TEST_RES = (13, 36)
    LIVE_RES = (6391, 2593)

    with open(LIVE_INP) as f:
        data = f.read()

    test = [(TINP1, 2), (TINP2, 10)]

    for ind, tdata in enumerate(test):
        minitest.assert_one(solve(*tdata), TEST_RES[ind], f'TEST_INP: {ind+1}')

    r1 = solve(data, 2)
    r2 = solve(data, 10)
    minitest.assert_all((r1, r2), LIVE_RES, 'LIVE_INP')

    print('res1: ', r1)
    print('res2: ', r2)
