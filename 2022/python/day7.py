#! /usr/bin/env python

import minitest
import sys

from collections import defaultdict
# initialize dict with free start element:
# defaultdict(lambda: ({}, 0))

VERBOSE = sys.argv.pop() in ['-v', '--verbose']


def solve(data):
    dd = [row.strip().split() for row in data]

    dirs, cur = defaultdict(int), []

    for row in dd:
        dirs, cur = traverse(row, dirs, cur)

    if VERBOSE:
        print(*dd, sep='\n')
        print(dirs)

    return task1(dirs), task2(dirs)


def task1(dirs):
    sum = 0
    for v in dirs.values():
        if v <= 100_000:
            sum += v
    return sum


def task2(dirs):
    total = dirs[('/',)]
    space = 70_000_000
    to_free = 30_000_000 - (70_000_000 - total)

    min_to_del = space
    for v in dirs.values():
        if v >= to_free and v < min_to_del:
            min_to_del = v

    return min_to_del


def traverse(cmd, dirs, cur):
    # $ cd ..
    if cmd[1] == 'cd' and cmd[2] == '..':
        cur.pop()
    # $ cd X
    elif cmd[1] == 'cd':
        cur.append(cmd[2])
    # not '$ ls' or 'dir X' which we skip
    elif (cmd[1] != 'ls') and (cmd[0] != 'dir'):
        fsize, _fname = cmd
        size = int(fsize)
        dirs = add_to_dirs(dirs, cur, size)

    return dirs, cur


def add_to_dirs(dirs, path, size):
    for i in range(1, len(path)+1):
        key = tuple(path[:i])
        dirs[key] += size
    return dirs


if __name__ == '__main__':
    TEST_INP = """
  $ cd /
  $ ls
  dir a
  14848514 b.txt
  8504156 c.dat
  dir d
  $ cd a
  $ ls
  dir e
  29116 f
  2557 g
  62596 h.lst
  $ cd e
  $ ls
  584 i
  $ cd ..
  $ cd ..
  $ cd d
  $ ls
  4060174 j
  8033020 d.log
  5626152 d.ext
  7214296 k
  """
    LIVE_INP = '../inputs/day7'
    TEST_RES = (95437, 24933642)
    LIVE_RES = (1453349, 2948823)

    with open(LIVE_INP) as f:
        data = f.read().strip().split('\n')

    tdata = TEST_INP.strip().split("\n")
    minitest.assert_all(solve(tdata), TEST_RES, 'TEST_INP')

    r1, r2 = solve(data)
    minitest.assert_all((r1, r2), LIVE_RES, 'LIVE_INP')

    print('res1: ', r1)
    print('res2: ', r2)
