#! /usr/bin/env pypy3

import minitest
import sys
import re
import copy as cp
import itertools as it

VERBOSE = sys.argv.pop() in ['-v', '--verbose']


def solve(data):
    flows = {}
    g = {}
    for row in data:
        node, cost, conn = format(row.strip())
        flows[node] = cost
        g[node] = conn

    dist = fill_dist(flows, g)

    if VERBOSE:
        print('flows', flows)
        print('graph', g)
        print('dist', dist)

    r1 = dp(flows, dist, 30, "AA", set())
    r2 = p2(flows, dist)
    return r1, r2


def p2(fl, dist):
    cmb = combinations(dist)

    maxp = 0
    for h, el in cmb:
        maxr = dp(fl, dist, 26, 'AA', h) + dp(fl, dist, 26, 'AA', el)
        maxp = max(maxp, maxr)

    return maxp


def dp(fl, dist, time, node, ov):
    maxp = 0
    for nxt in dist[node]:
        remtime = time - dist[node][nxt] - 1
        if nxt not in ov and remtime > 0:
            press = fl[nxt] * remtime
            maxr = dp(fl, dist, remtime, nxt, ov | {nxt})
            maxp = max(maxp, maxr + press)
    return maxp


def fill_dist(fl, g):
    to_explore = [n for n, f in fl.items() if n == "AA" or f > 0]
    dist = {}
    for n in to_explore:
        dist[n] = explore(fl, g, n)

    return dist


def explore(fl, g, node):
    q = [(0, node)]
    seen = set()
    with_dist = {}
    while q:
        d, n = q.pop(0)
        if n in seen:
            continue
        seen.add(n)
        if d > 0 and fl[n] > 0:
            with_dist[n] = d
        for nxt in g[n]:
            q.append((d+1, nxt))

    return with_dist


def combinations(dist):
    all = [n for n in dist if n != 'AA']
    l = len(all) // 2
    cmb = []
    for nodes in it.combinations(all, l):
        h = set(nodes)
        cmb.append((h, set(all) - h))
    return cmb


RC = r'[A-Z]{2}'
RD = r'\d+'


def format(row):
    nodes = re.findall(RC, row)
    k = nodes.pop(0)
    dig = re.findall(RD, row)
    return k, int(dig[0]), nodes


if __name__ == '__main__':
    TEST_INP = """
    Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
    Valve BB has flow rate=13; tunnels lead to valves CC, AA
    Valve CC has flow rate=2; tunnels lead to valves DD, BB
    Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
    Valve EE has flow rate=3; tunnels lead to valves FF, DD
    Valve FF has flow rate=0; tunnels lead to valves EE, GG
    Valve GG has flow rate=0; tunnels lead to valves FF, HH
    Valve HH has flow rate=22; tunnel leads to valve GG
    Valve II has flow rate=0; tunnels lead to valves AA, JJ
    Valve JJ has flow rate=21; tunnel leads to valve II
    """
    LIVE_INP = '../inputs/day16'
    TEST_RES = (1651, 1707)
    LIVE_RES = (1850, 2306)

    with open(LIVE_INP) as f:
        data = f.read().strip().split('\n')

    tdata = TEST_INP.strip().split('\n')

    minitest.assert_all(solve(tdata), TEST_RES, 'TEST_INP')

    r1, r2 = solve(data)
    minitest.assert_all((r1, r2), LIVE_RES, 'LIVE_INP')

    print('res1: ', r1)
    print('res2: ', r2)
