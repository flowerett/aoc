#! /usr/bin/env python

import minitest

# T1
# A for Rock, B for Paper, and C for Scissors
# X for Rock, Y for Paper, and Z for Scissors

R1 = {
    'A': {'Y': 'win', 'X': 'draw', 'Z': 'lose'},
    'B': {'Z': 'win', 'Y': 'draw', 'X': 'lose'},
    'C': {'X': 'win', 'Z': 'draw', 'Y': 'lose'}
}

# Score T1 - outcome of the round
# (0 if you lost, 3 if the round was a draw, and 6 if you won
OUTCOME = {'lose': 0, 'draw': 3, 'win': 6}

# (1 for Rock, 2 for Paper, and 3 for Scissors)
SCORE = {'X': 1, 'Y': 2, 'Z': 3}

# Score T2:
# X means you need to lose,
# Y means you need to end the round in a draw,
# and Z means you need to win.
R2 = {'X': 'lose', 'Y': 'draw', 'Z': 'win'}
T2 = {
    'win': {'A': 'Y', 'B': 'Z', 'C': 'X'},
    'draw': {'A': 'X', 'B': 'Y', 'C': 'Z'},
    'lose': {'A': 'Z', 'B': 'X', 'C': 'Y'}
}


def solve(rows):
    dd = [row.split() for row in rows]

    t1, t2 = 0, 0
    for row in dd:
        elf, me = row

        res1 = R1[elf][me]
        s1 = OUTCOME[res1] + SCORE[me]
        t1 += s1

        res2 = R2[me]
        my_draw = T2[res2][elf]
        s2 = OUTCOME[res2] + SCORE[my_draw]
        t2 += s2

    return t1, t2


if __name__ == '__main__':
    TEST_INP = """
    A Y
    B X
    C Z
    """
    LIVE_INP = '../inputs/day2'
    TEST_RES = (15, 12)
    LIVE_RES = (12772, 11618)

    tdata = TEST_INP.strip().split("\n")
    minitest.assert_all(solve(tdata), TEST_RES, 'TEST_INP')

    with open('../inputs/day2') as f:
        data = f.read().strip().split('\n')

        r1, r2 = solve(data)
        minitest.assert_all((r1, r2), LIVE_RES, 'LIVE_INP')

        print('res1: ', r1)
        print('res2: ', r2)
