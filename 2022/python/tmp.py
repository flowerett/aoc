#! /usr/bin/env python

import minitest
import sys

VERBOSE = sys.argv.pop() in ['-v', '--verbose']


def solve(data):
  dd = [row.strip() for row in data]

  print(dd)

# def extract(row):
#   print(row)

if __name__ == '__main__':
  TEST_INP = """
  """
  LIVE_INP = '../inputs/dayX'
  TEST_RES = (1, 1)
  LIVE_RES = (1, 1)

  with open(LIVE_INP) as f:
    data = f.read().strip().split('\n')

  # tdata = TEST_INP.strip().split("\n")

  # minitest.assert_all(solve(tdata), TEST_RES, 'TEST_INP')

  _res = solve(data)
  # minitest.assert_all((r1, r2), LIVE_RES, 'LIVE_INP')

  # print('res1: ', r1)
  # print('res2: ', r2)
