#! /usr/bin/env python

import minitest
import sys

VERBOSE = sys.argv.pop() in ['-v', '--verbose']
KEY = 811589153


class Node:
    def __init__(self, n) -> None:
        self.v = n
        self.left = None
        self.right = None


def solve(data):
    di = [int(i.strip()) for i in data]
    size = len(di)

    r1 = task1(di, size)
    r2 = task2(di, size)

    return r1, r2


def task2(di, size):
    d2 = [i*KEY for i in di]
    nodes = num_to_nodes(d2)

    for _i in range(10):
        zero = majic_mix(nodes, size-1)

    return grove_coord(zero)


def task1(di, size):
    nodes = num_to_nodes(di)
    # with N % len(size) we reach the same position
    # so need to skip it => hence size-1
    zero = mix(nodes, size-1)

    if VERBOSE:
        show(zero, min(size, 10))

    return grove_coord(zero)


def mix(nodes, rsize):
    for n in nodes:
        if n.v == 0:
            zero = n
            continue

        cur = n
        if n.v < 0:
            for i in range(abs(n.v) % rsize):
                cur = cur.left
        else:
            for i in range(abs(n.v) % rsize):
                cur = cur.right

        if cur == n:
            continue

        # for negative N should insert to to left
        # so just move one more to insert to the right
        if n.v < 0:
            cur = cur.left

        insert_right(cur, n)

    return zero


def majic_mix(nodes, rsize):
    """
    same as mix above but with majic % trick:
    having list like [4, -2, 5, 6, 7, 8, 9], moving '-2'
    -(-2) % (7-1) = -2 | moving left 2 times, insert on the left
    is the same as:
    -2 % 6 = 4 | moving right 4 times and insert on the right

    """
    for n in nodes:
        if n.v == 0:
            zero = n
            continue

        cur = n
        for i in range(n.v % rsize):
            cur = cur.right

        if cur == n:
            continue

        insert_right(cur, n)

    return zero


def insert_right(cur, n):
    old_l, old_r = n.left, n.right
    new_r = cur.right

    # disconnect n, connect place of deletion
    old_l.right = old_r
    old_r.left = old_l

    # insert node to the right of cur
    n.left = cur
    n.right = new_r
    cur.right = n
    new_r.left = n


def num_to_nodes(di):
    nodes = [Node(i) for i in di]

    for i in range(0, len(di)):
        nodes[i-1].right = nodes[i]
        nodes[i].left = nodes[i-1]

    return nodes


def grove_coord(n):
    res = 0
    for _i in range(3):
        for _j in range(1000):
            n = n.right
        res += n.v

    return res


def show(n, lim):
    cur1 = cur2 = n
    a1, a2 = [], []
    for i in range(lim):
        a1.append(cur1.v)
        a2.append(cur2.v)
        cur1 = cur1.right
        cur2 = cur2.left
    print('>>>', a1)
    a2.reverse()
    print(a2, '<<<')


if __name__ == '__main__':
    TEST_INP = """
    1
    2
    -3
    3
    -2
    0
    4
    """

    T2 = """
    0
    -10
    2
    -3
    3
    -2
    1
    4
    """

    LIVE_INP = '../inputs/day20'
    TEST_RES = (3, 1623178306)
    LIVE_RES = (9945, 3338877775442)

    with open(LIVE_INP) as f:
        data = f.read().strip().split('\n')

    tdata = TEST_INP.strip().split('\n')

    minitest.assert_all(solve(tdata), TEST_RES, 'TEST_INP')

    r1, r2 = solve(data)

    minitest.assert_all((r1, r2), LIVE_RES, 'LIVE_INP')

    print('res1: ', r1)
    print('res2: ', r2)
