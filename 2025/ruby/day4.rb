#!/usr/bin/env ruby

# frozen_string_literal: true

tdata = <<~TDATA
  ..@@.@@@@.
  @@@.@.@.@@
  @@@@@.@.@@
  @.@@@@..@.
  @@.@@@@.@@
  .@@@@@@@.@
  .@.@.@.@@@
  @.@@@.@@@@
  .@@@@@@@@.
  @.@.@@@.@.
TDATA

data = File.read('../inputs/day4').strip

DIRS = [
  [-1, -1],
  [-1, 0],
  [-1, 1],
  [0, -1],
  [0, 1],
  [1, -1],
  [1, 0],
  [1, 1]
].freeze

def parse(data)
  papers = Set.new

  data.split.each_with_index do |r, i|
    r.chars.each_with_index do |c, j|
      papers.add([i, j]) if c == '@'
    end
  end

  papers
end

def solve(papers)
  lifted = []

  loop do
    papers, count = lift(papers)
    lifted << count
    break if count == 0
  end

  { r1: lifted[0], r2: lifted.sum }
end

def lift(papers)
  papers.reduce([Set.new, 0]) do |(acc, count), (i, j)|
    if num_nbh(papers, i, j) < 4
      [acc, count + 1]
    else
      [acc.add([i, j]), count]
    end
  end
end

def num_nbh(data, i, j)
  DIRS.count { |di, dj| data.include?([i + di, j + dj]) }
end

pdata = parse(tdata)
pp solve(pdata)

pdata = parse(data)
pp solve(pdata)
