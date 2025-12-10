### Gaussian elimination + null space search
Explanation using python

Read more:
- [Null Space and Column Space](https://www.khanacademy.org/math/linear-algebra/vectors-and-spaces/null-column-space/v/null-space-and-column-space-basis)
- [Introduction to Linear Equations](https://wordsandbuttons.online/programmers_introduction_to_linear_equations.html)
- [Linear programming with Python](https://realpython.com/linear-programming-python)

**Problem:** Find button presses for the system:
```
Button 0 affects positions: [0, 1]
Button 1 affects positions: [1, 2]
Button 2 affects positions: [0, 2]

Target: pos 0 needs 3 presses, position 1 needs 5, position 2 needs 4
```

**Formalize task:**
```
Position 0: 1·button0 + 0·button1 + 1·button2 = 3
Position 1: 1·button0 + 1·button1 + 0·button2 = 5
Position 2: 0·button0 + 1·button1 + 1·button2 = 4
Matrix form:
[1 0 1] [button0]   [3]
[1 1 0] [button1] = [5]
[0 1 1] [button2]   [4]
```

**python solution example:**
Some numbers are not correct, but we use them to illustrate the concept.
See full working code in [day10.py](day10.py)

```python
import numpy as np
from scipy.linalg import null_space

# Setup the system
A = np.array([
    [1, 0, 1],  # button0 + button2 = 3
    [1, 1, 0],  # button0 + button1 = 5
    [0, 1, 1]   # button1 + button2 = 4
])
target = np.array([3, 5, 4])

# Find particular solution (using least squares)
particular = np.linalg.lstsq(A, target, rcond=None)[0]
print("Particular solution:", particular)
# Output: [2.5, 2.5, 0.5] - example, not a real solution

# Find null space basis
null_basis = null_space(A)
print("Null space basis:\n", null_basis)
# Output: [[-0.577]
#          [ 0.577]
#          [ 0.577]]
# This means: subtract from button0, add to button1 and button2

# Generate all solutions by combining particular + null space
# solution = particular + t * null_basis (for any value of t)

# To get integer solutions, we need to find the right t
# Let's try different values
for t in range(-10, 10):
    solution = particular + t * null_basis.flatten()
    if all(solution >= 0) and all(abs(solution - np.round(solution)) < 0.001):
        int_solution = np.round(solution).astype(int)
        print(f"Integer solution with t={t}: {int_solution}, sum={int_solution.sum()}")

# Output shows valid solutions:
# t=-4: [5, 0, 3], sum=8
# t=-1: [4, 1, 2], sum=7
# t= 2: [3, 2, 1], sum=6  <- minimum!
```

### Explanation:

1. **Particular Solution**

A **particular solution** is **one specific answer** to the equation (but there might be many other answers).

**Simple Example:**
```
Equation: x + y = 5

Particular solution: x=2, y=3  (one answer)
Other solutions:     x=0, y=5  (another answer)
                     x=1, y=4  (another answer)
                     ... infinite answers!
```

The particular solution is typically found by **setting free variables to 0** and solving for the rest.

2. **Null Space (and Basis)**

The **null space** contains all the ways you can **change your solution while still satisfying the equation**.

**Simple Example:**
```
Equation: x + y = 5

Particular solution: x=2, y=3

Null space: "If I add 1 to x and subtract 1 from y, I still get 5!"
           (2+1) + (3-1) = 5 ✓

Null space vector: [+1, -1]  (add to x, subtract from y)

All solutions = [2, 3] + t·[1, -1]  where t is any number
              = [2+t, 3-t]
```

A **basis** for the null space is a set of vectors that can be combined to make any null space vector. In the example above, `[1, -1]` forms a basis.

**Back to problem solving**

1. **Particular solution** [2.5, 2.5, 0.5] is found (but has fractions)
2. **Null space** tells us we can subtract from button0 and add to button1/button2
3. By trying different combinations (different `t` values), we find integer solutions
4. The minimum sum is **6 button presses**: button0=3, button1=2, button2=1
