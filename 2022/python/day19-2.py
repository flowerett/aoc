#! /usr/bin/env python

import minitest
import sys
import re
import copy as cp

VERBOSE = sys.argv.pop() in ['-v', '--verbose']
T1 = 24
T2 = 32


def solve(data):
    dd = list(map(format, data))

    task1(dd)
    task2(dd)


def task2(dd):
    res2 = 1
    for row in dd[:3]:
        _id, bp = row
        res = {'ore': 0, 'clay': 0, 'obs': 0, 'geo': 0}
        robots = {'ore': 1, 'clay': 0, 'obs': 0, 'geo': 0}
        needs = max_needed(bp)
        print('checking BP:')
        print(bp)
        print(needs)

        cache = {}
        geo = mine_geo(bp, needs, res, robots, T2, cache)
        print('geo: ', geo)
        res2 *= geo

    print('res2: ', res2)


def task1(dd):
    res1 = 0
    for row in dd:
        id, bp = row
        res = {'ore': 0, 'clay': 0, 'obs': 0, 'geo': 0}
        robots = {'ore': 1, 'clay': 0, 'obs': 0, 'geo': 0}
        needs = max_needed(bp)
        print('checking BP:')
        print(bp)
        print(needs)

        cache = {}
        geo = mine_geo(bp, needs, res, robots, T1, cache)
        print('bp res:', id, geo, id * geo)
        res1 += (id * geo)

    print('res1: ', res1)


def mine_geo(bp, needs, res, bots, t, cache):
    if t == 0:
        return res['geo']

    key = to_key(t, bots, res)
    if key in cache:
        return cache[key]

    geo = res['geo'] + bots['geo'] * t

    for k, recipe in bp.items():
        if k != 'geo' and bots[k] >= needs[k]:
            continue

        wait = 0
        for m in recipe:
            need_m = recipe[m]
            if bots[m] == 0:
                break
            wait = max(wait, -(-(need_m - res[m]) // bots[m]))
        else:
            remtime = t - wait - 1
            if remtime <= 0:
                continue

            new_bots = cp.deepcopy(bots)
            new_res = {}
            for m in res:
                new_res[m] = res[m] + bots[m] * (wait+1)

            for m in recipe:
                new_res[m] -= recipe[m]

            new_bots[k] += 1

            for m in needs:
                new_res[m] = min(new_res[m], needs[m] * remtime)

            n_geo = mine_geo(bp, needs, new_res, new_bots, remtime, cache)
            geo = max(geo, n_geo)

    cache[key] = geo
    return geo


def to_key(t, bots, res):
    return tuple([t, *bots.values(), *res.values()])


def max_needed(bp):
    maxn = {}
    for _k, v in bp.items():
        for mat in MT:
            maxn[mat] = max(v.get(mat, 0), maxn.get(mat, 0))

    return maxn


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
    bp = {
        'ore':  {'ore': di[1]},
        'clay': {'ore': di[2]},
        'obs':  {'ore': di[3], 'clay': di[4]},
        'geo':  {'ore': di[5], 'obs': di[6]}
    }

    return (di[0], bp)


if __name__ == '__main__':
    TEST_INP = """
  Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.
  Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian.
  """

    LIVE_INP = '../inputs/day19'

    with open(LIVE_INP) as f:
        data = f.read().strip().split('\n')

    tdata = TEST_INP.strip().split('\n')

    # minitest.assert_all(solve(tdata), TEST_RES, 'TEST_INP 1')

    solve(data)

    # minitest.assert_all((r1, r2), LIVE_RES, 'LIVE_INP')

    # print('res1: ', r1)
    # print('res2: ', r2)
