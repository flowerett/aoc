#! /usr/bin/env python

import minitest
import sys
import numpy as np

VERBOSE = sys.argv.pop() in ['-v', '--verbose']


def solve(data):
    dd = [[int(el) for el in list(row.strip())] for row in data]

    r1 = task1(dd)
    r2 = task2(dd)

    return r1, r2


def task2(dd):
    rows = len(dd)
    cols = len(dd[0])

    scores = []

    for i in range(rows):
        for j in range(cols):
            sub_score = visible_at(dd, i, j, rows, cols)
            scores.append(sub_score)

    return max(scores)


def visible_at(dd, i, j, rows, cols):
    top = dd[i][j]

    r = dd[i][j+1:cols]
    l = dd[i][:j][::-1]
    t = [row[j] for row in dd[0:i][::-1]]
    b = [row[j] for row in dd[i+1:rows]]

    direction_scores = [visible_dir(lst, top, 0) for lst in [l, r, t, b]]

    return np.product(direction_scores)


def visible_dir(lst, top, cnt):
    for el in lst:
        cnt += 1
        if el >= top:
            break
    return cnt


def task1(dd):
    h = set()
    rows = len(dd)
    cols = len(dd[0])

    # left
    for i in range(1, rows-1):
        hleft = dd[i][0]
        for j in range(1, cols-1):
            if dd[i][j] > hleft:
                h.add((i, j))
                hleft = dd[i][j]

    # top
    for i in range(1, cols-1):
        htop = dd[0][i]
        for j in range(1, rows-1):
            if dd[j][i] > htop:
                h.add((j, i))
                htop = dd[j][i]

    # right
    for i in range(rows-2, 0, -1):
        hright = dd[i][rows-1]
        for j in range(cols-2, 0, -1):
            if dd[i][j] > hright:
                h.add((i, j))
                hright = dd[i][j]

    # bottom
    for i in range(rows-2, 0, -1):
        hbot = dd[rows-1][i]
        for j in range(cols-2, 0, -1):
            if dd[j][i] > hbot:
                h.add((j, i))
                hbot = dd[j][i]

    return len(h) + rows*2 + (cols-2)*2


if __name__ == '__main__':
    TEST_INP = """
    30373
    25512
    65332
    33549
    35390
    """
    LIVE_INP = '../inputs/day8'
    TEST_RES = (21, 8)
    LIVE_RES = (1662, 537600)

    with open(LIVE_INP) as f:
        data = f.read().strip().split('\n')

    tdata = TEST_INP.strip().split("\n")

    minitest.assert_all(solve(tdata), TEST_RES, 'TEST_INP')

    r1, r2 = solve(data)
    minitest.assert_all((r1, r2), LIVE_RES, 'LIVE_INP')

    print('res1: ', r1)
    print('res2: ', r2)
