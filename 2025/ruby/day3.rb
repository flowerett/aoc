#!/usr/bin/env ruby

# frozen_string_literal: true

tdata = <<~TDATA
  987654321111111
  811111111111119
  234234234234278
  818181911112111
TDATA

data = File.read('../inputs/day3').strip

def parse(data)
  data.split.map do |row|
    row.chars.map(&:to_i)
  end
end

def solve(data, num_len)
  row_len = data.first.length-1

  data.map do |row|
    (num_len-1).downto(0).reduce([0, 0]) do |(res, st), i|
      # get max left digit in subarray (max value, leftmost position)
      dig, pos = row[st..row_len-i].each_with_index.max_by { |d, idx| [d, -idx] }

      # next position from new digit: previous start position + position in subarray + 1
      [res + dig*10**i, st+pos+1]
    end.first
  end.sum
end

# 357
# 3121910778619
pdata = parse(tdata)
pp solve(pdata, 2)
pp solve(pdata, 12)

# 17343
# 172664333119298
pdata = parse(data)
pp solve(pdata, 2)
pp solve(pdata, 12)
