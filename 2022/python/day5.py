#! /usr/bin/env python

import minitest
import sys
import re
import copy
import numpy as np

VERBOSE = sys.argv.pop() in ['-v', '--verbose']


def solve(raw):
    p1, p2 = raw.split('\n\n')
    data = p2.strip().split('\n')
    crates = parse_crates(p1)

    cr1 = copy.deepcopy(crates)
    cr2 = copy.deepcopy(crates)

    for row in data:
        cmd = fmt(row)

        # t1
        cr1 = move_t1(cr1, cmd)

        # t2
        cr2 = move_t2(cr2, cmd)

    return to_msg(cr1), to_msg(cr2)


def parse_crates(raw):
    rows = raw.split('\n')

    # get lines without numbers, convert to a matrix
    mx = [list(l) for l in rows[:-1]]

    # rotate clockwise using np
    # same can be done with zip():
    # transposed = list(zip(*matrix))
    # rotated = [list(reversed(row)) for row in transposed]
    rt = np.rot90(mx, 1, (1, 0))

    # filter only lines with letters
    ft = filter(lambda el: el[0].isalpha(), rt)

    # strip blank chars and split into char list
    return [list(''.join(l).strip()) for l in ft]


def fmt(row):
    exp = r'^move (\d+) from (\d+) to (\d+$)'
    rr = re.findall(exp, row.strip())[0]
    return list(map(int, rr))


def move_t1(crates, cmd):
    cnt, f, t = cmd

    for _i in range(cnt):
        c = crates[f-1].pop()
        crates[t-1].append(c)

    return crates


def move_t2(crates, cmd):
    cnt, f, t = cmd

    # moving top CNT crates from F to T
    crates[t-1] += crates[f-1][-cnt:]

    # overriding F - removing top CNT crates
    crates[f-1] = crates[f-1][:-cnt]

    return crates


def to_msg(crates):
    msg = [el[-1] for el in crates]
    return ''.join(msg)


if __name__ == '__main__':
    TEST_INP = '../inputs/day5t'
    LIVE_INP = '../inputs/day5'
    TEST_RES = ('CMZ', 'MCD')
    LIVE_RES = ('QNHWJVJZW', 'BPCZJLFJW')

    # faster was just write input as an array
    # tcrates = [['Z', 'N'], ['M', 'C', 'D'], ['P']]
    # crates = [
    #     ["C", "Z", "N", "B", "M", "W", "Q", "V"],
    #     ["H", "Z", "R", "W", "C", "B"],
    #     ["F", "Q", "R", "J"],
    #     ["Z", "S", "W", "H", "F", "N", "M", "T"],
    #     ["G", "F", "W", "L", "N", "Q", "P"],
    #     ["L", "P", "W"],
    #     ["V", "B", "D", "R", "G", "C", "Q", "J"],
    #     ["Z", "Q", "N", "B", "W"],
    #     ["H", "L", "F", "C", "G", "T", "J"]
    # ]

    with open(TEST_INP) as f:
        tdata = f.read()
        minitest.assert_all(solve(tdata), TEST_RES, 'TEST_INP')

    with open(LIVE_INP) as f:
        data = f.read().strip()

        r1, r2 = solve(data)
        minitest.assert_all((r1, r2), LIVE_RES, 'LIVE_INP')

        print('res1: ', r1)
        print('res2: ', r2)
