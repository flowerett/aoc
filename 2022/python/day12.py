#! /usr/bin/env python

import minitest
import sys

VERBOSE = sys.argv.pop() in ['-v', '--verbose']

NBH = [(-1, 0), (1, 0), (0, -1), (0, 1)]


def solve(data):
    dd = [list(row.strip()) for row in data]
    dd, st, en = prep(dd)

    # run bfs and search for 'E' pos
    r1 = run(dd, st, en)

    # run in reverse for p2 and search for 'a'
    r2 = run(dd, en, st, rev=True)

    return r1, r2


# BFS with a list as a queue
def run(dd, st, en, rev=False):
    rows = len(dd)
    cols = len(dd[0])
    q = [(st, 0)]

    visited = set()

    while q:
        # 1. get next item
        cur, dist = q.pop(0)

        # 2. exit if goal
        if rev:
            x, y = cur
            if dd[x][y] == 'a':
                return dist

        if not rev and cur == en:
            return dist

        # 3. skip if visited
        if cur in visited:
            continue

        # 4. mark as visited
        visited.add(cur)

        # 5. get all valid neighbours, add them to the queue
        for i, j in NBH:
            x, y = cur
            ii, jj = x+i, y+j
            if (0 <= ii <= rows-1) and (0 <= jj <= cols-1) and (ii, jj) not in visited:
                delta = ord(dd[ii][jj]) - ord(dd[x][y])
                if not rev and delta <= 1:
                    q.append(((ii, jj), dist+1))
                elif rev and delta >= -1:
                    q.append(((ii, jj), dist+1))


def prep(dd):
    st, en = None, None
    for i, row in enumerate(dd):
        for j, c in enumerate(row):
            if c == 'S':
                st = (i, j)
                dd[i][j] = 'a'
            if c == 'E':
                en = (i, j)
                dd[i][j] = 'z'

    return dd, st, en


if __name__ == '__main__':
    TEST_INP = """
    Sabqponm
    abcryxxl
    accszExk
    acctuvwj
    abdefghi
    """
    LIVE_INP = '../inputs/day12'
    TEST_RES = (31, 29)
    LIVE_RES = (534, 525)

    with open(LIVE_INP) as f:
        data = f.read().strip().split('\n')

    tdata = TEST_INP.strip().split("\n")

    minitest.assert_all(solve(tdata), TEST_RES, 'TEST_INP')

    r1, r2 = solve(data)
    minitest.assert_all((r1, r2), LIVE_RES, 'LIVE_INP')

    print('res1: ', r1)
    print('res2: ', r2)
