def assert_one(res, solution, name):
    test_res = '.' if res == solution else 'X'
    print(f'Running tests, {name}: {test_res}')


def assert_all(res, solution, name=''):
    print(f'Running tests for all results in {name} ...')
    test_res = ['.' if r == solution[i] else 'X' for i, r in enumerate(res)]
    print(*test_res)
