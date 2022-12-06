#! /usr/bin/env python

import minitest
import hashlib
import itertools as it


def solve(secret):
    r1 = mine(secret, 5)
    r2 = mine(secret, 6)
    return r1, r2


def mine(secret, n):
    print(f'mining for hash with {n} zeros...')

    check = '0'*n
    for i in it.count():
        key = (secret + str(i)).encode()
        h = hashlib.md5(key).hexdigest()[:n]
        if check == h:
            return i


if __name__ == '__main__':
    TEST_INP = "abcdef"

    LIVE_INP = '../inputs/day4'
    TEST_RES = (609043, 6742839)
    LIVE_RES = (282749, 9962624)

    minitest.assert_all(solve(TEST_INP), TEST_RES, 'TEST_INP')

    with open(LIVE_INP) as f:
        data = f.read().strip()

        r1, r2 = solve(data)
        minitest.assert_all((r1, r2), LIVE_RES, 'LIVE_INP')

        print('res1: ', r1)
        print('res2: ', r2)
