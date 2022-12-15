#! /usr/bin/env python

import minitest
import sys
from collections import defaultdict
import re

VERBOSE = sys.argv.pop() in ['-v', '--verbose']

FREQ = 4000000


def solve(data, inp='test', debug=False):
    dd = [format(row) for row in data]

    r1 = task1(dd, inp)
    x, y = task2(dd, inp, debug)
    r2 = x * FREQ + y

    if debug:
        print("res1 >>>", r1)
        print("res2 >>>", x, y, r2)
    return r1, r2


# 3_200_000 to speedup runtime as I know the answer is there
# should be 0 otherwise
DTT = (0, 20)
DTL = (3_200_000, 4_000_000)


def task2(dd, inp, debug):
    dtmin, dtmax = DTT if inp == 'test' else DTL
    for yy in range(dtmin, dtmax+1):
        if debug and yy % 100_000 == 0:
            print('processing :', yy)

        intervals = build_intervals_for_row(dd, yy)
        q = merge_intervals(intervals)

        x = q[0][0]
        for xmin, xmax in q:
            if x < xmin:
                return x, yy
            x = max(x, xmax + 1)
            if x > dtmax:
                break


YT = 10
YL = 2_000_000


def task1(dd, inp):
    yy = YT if inp == 'test' else YL

    intervals = build_intervals_for_row(dd, yy)
    sensors = collect_sensors_in_row(dd, yy)
    q = merge_intervals(intervals)

    covered = set()

    for xmin, xmax in q:
        sub = set(range(xmin, xmax+1))
        covered = covered.union(sub)

    return len(covered - sensors)


def build_intervals_for_row(dd, yy):
    intervals = []

    for xs, ys, xb, yb in dd:
        md = abs(xs-xb) + abs(ys-yb)

        off = md - abs(ys - yy)
        if off < 0:
            continue

        xmin = xs - off
        xmax = xs + off
        intervals.append([xmin, xmax])

    return sorted(intervals)


def collect_sensors_in_row(dd, yy):
    sensors = set()
    for xs, ys, xb, yb in dd:
        if yb == yy:
            sensors.add(xb)
        if ys == yy:
            sensors.add(xs)

    return sensors


def merge_intervals(groups):
    groups.sort()
    q = [groups[0]]

    for xmin, xmax in groups:
        qmax = q[-1][1]
        if xmin > qmax + 1:
            q.append([xmin, xmax])
            continue

        q[-1][1] = max(qmax, xmax)

    return q


REGEX = r'(-?\d+)'


def format(row):
    rdata = re.findall(REGEX, row)
    return list(map(int, rdata))


if __name__ == '__main__':
    TEST_INP = """
    Sensor at x=2, y=18: closest beacon is at x=-2, y=15
    Sensor at x=9, y=16: closest beacon is at x=10, y=16
    Sensor at x=13, y=2: closest beacon is at x=15, y=3
    Sensor at x=12, y=14: closest beacon is at x=10, y=16
    Sensor at x=10, y=20: closest beacon is at x=10, y=16
    Sensor at x=14, y=17: closest beacon is at x=10, y=16
    Sensor at x=8, y=7: closest beacon is at x=2, y=10
    Sensor at x=2, y=0: closest beacon is at x=2, y=10
    Sensor at x=0, y=11: closest beacon is at x=2, y=10
    Sensor at x=20, y=14: closest beacon is at x=25, y=17
    Sensor at x=17, y=20: closest beacon is at x=21, y=22
    Sensor at x=16, y=7: closest beacon is at x=15, y=3
    Sensor at x=14, y=3: closest beacon is at x=15, y=3
    Sensor at x=20, y=1: closest beacon is at x=15, y=3
    """
    LIVE_INP = '../inputs/day15'
    TEST_RES = (26, 56000011)
    LIVE_RES = (5832528, 13360899249595)

    with open(LIVE_INP) as f:
        data = f.read().strip().split('\n')

    tdata = TEST_INP.strip().split('\n')
    minitest.assert_all(
        solve(tdata, inp='test', debug=VERBOSE), TEST_RES, 'TEST_INP')

    r1, r2 = solve(data, inp='live')
    minitest.assert_all((r1, r2), LIVE_RES, 'LIVE_INP')

    print('res1: ', r1)
    print('res2: ', r2)
