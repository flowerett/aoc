#! /usr/bin/env python

import minitest
import sys
import re

VERBOSE = sys.argv.pop() in ['-v', '--verbose']

TEST_INP = """
        ...#
        .#..
        #...
        ....
...#.......#
........#...
..#....#....
..........#.
        ...#....
        .....#..
        .#......
        ......#.

10R5L5R10L4R5L5
"""
TSIZE = 4
S = 50

DIR = {'R': 1j, 'L': -1j, 'W': -1, 'F': 1}
STDIR = 1-0j
FACING = {1: 0, 1j: 1, -1: 2, -1j: 3}

# .12
# .3.
# 54.
# 6..
# X,Y
TILES = {
    # (0,0): ((0,S-1), (0,S-1)),
    1: ((S, 2*S-1), (0, S-1)),
    2: ((2*S, 3*S-1), (0, S-1)),

    # (0,1): ((0,S-1), (S,2*S-1)),
    3: ((S, 2*S-1), (S, 2*S-1)),
    # (2,1): ((2*S,3*S-1), (S,2*S-1)),

    5: ((0, S-1), (2*S, 3*S-1)),
    4: ((S, 2*S-1), (2*S, 3*S-1)),
    # (2,2): ((2*S,3*S-1), (2*S,3*S-1)),

    6: ((0, S-1), (3*S, 4*S-1)),
    # (1,3): ((S,2*S-1), (3*S,4*S-1)),
    # (2,3): ((2*S,3*S-1), (3*S,4*S-1))
}
# source: (target, rotation, offset)
JUMPS = {
    'U1': ('L6', 'R', 2*S*1j),
    'L6': ('U1', 'L', -2*S),
    'L1': ('L5', 'W', S+(3*S-1)*1j),
    'L5': ('L1', 'W', S+(3*S-1)*1j),
    'U2': ('D6', 'F', -2*S + (4*S-1)*1j),
    'D6': ('U2', 'F', 2*S - (4*S-1)*1j),
    'D2': ('R3', 'R', 3*S-2 - S*1j),
    'R3': ('D2', 'L', S + 3*S*1j-2j),
    'R2': ('R4', 'W', 5*S - 2+3*S*1j-1j),
    'R4': ('R2', 'W', 5*S - 2+3*S*1j-1j),
    'L3': ('U5', 'L', -S + 3*S*1j),
    'U5': ('L3', 'R', 3*S + S*1j),
    'D4': ('R6', 'R', 4*S-2 + 2*S*1j),
    'R6': ('D4', 'L', -2*S + 4*S*1j-2j)
}
EDGES = {
    'U1': ((S, 2*S), -1, -1j),
    'L1': (S-1, (0, S), -1),
    'U2': ((2*S, 3*S), -1, -1j),
    'R2': (3*S, (0, S), 1),
    'D2': ((2*S, 3*S), S, 1j),
    'L3': (S-1, (S, 2*S), -1),
    'R3': (2*S, (S, 2*S), 1),
    'R4': (2*S, (2*S, 3*S), 1),
    'D4': ((S, 2*S), 3*S, 1j),
    'U5': ((0, S), 2*S-1, -1j),
    'L5': (-1, (2*S, 3*S), -1),
    'L6': (-1, (3*S, 4*S), -1),
    'R6': (S, (3*S, 4*S), 1),
    'D6': ((0, S), 4*S, 1j)
}


def solve(data):
    st, m, k = parse(data)

    # T1
    cur = (st, STDIR)
    for ind, cmd in enumerate(k):
        cur = move(m, cur, cmd)
    r1 = get_pass(cur)

    # check_edges(m)

    # T2
    cur = (st, STDIR)
    for ind, cmd in enumerate(k):
        cur = move(m, cur, cmd, task=2)
    r2 = get_pass(cur)

    return r1, r2


def check_edges(m):
    check = ['L1', 'L5', 'U1', 'L6', 'U2', 'D6', 'D2',
             'R3', 'R2', 'R4', 'R2', 'L3', 'U5', 'D4', 'R6']
    for edg in check:
        dir, pts = edge_to_list(edg)
        assert len(pts) == 50, f'wrong edge definition {len(pts)}'
        for p in pts:
            warp(m, p, dir)


