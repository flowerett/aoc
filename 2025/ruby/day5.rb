#!/usr/bin/env ruby

# frozen_string_literal: true

tdata = <<~TDATA
  3-5
  10-14
  16-20
  12-18

  1
  5
  8
  11
  17
  32
TDATA

data = File.read('../inputs/day5').strip


def parse(data)
  ranges_str, ids_str = data.split("\n\n")
  ranges = ranges_str.split.map { |r| r.split('-').map(&:to_i) }
  ids = ids_str.split.map(&:to_i)
  [ranges, ids]
end

def solve(data)
  ranges, ids = data
  merged = merge_ranges(ranges)

  r1 = ids.filter { |id| fresh(merged, id) }.count
  r2 = count_ranges(merged)

  [r1, r2]
end

def fresh(ranges, id)
  ranges.any? { |(st, en)| st <= id && id <= en }
end

def merge_ranges(ranges)
  sorted = ranges.sort_by { |(st, _en)| st }

  sorted.reduce([]) do |acc, (st2, en2)|
    st1, en1 = acc.last

    # since inputs are sorted by start we just check if next range starts
    # before (or exactly when) previous range ends (plus one for simple adjacency)
    if st1 && en1 && st2 <= en1 + 1
      # acc can be mutated in place or
      # acc.pop
      # acc << [st1, [en1, en2].max]
      acc[-1] = [st1, [en1, en2].max]
    else
      acc << [st2, en2]
    end
    acc
  end
end

def count_ranges(ranges)
  ranges.sum { |(st, en)| en - st + 1 }
end

# [3, 14]
pdata = parse(tdata)
pp solve(pdata)

# [821, 344771884978261]
pdata = parse(data)
pp solve(pdata)
