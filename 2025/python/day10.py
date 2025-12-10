# pip install numpy scipy
import numpy as np
from scipy.linalg import null_space
from scipy.optimize import Bounds, LinearConstraint, milp

print("=" * 70)
print("LINEAR ALGEBRA TUTORIAL: Particular Solution + Null Space")
print("=" * 70)

print("\n" + "=" * 70)
print("EXAMPLE 1: System with UNIQUE solution (no null space)")
print("=" * 70)

# 3 equations, 3 variables = usually unique solution
A1 = np.array(
    [
        [1, 0, 1],  # button0 + button2 = 3
        [1, 1, 0],  # button0 + button1 = 5
        [0, 1, 1],  # button1 + button2 = 4
    ]
)
target1 = np.array([3, 5, 4])

particular1 = np.linalg.lstsq(A1, target1, rcond=None)[0]
print("Equations:")
print("  button0 + button2 = 3")
print("  button0 + button1 = 5")
print("  button1 + button2 = 4")
print("\nSolution:", particular1, "✓")
print("Null space dimension:", null_space(A1).shape[1])
print("→ Only ONE solution exists!\n")


print("=" * 70)
print("EXAMPLE 2: From AoC-10 test data")
print("=" * 70)
print("Test case: (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}")
print("This means:")
print("  - We have 4 positions (0, 1, 2, 3)")
print("  - Button 0 affects position  [3]")
print("  - Button 1 affects positions [1, 3]")
print("  - Button 2 affects position  [2]")
print("  - Button 3 affects positions [2, 3]")
print("  - Button 4 affects positions [0, 2]")
print("  - Button 5 affects positions [0, 1]")
print("  - Target: position 0→3, position 1→5, position 2→4, position 3→7")

# Build the system
buttons = [[3], [1, 3], [2], [2, 3], [0, 2], [0, 1]]
target2 = np.array([3, 5, 4, 7])
n_positions = 4
n_buttons = 6

# Build matrix A where A[i][j] = 1 if button j affects position i
A2 = np.zeros((n_positions, n_buttons), dtype=float)
for button_idx, positions in enumerate(buttons):
    for pos in positions:
        A2[pos][button_idx] = 1

print("\nMatrix A (position × button):")
print("     B0 B1 B2 B3 B4 B5")
for i in range(n_positions):
    print(f"P{i}: {A2[i].astype(int)}")

print(f"\nTarget: {target2}")

# Find particular solution
particular2 = np.linalg.lstsq(A2, target2, rcond=None)[0]
print(f"\nParticular solution from lstsq: {particular2}")
print(f"  Rounded: {np.round(particular2, 2)}")

# Find null space
null_basis2 = null_space(A2)
print(f"\nNull space dimension: {null_basis2.shape[1]}")

if null_basis2.shape[1] > 0:
    print("\nNull space basis vectors:")
    for i in range(null_basis2.shape[1]):
        vec = null_basis2[:, i]
        print(f"  Vector {i}: {np.round(vec, 3)}")

    # Verify null space
    check = A2 @ null_basis2
    print("\nVerification A·(null_vectors) (should be ~0):")
    print(np.round(check, 10))

    print("\nProblem: Floating-point null space can't find exact integer solutions!")
    print("→ Need exact rational arithmetic OR a constraint solver\n")
else:
    print("\nNo null space!")

print("\n" + "=" * 70)
print("EXAMPLE 3: Using MILP (Mixed Integer Linear Programming)")
print("THE SIMPLE WAY - let scipy.optimize.milp do the work!")
print("=" * 70)

print("\nSame problem as Example 2:")
print("Buttons:", buttons)
print("Target:", target2.tolist())

# Build the constraint matrix
# A[position][button] = 1 if button affects position
A3 = [[pos in btn_positions for btn_positions in buttons] for pos in range(n_positions)]

print("\nConstraint matrix A (same as before):")
print("\nbuttons: B0 B1 B2 B3 B4 B5")

for i, row in enumerate(A3):
    print(f"    P{i}: {[int(x) for x in row]}")

# Objective: minimize sum of all button presses
# c = [1, 1, 1, 1, 1, 1] means we want to minimize x0 + x1 + x2 + x3 + x4 + x5
c = [1] * n_buttons

print(f"\nObjective: minimize {' + '.join([f'x{i}' for i in range(n_buttons)])}")
print("Subject to: A @ x = target")
print("            x >= 0 (all button presses non-negative)")
print("            x must be integers")

# Create constraints: A @ x == target (both lower and upper bounds equal)
constraints = LinearConstraint(A3, lb=target2, ub=target2)

# All variables must be non-negative integers
integrality = [1] * n_buttons  # 1 means integer variable

print("\nSolving with scipy.optimize.milp...")
result = milp(
    c=c, constraints=constraints, integrality=integrality, bounds=Bounds(0, np.inf)
)

if result.success:
    solution = result.x.astype(int)
    total = int(result.fun)

    print(f"\n{'=' * 70}")
    print(f"MILP SOLUTION: {total} total button presses")
    print(f"{'=' * 70}")
    print(f"Solution: {solution}")
    for i, presses in enumerate(solution):
        print(f"  Button {i} (affects {buttons[i]}): press {presses} times")

    print("\nVerification:")
    for pos in range(n_positions):
        actual = sum(solution[btn] for btn in range(n_buttons) if pos in buttons[btn])
        print(
            f"  Position {pos}: {actual} presses (target: {target2[pos]}) {'✓' if actual == target2[pos] else '✗'}"
        )

    print("\n" + "=" * 70)
    print("With MILP:")
    print("=" * 70)
    print("✓ No floating-point errors")
    print("✓ Handles integer constraints natively")
    print("✓ Automatically finds the minimum")
else:
    print("\nMILP solver failed:", result.message)
