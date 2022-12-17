#! /usr/bin/env python

import minitest
import sys
import re
import copy as cp
import itertools as it

VERBOSE = sys.argv.pop() in ['-v', '--verbose']

CUT = 1000


def solve(data):
    flows = {}
    g = {}
    for row in data:
        node, cost, conn = format(row.strip())
        flows[node] = cost
        g[node] = conn

    st1 = (0, 0, 'AA', tuple())
    press, ov = dfs1(g, flows, st1, 30)
    print('res1:', press, 'valves: ', ov)


def dfs1(g, flows, st, max):
    q = [st]
    ct = 0

    while q:
        # every new minute take N most promising
        # to cut the number of computations
        if q[0][0] > ct:
            ct = q[0][0]
            q.sort(reverse=True, key=lambda x: x[1])
            q = q[:CUT]

        t, press, node, ov = q.pop(0)
        if t == max:
            return press, ov

        # open valve
        if node not in ov and flows[node] > 0:
            trem = max - t - 1
            new_pr = press + flows[node] * trem
            new_ov = ov + (node,)
            q.append((t+1, new_pr, node, new_ov))

        # move to the next node
        for ne in g[node]:
            q.append((t+1, press, ne, ov))


# def visit(dd, st):
#     q, visited, t, sum = [st], [], 30, 0
#     while (t >= 0) or q:
#         n = q.pop(0)
#         c, open, nn = dd[n]
#         if not open:
#             visited.append(n)
#             sum += c
#             dd[n] = (c, True, nn)
#         t -= 1
#         for n in nn:
#             # if n not in visited:
#             q.append(n)
#     return visited, sum


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

    solve(tdata)

    # minitest.assert_all(
    #     solve(tdata, inp='test', debug=VERBOSE), TEST_RES, 'TEST_INP')

    # r1, r2 = solve(data, inp='live')
    # minitest.assert_all((r1, r2), LIVE_RES, 'LIVE_INP')

    # print('res1: ', r1)
    # print('res2: ', r2)
