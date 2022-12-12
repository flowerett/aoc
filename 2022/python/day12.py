#! /usr/bin/env python

import minitest
import sys

VERBOSE = sys.argv.pop() in ['-v', '--verbose']

NBH = [(-1, 0), (1, 0), (0, -1), (0, 1)]


def solve(data):
    dd = [row.strip() for row in data]
    rows = len(data)
    cols = len(data[0])
    di = [[to_num(dd[x][y]) for y in range(cols)] for x in range(rows)]

    st1 = find_start(dd, task=1)
    st2 = find_start(dd, task=2)
    en = set_goal(dd)

    r1 = run(di, st1, en, rows, cols)

    # since we don't need to know the coords
    # of the best start point we can
    # assume any starting point as dist=0
    # and save some compute power
    r2 = run(di, st2, en, rows, cols)

    return r1, r2


# BFS with a list as a queue
def run(di, st, en, rows, cols):
    q = []
    for el in st:
        q.append((el, 0))

    visited = set()
    found = False

    while q:
        # 1. get next item
        cur, dist = q.pop(0)

        # exit if goal
        if cur == en:
            found = True
            break

        # 2. skip if visited
        if cur in visited:
            continue

        # 3. mark as visited
        visited.add(cur)

        # 4. get all neighbours, add them to the queue
        for i, j in NBH:
            x, y = cur
            ii, jj = x+i, y+j
            if (0 <= ii <= rows-1) and (0 <= jj <= cols-1) and (ii, jj) not in visited:
                if di[ii][jj] - di[x][y] <= 1:
                    q.append(((ii, jj), dist+1))

    if found:
        return dist


def to_num(c):
    match c:
        case 'S':
            return 0  # start
        case 'E':
            return 27  # ord('z')-ord('a')+1
        case _:
            return ord(c)-ord('a')+1


def find_start(dd, task=1):
    st = []
    for i, row in enumerate(dd):
        for j, c in enumerate(row):
            if task == 1 and c == 'S':
                st.append((i, j))
            if task == 2 and c == 'a':
                st.append((i, j))
    return st


def set_goal(dd):
    for i, row in enumerate(dd):
        for j, c in enumerate(row):
            if c == 'E':
                return (i, j)


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
