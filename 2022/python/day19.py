#! /usr/bin/env python

import minitest
import sys
import re
from collections import defaultdict
import itertools as it
import functools as ft
import copy as cp

from collections import deque

VERBOSE = sys.argv.pop() in ['-v', '--verbose']
T1 = 24
T2 = 32


def solve(data):
    dd = list(map(format, data))

    # ore, clay, obs, geo
    res = (0, 0, 0, 0)
    bots = (1, 0, 0, 0)

    r1 = task1(dd, res, bots)
    r2 = task2(dd, res, bots)

    return r1, r2


def task2(dd, res, bots):
    r2 = 1

    for row in dd[:3]:
        _id, bp = row
        req = get_req(bp)
        geo = run(bp, req, (res, bots, T2))
        if VERBOSE:
            print(f'BP: ', bp, 'Req:', req)
            print('Geode: ', geo)
        r2 *= geo

    return r2


def task1(dd, res, bots):
    r1 = 0

    for row in dd:
        id, bp = row
        req = get_req(bp)
        geo = run(bp, req, (res, bots, T1))
        if VERBOSE:
            print(f'BP - {id}: ', bp, 'Req:', req)
            print('ID:', id, 'Geode: ', geo, id * geo)
        r1 += id * geo

    return r1


def run(bp, req, init):
    cache = set()
    maxg = 0

    q = deque([init])
    while q:
        res, bots, t = q.popleft()

        maxg = max(maxg, res[3])

        if t == 0:
            continue

        bp1, bp2, bp3, bp4 = bp
        r1, r2, r3, r4 = res
        b1, b2, b3, b4 = bots

        # cut states that doesn't matter
        if b1 >= req[0]:
            b1 = req[0]
        if b2 >= req[1]:
            b2 = req[1]
        if b3 >= req[2]:
            b3 = req[2]

        if r1 >= t*req[0] - b1*(t-1):
            r1 = t*req[0] - b1*(t-1)
        if r2 >= t*req[1] - b2*(t-1):
            r2 = t*req[1] - b2*(t-1)
        if r3 >= t*req[2] - b3*(t-1):
            r3 = t*req[2] - b3*(t-1)

        k = ((r1, r2, r3, r4), (b1, b2, b3, b4), t)
        if k in cache:
            continue
        cache.add(k)

        if VERBOSE and len(cache) % 100_000 == 0:
            print(t, maxg, len(cache))

        # collect resorces, don't build robots
        q.append(((r1+b1, r2+b2, r3+b3, r4+b4), (b1, b2, b3, b4), t-1))

        # build ore robot
        if r1 >= bp1[0]:
            nres = (r1-bp1[0]+b1, r2+b2, r3+b3, r4+b4)
            q.append((nres, (b1+1, b2, b3, b4), t-1))

        # build clay robot
        if r1 >= bp2[0]:
            nres = (r1-bp2[0]+b1, r2+b2, r3+b3, r4+b4)
            q.append((nres, (b1, b2+1, b3, b4), t-1))

        # build obsidian robot
        if r1 >= bp3[0] and r2 >= bp3[1]:
            nres = (r1-bp3[0]+b1, r2-bp3[1]+b2, r3+b3, r4+b4)
            q.append((nres, (b1, b2, b3+1, b4), t-1))

        # build geo robot
        if r1 >= bp4[0] and r3 >= bp4[2]:
            nres = (r1-bp4[0]+b1, r2+b2, r3-bp4[2]+b3, r4+b4)
            q.append((nres, (b1, b2, b3, b4+1), t-1))

    return maxg


def get_req(bp):
    req = [0, 0, 0]
    for bot in bp:
        for i in range(3):
            req[i] = max(bot[i], req[i])

    return tuple(req)


MT = ['ore', 'clay', 'obs']
RD = r'\d+'
# Blueprint 1:
#   Each ore robot costs 4 ore.
#   Each clay robot costs 2 ore.
#   Each obsidian robot costs 3 ore and 14 clay.
#   Each geode robot costs 2 ore and 7 obsidian.


def format(row):
    str = re.findall(RD, row.strip())
    di = list(map(int, str))

    #ore-robot, clay-robot, obsidian-robot, geode-robot
    bp = [
        (di[1], 0, 0),     # 'ore':  {'ore': di[1]},
        (di[2], 0, 0),     # 'clay': {'ore': di[2]},
        (di[3], di[4], 0),  # 'obs':  {'ore': di[3], 'clay': di[4]},
        (di[5], 0, di[6])  # 'geo':  {'ore': di[5], 'obs': di[6]}
    ]

    return (di[0], bp)


if __name__ == '__main__':
    TEST_INP = """
  Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.
  Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian.
  """

    LIVE_INP = '../inputs/day19'
    # live runs faster than test
    # TEST_RES = (33, 3472)
    # LIVE_RES = (1528, 16926)

    with open(LIVE_INP) as f:
        data = f.read().strip().split('\n')

    tdata = TEST_INP.strip().split('\n')

    # minitest.assert_all(solve(tdata), TEST_RES, 'TEST_INP 1')

    # 33s with pypy3
    print('running...')
    r1, r2 = solve(data)

    # minitest.assert_all((r1, r2), LIVE_RES, 'LIVE_INP')

    print('res1: ', r1)
    print('res2: ', r2)
