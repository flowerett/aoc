#! /usr/bin/env pypy3

import minitest
import sys
import re
from collections import defaultdict
import itertools as it
import functools as ft
import copy as cp
from collections import deque

VERBOSE = sys.argv.pop() in ['-v', '--verbose']

# N, S, W, E, NE, NW, SE, SW
NBH = [(-1, 0), (1, 0), (0, -1), (0, 1), (-1, 1), (-1, -1), (1, 1), (1, -1)]
ADJ = [-1, 0, 1]


def solve(data: list):
    dd = [row.strip() for row in data]

    #N, S, W, E
    dirs = [(-1, 0), (1, 0), (0, -1), (0, 1)]

    m = prep_map(dd)

    r1, r2 = 0, 0

    for ii in range(1, int(1e9)):
        m_old = m
        m, dirs = round(m_old, dirs, ii)
        if ii == 10:
            r1 = empty_ground(m)
        if m == m_old:
            r2 = ii
            if VERBOSE:
                print(f'--round{ii}-- {dirs}')
                show(m)
            break

    return r1, r2


def empty_ground(m):
    x2, y2 = 0, 0
    x1 = len(m)
    y1 = len(m)

    for (y, x) in m:
        x2 = max(x2, x)
        x1 = min(x1, x)
        y2 = max(y2, y)
        y1 = min(y1, y)

    cnt = 0
    for y in range(y1, y2+1):
        for x in range(x1, x2+1):
            if (y, x) not in m:
                cnt += 1
    return cnt


def round(m: set, dirs: list, ri: int):
    prop = defaultdict(int)
    # r1
    for y, x in m:
        if all([(y+j, x+i) not in m for j, i in NBH]):
            continue

        for dj, di in dirs:
            if all([(y+(di and i)+dj, x+(dj and i)+di) not in m for i in ADJ]):
                prop[(y+dj, x+di)] += 1
                break

    new_m = set()
    # r2
    for y, x in m:
        if all([(y+j, x+i) not in m for j, i in NBH]):
            new_m.add((y, x))
        else:
            p = (y, x)
            for dj, di in dirs:
                if all([(y+(di and i)+dj, x+(dj and i)+di) not in m for i in ADJ]):
                    if prop[(y+dj, x+di)] > 1:
                        break
                    p = (y+dj, x+di)
                    break
            new_m.add(p)

    f = dirs.pop(0)
    dirs.append(f)
    return new_m, dirs


def show(m, off=0):
    x2, y2 = 0, 0
    x1 = len(m)
    y1 = len(m)

    for (y, x) in m:
        x2 = max(x2, x)
        x1 = min(x1, x)
        y2 = max(y2, y)
        y1 = min(y1, y)

    for y in range(y1-off, y2+1+off):
        row = ''
        for x in range(x1-off, x2+1+off):
            c = '#' if (y, x) in m else '.'
            row += c
        print(row)


def prep_map(dd):
    r = len(dd)
    c = len(dd[0])

    m = set()
    for y in range(r):
        for x in range(c):
            if dd[y][x] == '#':
                m.add((y, x))

    return m


if __name__ == '__main__':
    TEST_INP = """
    ....#..
    ..###.#
    #...#.#
    .#...##
    #.###..
    ##.#.##
    .#..#..
    """

    S_INP = """
    .....
    ..##.
    ..#..
    .....
    ..##.
    .....
    """

    LIVE_INP = '../inputs/day23'
    TEST_RES = (110, 20)
    LIVE_RES = (3812, 1003)

    with open(LIVE_INP) as f:
        data = f.read().strip().split('\n')

    tdata = TEST_INP.strip().split('\n')

    minitest.assert_all(solve(tdata), TEST_RES, 'TEST_INP')

    r1, r2 = solve(data)

    minitest.assert_all((r1, r2), LIVE_RES, 'LIVE_INP')

    print('res1: ', r1)
    print('res2: ', r2)
