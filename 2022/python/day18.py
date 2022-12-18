#! /usr/bin/env python

import minitest
import sys

VERBOSE = sys.argv.pop() in ['-v', '--verbose']


def solve(data):
    cubes = set(map(format, data))

    s1 = get_surface(cubes)
    s2 = task2(cubes)

    return s1, s2


def task2(lava):
    dim = dimensions(lava)
    air = find_air(lava, dim)
    trapped = find_trapped(air, lava, dim)
    if VERBOSE:
        print(f'air: {len(air)}, trapped air: {len(trapped)}')

    cubes = lava | trapped
    return get_surface(cubes)


def find_trapped(air, lava, dim):
    out, trapped = set(), set()

    while air:
        out, trapped, seen = dfs(air, out, trapped, lava, dim)
        air = air - seen

    return trapped


def dfs(air, out, trapped, lava, dim):
    # DFS is a bit faster
    # but BFS will work as well
    xm, ym, zm = dim

    nxt = air.pop()
    q = [nxt]
    seen = set()
    while q:
        p = q.pop()
        if p in seen:
            continue
        x, y, z = p
        seen.add(p)
        if (x in (1, xm)) or (y in (1, ym)) or (z in (1, zm)) or p in out:
            return out | seen, trapped, seen
        else:
            for n in get_neighbours(x, y, z):
                if n not in seen and n not in lava:
                    q.append(n)

    return out, trapped | seen, seen


def get_neighbours(x, y, z):
    return [(x-1, y, z), (x+1, y, z), (x, y-1, z), (x, y+1, z), (x, y, z-1), (x, y, z+1)]


def find_air(cubes, dim):
    xm, ym, zm = dim
    air = set()

    for xi in range(1, xm+1):
        for yi in range(1, ym+1):
            for zi in range(1, zm+1):
                if (xi, yi, zi) not in cubes:
                    air.add((xi, yi, zi))

    return air


def get_surface(cubes):
    total = 0
    cntset = set()
    for x, y, z in cubes:
        total += 6  # 6*a**2
        if (x-1, y, z) in cntset:
            total -= 2
        if (x+1, y, z) in cntset:
            total -= 2
        if (x, y-1, z) in cntset:
            total -= 2
        if (x, y+1, z) in cntset:
            total -= 2
        if (x, y, z-1) in cntset:
            total -= 2
        if (x, y, z+1) in cntset:
            total -= 2
        cntset.add((x, y, z))

    return total


def dimensions(cubes):
    xm, ym, zm = 0, 0, 0
    for x, y, z in cubes:
        xm = max(xm, x)
        ym = max(ym, y)
        zm = max(zm, z)

    return xm, ym, zm


def format(row):
    return tuple(map(int, row.strip().split(',')))


if __name__ == '__main__':
    TEST_INP = """
    1,1,1
    2,1,1
    """

    TEST_INP2 = """
    2,2,2
    1,2,2
    3,2,2
    2,1,2
    2,3,2
    2,2,1
    2,2,3
    2,2,4
    2,2,6
    1,2,5
    3,2,5
    2,1,5
    2,3,5
    """

    LIVE_INP = '../inputs/day18'
    TEST_RES = (10, 10)
    TEST_RES2 = (64, 58)
    LIVE_RES = (4390, 2534)

    with open(LIVE_INP) as f:
        data = f.read().strip().split('\n')

    tdata = TEST_INP.strip().split('\n')
    tdata2 = TEST_INP2.strip().split('\n')

    minitest.assert_all(solve(tdata), TEST_RES, 'TEST_INP 1')
    minitest.assert_all(solve(tdata2), TEST_RES2, 'TEST_INP 2')

    r1, r2 = solve(data)

    minitest.assert_all((r1, r2), LIVE_RES, 'LIVE_INP')

    print('res1: ', r1)
    print('res2: ', r2)