def edge_to_list(edg):
    o1, o2, dir = EDGES[edg]
    print(f'exploring {edg}, {o1} {o2} {dir}')
    if type(o1) == int and type(o2) == tuple:
        return dir, [(o1+k*1j) for k in range(*o2)]
    elif type(o1) == tuple and type(o2) == int:
        return dir, [(k+o2*1j) for k in range(*o1)]

    assert False, f'bug in edge conversion {o1} {o2} - {type(o1)} {type(o2)}'


def get_pass(cur):
    pos, dir = cur
    xf, yf = pos.real, pos.imag
    x, y = int(xf+1), int(yf+1)
    return x*4 + y*1000 + FACING[dir]


def move(m, cur, cmd, task=1):
    pos, dir = cur
    if cmd in DIR:
        dir *= DIR[cmd]
    elif type(cmd) == int:
        pos, dir = new_pos(m, pos, dir, cmd, task)

    return pos, dir


def new_pos(m, pos, dir, steps, task):
    while steps > 0:
        steps -= 1
        pos += dir

        if pos in m:
            if m[pos]:
                continue
            else:
                # one step back if wall
                return pos - dir, dir
        else:
            tp, tdir = warp(m, pos, dir) if task == 2 else wrap(m, pos, dir)
            if m[tp]:
                pos = tp
                dir = tdir
                continue
            else:
                return pos - dir, dir
    return pos, dir


def wrap(m, pos, dir):
    tmp = pos - dir
    while tmp in m:
        tmp -= dir
    tmp += dir
    return tmp, dir


def check_edge(a, b, ra, rb):
    if type(ra) == tuple and type(rb) == int:
        return a in range(*ra) and b == rb
    elif type(ra) == int and type(rb) == tuple:
        return a == ra and b in range(*rb)
    assert False, f'unknown operands {ra}, {rb}'


def warp(m, pos, dir):
    x, y = pos.real, pos.imag
    # 1. identify edge
    edg = None
    for k in EDGES:
        rx, ry, edr = EDGES[k]
        if check_edge(x, y, rx, ry) and edr == dir:
            edg = k
            break
    assert edg, f'edge can not be found{(x, y)}'

    # 2. get conversion rule
    t, rot, off = JUMPS[edg]
    r = DIR[rot]

    # outside the space => go back 1 step
    tmp = pos-dir

    # print(f'{edg}->{t}|{rot} {off}|', dir,
    #       '>>', dir*r, '|', pos, '>>', tmp*r+off)

    # 3. convert coords & dir
    return tmp*r+off, dir*r


def parse_key(key):
    kk = []
    for i, dir in re.findall(r'(\d+)([R|L]?)', key):
        kk.append(int(i))
        if dir:
            kk.append(dir)
    return kk


def build_map(mp):
    mx, my = get_size(mp)
    m = {}
    # void - have a suspicion we'll need it
    v = set()

    # add missing void to some map parts
    for y in range(my):
        if len(mp[y]) < mx:
            mp[y] = mp[y] + ' '*(mx-len(mp[y]))

    for y in range(my):
        for x in range(mx):
            if mp[y][x] == ' ':
                v.add(x+y*1j)
            elif mp[y][x] == '.':
                m[x+y*1j] = True
            elif mp[y][x] == '#':
                m[x+y*1j] = False

    for x in range(mx):
        if x+0j in m and m[x+0j]:
            st = x+0j
            break

    return m, st


def get_size(mp):
    mx = max([len(row) for row in mp])
    return mx, len(mp)


def parse(data):
    space, kr = data
    space = space.strip('\n')
    k = kr.strip()

    # print(*mp, sep='\n')
    # print(key)

    m, st = build_map(space.split('\n'))
    key = parse_key(k)

    return st, m, key


if __name__ == '__main__':

    LIVE_INP = '../inputs/day22'
    # TEST_RES = (6032, 5031)
    LIVE_RES = (149138, 153203)

    with open(LIVE_INP) as f:
        data = f.read().split('\n\n')

    tdata = TEST_INP.split('\n\n')

    # minitest.assert_all(solve(tdata), TEST_RES, 'TEST_INP')

    r1, r2 = solve(data)

    minitest.assert_all((r1, r2), LIVE_RES, 'LIVE_INP')

    print('res1: ', r1)
    print('res2: ', r2)
