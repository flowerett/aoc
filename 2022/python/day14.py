#! /usr/bin/env python

import minitest
import sys
from collections import defaultdict

VERBOSE = sys.argv.pop() in ['-v', '--verbose']


def solve(data, debug=False):
    dd = prep(data)

    start = (500, 0)

    sp = create_space(dd, start)

    size = get_size(sp)
    maxy = size[1][1]

    r1 = add_sand(sp, start, maxy, 0)
    if debug:
        pspace(sp, task=1)
        print(r1)

    r2 = add_sand(sp, start, maxy, r1, task=2)
    if debug:
        pspace(sp, task=2)
        print(r2)

    return r1, r2


def add_sand(sp, start, maxy, cnt, task=1):
    while True:
        x, y = start

        if sp[(x, y)] == 'o':
            return cnt

        space = None
        while not space:
            if y == maxy + 1:
                if task == 1:
                    return cnt
                else:
                    space = '#'

            if sp[(x, y+1)] == '.':
                # move down
                y += 1
            elif sp[(x-1, y+1)] == '.':
                # move down left
                x -= 1
                y += 1
            elif sp[(x+1, y+1)] == '.':
                # move down right
                x += 1
                y += 1
            else:
                space = 'o'

        sp[(x, y)] = space
        cnt = cnt+1 if space == 'o' else cnt


def create_space(dd, start):
    sp = defaultdict(lambda: '.')
    sp[start] = '+'

    # add rocks #
    for line in dd:
        cur = line[0]
        for el in line[1:]:
            y1, y2 = sorted([cur[1], el[1]])
            x1, x2 = sorted([cur[0], el[0]])

            for y in range(y1, y2+1):
                for x in range(x1, x2+1):
                    sp[(x, y)] = '#'
            cur = el

    return sp


def get_size(sp):
    coords = [k for k in sp]
    return min_max(coords)


def pspace(sp, task):
    xr, yr = get_size(sp)
    y1, y2 = yr
    x1, x2 = xr

    print(f'---state T{task}------------')
    for y in range(0, y2+1):
        l = ''
        for x in range(x1, x2+1):
            l += sp[(x, y)]
        print(l)


def min_max(coords):
    def xf(el): return el[0]
    def yf(el): return el[1]
    xmin, xmax = min(coords, key=xf)[0], max(coords, key=xf)[0]
    ymin, ymax = min(coords, key=yf)[1], max(coords, key=yf)[1]

    return (xmin, xmax), (ymin, ymax)


def prep(data):
    dd = []
    for row in data:
        r = []
        for el in row.strip().split(" -> "):
            r.append([int(x) for x in el.split(",")])
        dd.append(r)
    return dd


if __name__ == '__main__':
    TEST_INP = """
    498,4 -> 498,6 -> 496,6
    503,4 -> 502,4 -> 502,9 -> 494,9
    """
    LIVE_INP = '../inputs/day14'
    TEST_RES = (24, 93)
    LIVE_RES = (885, 28691)

    with open(LIVE_INP) as f:
        data = f.read().strip().split('\n')

    tdata = TEST_INP.strip().split('\n')
    minitest.assert_all(solve(tdata), TEST_RES, 'TEST_INP')

    r1, r2 = solve(data, VERBOSE)
    minitest.assert_all((r1, r2), LIVE_RES, 'LIVE_INP')

    print('res1: ', r1)
    print('res2: ', r2)
