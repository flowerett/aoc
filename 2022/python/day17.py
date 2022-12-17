#! /usr/bin/env python

import minitest
import sys

VERBOSE = sys.argv.pop() in ['-v', '--verbose']

PATT = {
    '-': ['####'],
    '+': [
        '.#.',
        '###',
        '.#.'
    ],
    'L': [
        '..#',
        '..#',
        '###'
    ][::-1],
    '|': [
        '#',
        '#',
        '#',
        '#'
    ],
    '*': [
        '##',
        '##'
    ],
    'void': ['.......', '.......', '.......']
}

DIRS = {'<': (-1, 0), '>': (1, 0), 'v': (0, -1)}


def solve(data):
    dd = list(data)

    r1 = run(dd, 2022)
    r2 = run(dd, 1_000_000_000_000)

    return r1, r2


def run(dd, n):
    figs = list('-+L|*')
    gl = set()
    cnt, top, i = 0, 0, 0
    djump = 0

    cache = {}

    while i < n:
        sym = figs[i % len(figs)]
        fig = fig2set(sym, yoff=top)

        while True:
            dir = dd[cnt]

            if can_move(fig, dir):
                nfig = move(fig, dir)
                if not gl.intersection(nfig):
                    fig = nfig
            cnt = (cnt+1) % len(dd)

            if can_move(fig, 'v', gl=gl):
                nfig = move(fig, 'v')
                if not gl.intersection(nfig):
                    fig = nfig
                else:
                    break
            else:
                break

        gl = gl.union(fig)
        top = get_top(gl)
        i += 1

        # for part2
        # cut(gl, top) => doesn't help much
        key = megablock(gl, cnt)

        if key in cache:
            ci, ctop = cache[key]
            dy = top-ctop
            di = i-ci
            jump = (n-i)//di
            djump += jump*dy
            i += jump*di
        else:
            cache[key] = (i, top)

    total = get_top(gl)

    if VERBOSE:
        print_glass(gl)

    return total+djump


def megablock(gl, cnt, depth=30):
    maxy = max([y for (x, y) in gl])
    top_rocks = [(x, maxy-y) for (x, y) in gl if maxy-y <= depth]
    return (frozenset(top_rocks), cnt)


def fig2set(sym, dx=2, dy=3, yoff=0):
    f = set()
    for y, row in enumerate(PATT[sym]):
        for x, c, in enumerate(row):
            if c == '#':
                f.add((x+dx, y+dy+yoff))
    return f


def get_top(gl):
    top = max([y for (x, y) in gl])
    return top+1


def can_move(fig, dir, gl=None):
    HSIZE = 6
    if dir == '<':
        return all(map(lambda r: r[0] > 0, fig))
    elif dir == '>':
        return all(map(lambda r: r[0] < HSIZE, fig))
    elif dir == 'v':
        return all(map(lambda r: r[1] > 0, fig))


def move(fig, dir):
    dx, dy = DIRS[dir]
    rset = set()
    for x, y in fig:
        rset.add((x+dx, y+dy))
    return rset


def print_glass(gl):
    yy = [y for (x, y) in gl]
    top, bot = max(yy), min(yy)
    for y in range(top, bot-1, -1):
        row = ''
        for x in range(0, 6+1):
            if (x, y) in gl:
                row += '#'
            else:
                row += '.'
        print(row)


def cut(gl, top):
    hy = [0, 0, 0, 0, 0, 0, 0]
    for x in range(7):
        for y in range(top, 0, -1):
            if (x, y) in gl:
                hy[x] = y
                break

    miny = min(hy)

    if miny > 0:
        filtered = [(xx, yy) for (xx, yy) in gl if yy >= miny]
        return set(filtered)
    else:
        return gl


if __name__ == '__main__':
    TEST_INP = """
    >>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>
    """
    LIVE_INP = '../inputs/day17'
    TEST_RES = (3068, 1514285714288)
    LIVE_RES = (3085, 1535483870924)

    with open(LIVE_INP) as f:
        data = f.read().strip()

    tdata = TEST_INP.strip()

    minitest.assert_all(solve(tdata), TEST_RES, 'TEST_INP')

    r1, r2 = solve(data)
    minitest.assert_all((r1, r2), LIVE_RES, 'LIVE_INP')

    print('res1: ', r1)
    print('res2: ', r2)
