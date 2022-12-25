#! /usr/bin/env pypy3

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

DIRS = {'>': (0, 1), '<': (0, -1), 'v': (1, 0), '^': (-1, 0)}
NBH = {(1, 0), (-1, 0), (0, -1), (0, 1), (0, 0)}


def solve(data: list):
    blz, full, ry, rx = parse(data)
    cache = warmup(blz, full, ry, rx)
    st, goal = (0, 1), (ry[1], rx[1]-1)

    hcube = {}
    for m, z in cache.items():
        hcube[z] = m
    mz = len(hcube)

    return find_path(hcube, mz, st, goal)


# heapq is slower than BFS
def find_path(hcube, mz, st, goal):
    r1 = None
    q = deque([(0, 1, 0, False, False)])
    seen = set()
    while q:
        y, x, t, ven, vst = q.popleft()

        if (y, x) == goal:
            if ven and vst:
                if VERBOSE:
                    print('res2: ', t)
                return r1, t
            else:
                if not r1:
                    r1 = t
                    if VERBOSE:
                        print('res1 :', t)
                ven = True
        if (y, x) == st and ven:
            vst = True

        if (y, x, t, ven, vst) in seen:
            continue
        seen.add((y, x, t, ven, vst))

        m = hcube[(t+1) % mz]

        alln = [(ny+y, nx+x) for ny, nx in NBH]
        nxt = [n for n in alln if n in m or n == st or n == goal]

        for ny, nx in nxt:
            q.append((ny, nx, t+1, ven, vst))


def warmup(blz, full, ry, rx):
    cache = {}

    free = frozenset(full - set(blz.keys()))
    cache[free] = 0

    for i in range(1000):
        blz = move(blz, ry, rx)
        free = frozenset(full - set(blz.keys()))
        if free not in cache:
            cache[free] = i+1
        else:
            break

    return cache


def move(blz, ry, rx):
    tmp = defaultdict(tuple)
    for k in blz:
        for el in blz[k]:
            nk = new_pos(k, el, ry, rx)
            tmp[nk] += (el,)

    return tmp


def new_pos(pos, dir, ry, rx):
    y1, y2 = ry
    x1, x2 = rx
    dy, dx = DIRS[dir]
    y, x = pos
    if y == y1 and dy == -1:
        y = y2-1
    elif y == y2-1 and dy == 1:
        y = y1
    else:
        y += dy

    if x == x1 and dx == -1:
        x = x2-1
    elif x == x2-1 and dx == 1:
        x = x1
    else:
        x += dx
    return (y, x)


def parse(data):
    dd = [row.strip() for row in data]
    my = len(dd)
    mx = len(dd[0])
    y1, y2 = 1, my-1
    x1, x2 = 1, mx-1

    # print(*dd, sep='\n')
    # print('size: ', mx, my)

    blz = defaultdict(tuple)
    full = set()
    for y in range(y1, y2):
        for x in range(x1, x2):
            full.add((y, x))
            if dd[y][x] != '.':
                blz[(y, x)] += (dd[y][x],)

    return blz, frozenset(full), (y1, y2), (x1, x2)


def show(blz, ry, rx, ind=0):
    for y in range(*ry):
        row = ''
        for x in range(*rx):
            k = (y, x)
            if k in blz:
                c = str(len(blz[k])) if len(blz[k]) > 1 else blz[k][0]
            else:
                c = '.'
            row += c
        print(row)


if __name__ == '__main__':
    TEST_MIN = """
    #.#####
    #.....#
    #>....#
    #.....#
    #...v.#
    #.....#
    #####.#
    """

    TEST_INP = """
    #.######
    #>>.<^<#
    #.<..<<#
    #>v.><>#
    #<^v^^>#
    ######.#
    """

    LIVE_INP = '../inputs/day24'
    TEST_RES = (18, 54)
    LIVE_RES = (242, 720)

    with open(LIVE_INP) as f:
        data = f.read().strip().split('\n')

    tdata = TEST_INP.strip().split('\n')

    minitest.assert_all(solve(tdata), TEST_RES, 'TEST_INP')

    r1, r2 = solve(data)
    minitest.assert_all((r1, r2), LIVE_RES, 'LIVE_INP')

    print('res1: ', r1)
    print('res2: ', r2)
