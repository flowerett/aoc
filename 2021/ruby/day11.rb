#! /usr/bin/env ruby
# require "set"
require_relative "nanotest"

input = <<INPUT
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526
INPUT

# input = <<INPUT
# 11111
# 19991
# 19191
# 19991
# 11111
# INPUT

# [[-1,-1], [-1,0], [-1,1], [0,-1], [0,1], [1,-1], [1,0], [1,1]]
MOD = (-1..1).to_a
ADJ = MOD.product(MOD).reject { |a, b| a == 0 && b == 0 }

VERBOSE = ARGV.delete("-v")

def prep_data(input)
  input.strip.split("\n").map do |row|
    row.split("").map do |el|
      [el.to_i, true]
    end
  end
end

def reset_flash(d)
  d.each_with_index do |row, i|
    row.each_with_index do |_el, j|
      d[i][j][1] = true
    end
  end
end

def flash(i, j, d, fcount)
  d[i][j][0] += 1 if d[i][j][1]

  if d[i][j][0] > 9 and d[i][j][1]
    d[i][j][1] = false
    fcount += 1
    adj(i, j).each do |ii, jj|
      fcount = flash(ii, jj, d, fcount)
    end
  end
  d[i][j][0] = 0 if d[i][j][0] > 9

  fcount
end

def adj(i, j)
  ADJ.map { |x, y| [i + x, j + y] }
    .reject { |x, y| x < 0 || x > H || y < 0 || y > L }
end

def run(d, fcount)
  d.each_with_index do |row, i|
    row.each_with_index do |_el, j|
      fcount = flash(i, j, d, fcount)
    end
  end

  reset_flash(d)
  fcount
end

def show(d)
  d.each do |row|
    row.each do |x, f|
      num = x == 0 ? "#{x}".white.bold : "#{x}".brown.bold
      print(num)
    end
    print("\n")
  end
  puts "\e[0m"
end

def sync?(d)
  d.all? do |r|
    r.all? { |e, _f| e.zero? }
  end
end

#T1 - count flashes for 100 steps
def run1(d)
  fcount = 0

  if VERBOSE
    print "T1 - START ===\n\n"
    show(d)
  end

  STEPS_T1.times do |s|
    fcount = run(d, fcount)

    if VERBOSE && (s + 1) % 10 == 0
      print "AFTER #{s + 1} ===\n\n"
      show(d)
    end
  end

  fcount
end

# T2 find when flashes sync
def run2(d)
  steps = STEPS_T1

  until sync?(d)
    run(d, 0)
    steps += 1
  end

  if VERBOSE
    print "\nT2 - Sync at #{steps} ===\n"
    show(d)
  end

  steps
end

if $0 == __FILE__
  d = prep_data(input)
  H = d.size - 1
  L = d.first.size - 1
  STEPS_T1 = 100

  # test
  rt = [run1(d), run2(d)]

  # real
  input = File.read("../inputs/day11")
  d = prep_data(input)
  my = [run1(d), run2(d)]

  t = NanoTest.new("test")

  Utils.day(2021, 11)
  Utils.pp(rt)

  t.assert_all(rt, [1656, 195])

  Utils.pp(my)
  t.assert_all(my, [1755, 212], "task")
end
