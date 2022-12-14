#! /usr/bin/env python

import minitest
import sys
from collections import defaultdict

VERBOSE = sys.argv.pop() in ['-v', '--verbose']


def solve(data, debug=False):
    dd = map(format_row, data)

    start = (500, 0)
    sp, maxy = create_space(dd)

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
    while start not in sp:
        x, y = start

        while True:
            if y == maxy+1:
                if task == 1:
                    return cnt
                break
            if (x, y+1) not in sp:
                # move down
                y += 1
                continue
            elif (x-1, y+1) not in sp:
                # move down left
                x -= 1
                y += 1
                continue
            elif (x+1, y+1) not in sp:
                # move down right
                x += 1
                y += 1
                continue
            # can't move anymore
            break

        sp[(x, y)] = 'o'
        cnt += 1
    return cnt


def create_space(dd):
    sp = {}
    maxy = 0

    # add rocks #
    for line in dd:
        cur = line[0]
        for el in line[1:]:
            y1, y2 = sorted([cur[1], el[1]])
            x1, x2 = sorted([cur[0], el[0]])

            for y in range(y1, y2+1):
                for x in range(x1, x2+1):
                    sp[(x, y)] = '#'
                maxy = max(maxy, y)
            cur = el

    return sp, maxy


def get_size(sp):
    coords = [k for k in sp]
    return min_max(coords)


def pspace(sp, task):
    xr, yr = get_size(sp)
    y1, y2 = yr
    x1, x2 = xr

    print(f'---state T{task}------------')
    for y in range(y1, y2+1):
        row = [sp.get((x, y), '.') for x in range(x1, x2+1)]
        print(''.join(row))


def min_max(coords):
    xmin, xmax = min(coords, key=xf)[0], max(coords, key=xf)[0]
    ymin, ymax = min(coords, key=yf)[1], max(coords, key=yf)[1]

    return (xmin, xmax), (ymin, ymax)


def xf(el): return el[0]
def yf(el): return el[1]


def format_row(row): return [eval(el) for el in row.strip().split(" -> ")]


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
    minitest.assert_all(solve(tdata, VERBOSE), TEST_RES, 'TEST_INP')

    r1, r2 = solve(data)
    minitest.assert_all((r1, r2), LIVE_RES, 'LIVE_INP')

    print('res1: ', r1)
    print('res2: ', r2)
