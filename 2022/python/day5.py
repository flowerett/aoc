#! /usr/bin/env python

import minitest
import sys
import re
import copy

VERBOSE = sys.argv.pop() in ['-v', '--verbose']


def solve(raw, crates):
    p1, p2 = raw.split('\n\n')
    data = [row.strip() for row in p2.split('\n')]
    print('crates:\n', p1)

    cr1 = copy.deepcopy(crates)
    cr2 = copy.deepcopy(crates)

    for row in data:
        cmd = fmt(row)

        # t1
        cr1 = move_t1(cr1, cmd)

        # t2
        cr2 = move_t2(cr2, cmd)

    return to_msg(cr1), to_msg(cr2)


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
    TEST_INP = """
        [D]
    [N] [C]
    [Z] [M] [P]
    1   2   3

    move 1 from 2 to 1
    move 3 from 1 to 3
    move 2 from 2 to 1
    move 1 from 1 to 2
    """
    LIVE_INP = '../inputs/day5'
    TEST_RES = ('CMZ', 'MCD')
    LIVE_RES = ('QNHWJVJZW', 'BPCZJLFJW')

    # didn't find a faster way of parsing it
    tcrates = [['Z', 'N'], ['M', 'C', 'D'], ['P']]
    crates = [
        ["C", "Z", "N", "B", "M", "W", "Q", "V"],
        ["H", "Z", "R", "W", "C", "B"],
        ["F", "Q", "R", "J"],
        ["Z", "S", "W", "H", "F", "N", "M", "T"],
        ["G", "F", "W", "L", "N", "Q", "P"],
        ["L", "P", "W"],
        ["V", "B", "D", "R", "G", "C", "Q", "J"],
        ["Z", "Q", "N", "B", "W"],
        ["H", "L", "F", "C", "G", "T", "J"]
    ]

    with open(LIVE_INP) as f:
        data = f.read().strip()
        tdata = TEST_INP.strip()

        minitest.assert_all(solve(tdata, tcrates), TEST_RES, 'TEST_INP')

        r1, r2 = solve(data, crates)
        minitest.assert_all((r1, r2), LIVE_RES, 'LIVE_INP')

        print('res1: ', r1)
        print('res2: ', r2)
