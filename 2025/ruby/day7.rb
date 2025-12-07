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
  raw.split("\n").map { |row| row.chars.map { |c| c == "." ? 0 : c } }
end

def solve(raw)
  dd = parse(raw)
  h = dd.size-1

  st = dd.first.index('S')
  cur = Set.new([[0, st]])
  splits = 0
  dd[0][st] = 1

  (1..h).reduce(cur) do |acc, i|
    acc.reduce(Set.new) do |acc, (y, x)|
      if dd[i][x] == "^"
        dd[i][x-1] += dd[i-1][x]
        dd[i][x+1] += dd[i-1][x]
        acc << [i, x-1]
        acc << [i, x+1]
        splits += 1
      else
        dd[i][x] += dd[i-1][x]
        acc << [i, x]
      end
      acc
    end
  end

  [splits, dd[h].sum]
end

pp solve(tdata)
pp solve(data)
