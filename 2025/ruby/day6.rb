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

  blocks = data
    .map { |row| row.split.map(&:to_i) }
    .transpose

  calc_sum(blocks, ops)
end

def solve2(raw)
  data, ops = parse(raw)

  blocks = data
    .map(&:chars)
    .transpose
    .map { |col| col.join.to_i } # column delimiters are all blank ' '.to_i -> 0
    .slice_before(0) # we split by 0
    # reject 0s, it works as I don't have zeros in the input
    # othewise we should use chunk method but it will require more manipulations
    .map { |block| block.reject(&:zero?) }

  calc_sum(blocks, ops)
end

def calc_sum(blocks, ops)
  blocks.zip(ops).map { |nums, op| nums.reduce(op.to_sym) }.sum
end

pp solve1(tdata)
pp solve2(tdata)

pp solve1(data)
pp solve2(data)
