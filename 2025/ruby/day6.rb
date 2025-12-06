#!/usr/bin/env ruby

# frozen_string_literal: true

# do not remove spaces at the end of each line
# of the test input it is important for part 2
tdata = <<~TDATA
123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +  
TDATA

data = File.read('../inputs/day6').strip

def parse(data)
  dd = data.split("\n")
  ops = dd.pop
  [dd, ops.split]
end

def solve1(raw)
  data, ops = parse(raw)

  parsed = data.map { |row| row.split.map(&:to_i) }.transpose.zip(ops)

  calc_sum(parsed)
end

def solve2(raw)
  data, ops = parse(raw)

  parsed = data.map { |row| row.split('').reverse }
    .transpose
    .map { |col| col.join.to_i }
    .reduce([[],[]]) do |(acc, cur), num|
      if num == 0
        [acc << cur, []]
      else
        [acc, cur << num]
      end
    end
    .then { |(acc, cur)| acc << cur }
    .reverse
    .zip(ops)

  calc_sum(parsed)
end

def calc_sum(blocks)
  blocks.map { |nums, op| nums.reduce(op.to_sym) }.sum
end

pp solve1(tdata)
pp solve2(tdata)

pp solve1(data)
pp solve2(data)
