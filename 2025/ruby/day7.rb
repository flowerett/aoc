#!/usr/bin/env ruby

# frozen_string_literal: true

tdata = <<~TDATA
  .......S.......
  ...............
  .......^.......
  ...............
  ......^.^......
  ...............
  .....^.^.^.....
  ...............
  ....^.^...^....
  ...............
  ...^.^...^.^...
  ...............
  ..^...^.....^..
  ...............
  .^.^.^.^.^...^.
  ...............
TDATA

data = File.read('../inputs/day7').strip

def parse(raw)
  raw.split("\n").map(&:chars)
end

def solve(raw)
  dd = parse(raw)
  h = dd.size - 1
  st = dd.first.index('S')

  splits = 0
  times = Hash.new(0).tap { |t| t[st] = 1 }

  (1..h).each do |i|
    splits, times = step(dd, i, splits, times)
  end

  [splits, times.values.sum]
end

def step(dd, i, splits, times)
  next_times = times.each_with_object(Hash.new(0)) do |(x, t), acc|
    if dd[i][x] == '^'
      splits += 1
      acc[x + 1] += t
      acc[x - 1] += t
    else
      acc[x] += t
    end
  end

  [splits, next_times]
end

pp solve(tdata)
pp solve(data)
