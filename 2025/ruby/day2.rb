#!/usr/bin/env ruby

# frozen_string_literal: true

# TIL ^(.+)\1+$ is a greedy match pattern
# (.+) - Capture group that matches one or more characters (the substring)
# \1+ - repeated two or more times
# \1 - repeated exactly two times
# you can use {} to specify duplications:
# - str.match?(/^(.+)\1{1,}$/)  same as \1+
# - str.match?(/^(.+)\1{2,}$/) three or more duplications

# how this works:
# 1. (.+) is greedy - It tries to capture as much as possible first
# 2. try to match \1+ with remaining string
# 3. backtrack - Give back one character from the capture group
# 4. repeat 2-3 until match is found or string is exhausted

# example (565656):
# Attempt 1: "56565" + "6"        → ❌ (6 ≠ 56565)
# Attempt 2: "5656"  + "56"       → ❌ (56 ≠ 5656)
# Attempt 3: "565"   + "656"      → ❌ (656 ≠ 565 or 565565...)
# Attempt 4: "56"    + "5656"     → ✅ (5656 = 56 + 56)

# example (111):
# Attempt 1: "11" + "1"   → ❌ (11 ≠ 1)
# Attempt 2: "1"  + "11"  → ✅ (11 = 1 + 1)

td = <<~TDATA
  11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124
TDATA

data = File.read('../inputs/day2').strip

def solve(data)
  data.split(',').reduce([[], []]) do |(r1, r2), str|
    first, last = str.split('-').map(&:to_i)
    puts "Processing range: #{first}-#{last}"
    digits = (first..last).to_a.map(&:to_s)

    digits.reduce([r1, r2]) do |(sub1, sub2), digit|
      digit.match?(/^(.+)\1$/) && sub1 << digit

      digit.match?(/^(.+)\1+$/) && sub2 << digit

      [sub1, sub2]
    end
  end
end

def format(result)
  part1, part2 = result
  puts "R1: #{part1.map(&:to_i).reduce(:+)}"
  puts "R2: #{part2.map(&:to_i).sum}"
end

format(solve(td))
format(solve(data))
