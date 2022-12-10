#! /usr/bin/env python

import minitest
import sys

VERBOSE = sys.argv.pop() in ['-v', '--verbose']


def solve(data):
    dd = map(extract, data)

    # reg, cnt, pwr, scr
    state = (1, 0, 0, [' ']*240)

    for cmd in dd:
        match cmd:
            case ['noop']:
                state = do_cycle(state)

            case 'addx', x:
                state = do_cycle(state)
                state = do_cycle(state)
                state = add_x(state, x)

    r1 = state[2]
    r2 = [''.join(row) for row in chunk(state[3])]

    return r1, r2


def print_screen(crt):
    # print(f'r1 {r1}')
    print(f'res2: {"-"*40}')
    for ind, line in enumerate(crt):
        print(line, f'| row: {(ind+1)*40}')


def do_cycle(state):
    reg, cnt, pwr, scr = state

    scr[cnt] = pixel_state(cnt, reg)
    cnt += 1
    pwr += get_power(cnt, reg)

    return (reg, cnt, pwr, scr)


def add_x(state, snum):
    reg, cnt, pwr, scr = state
    reg += int(snum.strip())
    return reg, cnt, pwr, scr


def get_power(cnt, reg):
    return cnt * reg if (cnt % 40 == 20) else 0


def pixel_state(cnt, reg):
    return (reg-1 <= cnt % 40 <= reg+1) and '#' or ' '


def chunk(enum, n=40):
    for i in range(0, len(enum), n):
        yield enum[i:i+n]


def extract(row):
    return row.strip().split()


if __name__ == '__main__':
    TEST_INP = '../inputs/day10t'
    LIVE_INP = '../inputs/day10'
    TEST_RES = 13140
    LIVE_RES = 13520

    with open(TEST_INP) as f:
        tdata = f.read().strip().split('\n')

    with open(LIVE_INP) as f:
        data = f.read().strip().split('\n')

    tres, _tcrt = solve(tdata)
    minitest.assert_one(tres, TEST_RES, 'TEST_INP')

    res, crt = solve(data)
    minitest.assert_one(res, LIVE_RES, 'LIVE_INP')

    print('res1: ', res)
    print_screen(crt)
