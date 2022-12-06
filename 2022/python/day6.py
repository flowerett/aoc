#! /usr/bin/env python

import minitest
import sys

VERBOSE = sys.argv.pop() in ['-v', '--verbose']


def solve(data):
    return tuning(data, 4), tuning(data, 14)


def tuning(data, win_size):
    for i in range(len(data) - win_size + 1):
        win = set(data[i:i+win_size])
        if len(win) == win_size:
            if VERBOSE:
                print('marker: ', data[i:i+win_size], i+win_size)
            return i+win_size


if __name__ == '__main__':
    test = [
        "mjqjpqmgbljsphdztnvjfqwrcgsmlb",
        "bvwbjplbgvbhsrlpgdmjqwftvncz",
        "nppdvjthqldpwncqszvftbrmjlhg",
        "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg",
        "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"
    ]
    LIVE_INP = '../inputs/day6'
    TEST_RES = [(7, 19), (5, 23), (6, 23), (10, 29), (11, 26)]
    LIVE_RES = (1625, 2250)

    with open(LIVE_INP) as f:
        data = f.read().strip()

        for ind, tdata in enumerate(test):
            minitest.assert_all(
                solve(tdata), TEST_RES[ind], f'TEST_INP: {ind+1}')

        r1, r2 = solve(data)

        minitest.assert_all((r1, r2), LIVE_RES, 'LIVE_INP')

        print('res1: ', r1)
        print('res2: ', r2)
