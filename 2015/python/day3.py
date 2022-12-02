#! /usr/bin/env python

import minitest
from collections import defaultdict

MOVE = {
    '^': (1, 0),
    'v': (-1, 0),
    '>': (0, 1),
    '<': (0, -1)
}


def solve(data):
    px1, py1 = 0, 0
    pxs, pys = 0, 0
    pxr, pyr = 0, 0
    vis1 = defaultdict(int)
    vis2 = defaultdict(int)

    vis1[(0, 0)] += 1
    vis2[(0, 0)] += 2

    for i, s in enumerate(data):
        # T1
        dx, dy = MOVE[s]
        px1 += dx
        py1 += dy
        vis1[(px1, py1)] += 1

        # T2 - %2 == 0 - Santa, else - Robot
        if i % 2 == 0:
            pxs += dx
            pys += dy
            vis2[(pxs, pys)] += 1
        else:
            pxr += dx
            pyr += dy
            vis2[(pxr, pyr)] += 1

    return len(vis1), len(vis2)


if __name__ == '__main__':
    TEST_INP1 = "^>v<"
    TEST_INP2 = "^v^v^v^v^v"

    LIVE_INP = '../inputs/day3'
    TEST_RES1 = (4, 3)
    TEST_RES2 = (2, 11)
    LIVE_RES = (2572, 2631)

    minitest.assert_all(solve(TEST_INP1), TEST_RES1, 'TEST_INP 1')
    minitest.assert_all(solve(TEST_INP2), TEST_RES2, 'TEST_INP 2')

    with open('../inputs/day3') as f:
        data = f.read().strip()

        r1, r2 = solve(data)
        minitest.assert_all((r1, r2), LIVE_RES, 'LIVE_INP')

        print('res1: ', r1)
        print('res2: ', r2)
