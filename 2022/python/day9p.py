#! /usr/bin/env python

DIRS = {'R': 1, 'L': -1, 'U': 1j, 'D': -1j}


def solve(data):
    dd = map(extract, data.strip().split('\n'))

    h = 0
    print('h: ', h)

    for mv, steps in dd:
        h = h + DIRS[mv] * steps
        print(f'move: {mv}, h: {h}')

    print('h.real represents X:', h.real)
    print('h.imag represents Y:', h.imag)


def extract(row):
    dir, snum = row.strip().split()
    return dir.strip(), int(snum)


data = """
R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2
"""

solve(data)
