#! /usr/bin/env python

'''
t1 - O(n)
x + y = 2020

t2 - O(n^2)
x + y + z = 2020
'''
import itertools
import minitest


def solve(data):
    data = [int(x) for x in data]
    # print('inp1t:', data)

    count, prev = 0, None

    # t1
    for v in data:
        if prev and prev < v:
            count += 1
        prev = v

    # print('res1:', count)
    res1 = count

    # t2
    count, prev = 0, None
    for i in range(len(data)-2):
        v = sum(data[i:i+3])
        if prev and prev < v:
            count += 1
        prev = v

    # print('res2:', count)
    res2 = count

    return res1, res2


if __name__ == '__main__':
    TEST_INP = '../inputs/day1t'
    TEST_RES = (7, 5)

    with open(TEST_INP) as f:
        data = f.read().strip().split('\n')
        minitest.assert_all(solve(data), TEST_RES, 'TEST_INP')

    DAY1_RES = (1448, 1471)
    with open('../inputs/day1', 'r') as f:
        data = f.read().strip().split('\n')
        r1, r2 = solve(data)
        minitest.assert_all((r1, r2), DAY1_RES, 'DAY1_INP')

        print('res1: ', r1)
        print('res2: ', r2)
