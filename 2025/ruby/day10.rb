#!/usr/bin/env ruby
# rubocop:disable all
# frozen_string_literal: true

# brew install z3
# gem install z3
require 'z3'

tdata = <<~TDATA
  [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
  [...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
  [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
TDATA

data = File.read('../inputs/day10').strip

def parse(input)
  input.split("\n").map { |row| row.split }.map do |el|
    diagram = el.first.tr('[]', '').chars.map { |c| c == '#' }
    buttons = el[1..-2].map { |b| b.tr('()', '').split(',').map(&:to_i) }
    req = el[-1].tr('{}', '').split(',').map(&:to_i)

    [diagram, buttons, req]
  end
end

def task1(diagram, buttons)
  # convert diagram to bitmask (1 = on, 0 = off)
  initial_state = diagram.each_with_index.sum { |on, i| on ? (1 << i) : 0 }
  target = 0 # all off

  # convert buttons to bitmasks
  masks = buttons.map do |btn|
    btn.sum { |pos| 1 << pos }
  end

  # BFS
  visited = { initial_state => 0 }
  queue = [[initial_state, 0]]

  while !queue.empty?
    state, presses = queue.shift

    return presses if state == target

    masks.each do |mask|
      # XOR - toggle the bits corresponding to the button
      new_state = state ^ mask
      next if visited.key?(new_state)

      visited[new_state] = presses + 1
      queue << [new_state, presses + 1]
    end
  end

  Float::INFINITY # no solution
end

def task2_slow(target, buttons)
  init_state = [0]*target.length
  visited = { init_state => 0 }
  queue = [[init_state, 0]]

  while !queue.empty?
    state, presses = queue.shift

    return presses if state == target

    buttons.each do |btn|
      new_state = state.dup
      btn.each_with_index do |pos, idx|
        new_state[pos] += 1
      end

      next if visited.key?(new_state)

      visited[new_state] = presses + 1
      queue << [new_state, presses + 1]
    end
  end
end

# Gaussian elimination + null space search (ILP)
# see ../python/day10.md
def task2_ilp(target, buttons)
  n_rows = target.length
  n_cols = buttons.length

  # build augmented matrix [A | target] using rationals
  # A[i][j] = 1 if button j affects position i
  matrix = Array.new(n_rows) do |row|
    cols = buttons.map { |btn| btn.include?(row) ? 1.to_r : 0.to_r }
    cols << target[row].to_r
    cols
  end

  # Gauss-Jordan elimination to row-echelon form
  pivots = {}  # col -> row mapping for pivot positions
  pivot_row = 0

  n_cols.times do |col|
    break if pivot_row >= n_rows

    # find pivot (first non-zero in this column)
    pivot = (pivot_row...n_rows).find { |r| matrix[r][col] != 0 }
    next unless pivot

    # swap rows and record pivot
    matrix[pivot_row], matrix[pivot] = matrix[pivot], matrix[pivot_row]
    pivots[col] = pivot_row

    # normalize pivot row
    divisor = matrix[pivot_row][col]
    (col..n_cols).each { |k| matrix[pivot_row][k] /= divisor }

    # eliminate column in all other rows
    n_rows.times do |r|
      next if r == pivot_row || matrix[r][col] == 0
      factor = matrix[r][col]
      (col..n_cols).each { |k| matrix[r][k] -= factor * matrix[pivot_row][k] }
    end

    pivot_row += 1
  end

  # extract particular solution (free variables = 0)
  particular = Array.new(n_cols, 0.to_r)
  pivots.each { |col, row| particular[col] = matrix[row][n_cols] }

  # build null space basis (one vector per free variable)
  free_vars = (0...n_cols).to_a - pivots.keys
  null_basis = free_vars.map do |free_col|
    basis = Array.new(n_cols, 0.to_r)
    basis[free_col] = 1.to_r
    pivots.each { |piv_col, piv_row| basis[piv_col] = -matrix[piv_row][free_col] }
    basis
  end

  # convert to integers (scale by LCM of denominators)
  lcm = 1
  (particular + null_basis.flatten).each { |x| lcm = x.denominator.lcm(lcm) }

  int_particular = particular.map { |x| (x * lcm).to_i }
  int_null_basis = null_basis.map { |vec| vec.map { |x| (x * lcm).to_i } }

  # search for minimum sum solution (particular + combination of null basis)
  min_sum = Float::INFINITY
  limit = 250
  n_free = free_vars.length

  search = lambda do |idx, current|
    # if any position is negative and can't recover, abort
    if idx > 0
      n_cols.times do |k|
        next unless current[k] < 0
        # this position can recover only if a future basis vector has positive value at k
        can_recover = (idx...n_free).any? { |fi| int_null_basis[fi][k] > 0 }
        return unless can_recover
      end
    end

    if idx == n_free
      if current.all? { |x| x >= 0 && x % lcm == 0 }
        sum = current.sum / lcm
        min_sum = sum if sum < min_sum
      end
      return
    end

    basis = int_null_basis[idx]
    (0..limit).each do |c|
      next_state = current.map.with_index { |x, i| x + c * basis[i] }
      search.call(idx + 1, next_state)
    end
  end

  search.call(0, int_particular)
  min_sum
end

# https://riffraff.info/2023/02/solving-advent-of-code-day-21-using-z3-and-ruby/
def task2_z3(target, buttons)
  # we need Z3::Optimize as it supports minimization
  solver = Z3::Optimize.new

  # create Z3 integer variables for each button
  # they represent number of presses
  z3items = buttons.each_with_index.map { |_n, i| Z3.Int("b#{i}") }

  # add constraints: button presses >= 0
  z3items.each {|z3i| solver.assert(z3i >= 0) }

  # for each target position
  target.each_with_index { |pos, i|
    # find all buttons that affect position i, sum their press counts
    # if buttons 0 and 2 both affect position i, then
    #   z3sum = b0 + b2
    z3sum = z3items
      .zip(buttons)
      .filter { |_z3i, b| b.include?(i) }
      .map { |z3i, _b| z3i }
      .sum

    # add constraint
    # the sum of presses affecting position i must equal target[i]
    solver.assert(pos == z3sum)
  }

  # minimize total button presses
  solver.minimize(z3items.sum)

  # solve
  return z3items.sum { |z3i| solver.model[z3i].to_i } if solver.satisfiable?
  raise "no solution: #{target} - #{buttons}"
end

def solve(raw, verbose = false)
  inp = parse(raw)
  pp "total: #{inp.length}" if verbose

  inp.each_with_index.map do |(diagram, buttons, req), idx|
    pp "step #{idx + 1} ==========" if verbose
    min1 = task1(diagram, buttons)
    # min2 = task2_slow(req, buttons)
    # min2 = task2_ilp(req, buttons)
    min2 = task2_z3(req, buttons)
    [min1, min2]
  end.transpose.map { |task| task.sum }
end

pp solve(tdata)
pp solve(data)
