#! /usr/bin/env python

import minitest
import sys
import operator as op
import copy as cp
from math import gcd

VERBOSE = sys.argv.pop() in ['-v', '--verbose']

OPS = {'+': op.add, '-': op.sub, '*': op.mul, '/': op.truediv}

# math trick of the day:
#
# 23 % 23 == 0
# 230 % 23 == 0
# 190 % 19 == 0
# 23 * 19 == 437 - main modulo
# won't affect small nums:
# 230 % 437 = 230
# 190 % 437 = 190
# bigger numbers will be reduced
# 460 % 437 = 23
# but the next mod op will still be correct
# 23 % 23 == 0


def solve(data):
    mks = {}
    for row in data:
        extract(row, mks)

    # python mutates the input
    mks2 = cp.deepcopy(mks)

    return task1(mks), task2(mks2)


def task1(mks):
    for _i in range(20):
        for ind, m in mks.items():
            mks = do_pass(mks, m, ind, None)

    out(mks)

    return get_res(mks)


def task2(monkeys):
    divisors = 1
    for m in monkeys.values():
        divisors *= m['dby']

    if VERBOSE:
        print('divisors', divisors)

    for _i in range(10000):
        for ind, m in monkeys.items():
            monkeys = do_pass(monkeys, m, ind, divisors)

    out(monkeys)
    return get_res(monkeys)


def get_res(monkeys):
    cnt = [m['cnt'] for m in monkeys.values()]
    if VERBOSE:
        print('all counters:', cnt)
    a, b = sorted(cnt, reverse=True)[:2]
    return a * b


def do_pass(mks, m, ind, divisors):
    ift, iff = m['ift'], m['iff']

    while m['items']:
        el = m['items'].pop(0)
        item = do_worry(m, el, divisors)

        idx = ift if (item % m['dby'] == 0) else iff
        mks[idx]['items'].append(item)

        mks[ind]['cnt'] += 1

    return mks


def do_worry(m, item, divisors):
    nxt = item if m['nxt'] == 'old' else int(m['nxt'])
    divisor = divisors or 3
    # % - p2, // - p1
    relief_op = op.mod if divisors else op.floordiv

    new = m['op'](item, nxt)
    new = relief_op(new, divisor)
    return new


def extract(part, m):
    el = [l.split() for l in part.split('\n')]

    key = int(el[0][1].strip(':'))
    items = [int(it.strip(',')) for it in el[1][2:]]
    # better to eval:
    # op = eval("lambda old:" + "old * 7")
    # and then call like: op(123)
    op, nxt = el[2][4:]
    dby = int(el[3][-1])
    ift = int(el[4][-1])
    iff = int(el[5][-1])

    m[key] = {
        'items': items,
        'op': OPS[op],
        'nxt': nxt,
        'dby': dby,
        'ift': ift,
        'iff': iff,
        'cnt': 0
    }


def out(mks):
    if VERBOSE:
        print('final:')
        for ind, m in mks.items():
            print(ind, m['cnt'], m['items'])


if __name__ == '__main__':
    TEST_INP = """
  Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

  Monkey 1:
    Starting items: 54, 65, 75, 74
    Operation: new = old + 6
    Test: divisible by 19
      If true: throw to monkey 2
      If false: throw to monkey 0

  Monkey 2:
    Starting items: 79, 60, 97
    Operation: new = old * old
    Test: divisible by 13
      If true: throw to monkey 1
      If false: throw to monkey 3

  Monkey 3:
    Starting items: 74
    Operation: new = old + 3
    Test: divisible by 17
      If true: throw to monkey 0
      If false: throw to monkey 1
  """
    LIVE_INP = '../inputs/day11'
    TEST_RES = (10605, 2713310158)
    LIVE_RES = (61503, 14081365540)

    with open(LIVE_INP) as f:
        data = f.read().strip().split('\n\n')

    tdata = TEST_INP.strip().split("\n\n")
    minitest.assert_all(solve(tdata), TEST_RES, 'TEST_INP')

    r1, r2 = solve(data)
    minitest.assert_all((r1, r2), LIVE_RES, 'LIVE_INP')

    print('res1: ', r1)
    print('res2: ', r2)
