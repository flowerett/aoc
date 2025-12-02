#!/usr/bin/env ruby

# frozen_string_literal: true

td = <<~TDATA
  L68
  L30
  R48
  L5
  R60
  L55
  L1
  L99
  R14
  L82
TDATA

data = File.read('../inputs/day1').strip

def parse(data)
  data.split.map do |d|
    sign = d[0] == 'L' ? -1 : 1
    [sign, d[1..].to_i]
  end
end

def solve(data)
  start = 50
  data.reduce([start, 0, 0]) do |(pos, zeros, wraps), (sign, num)|
    laps, steps = num.divmod(100)

    new_val = pos + sign * steps
    new_pos = new_val % 100

    new_wraps = wraps + laps
    new_wraps += 1 if new_pos.zero? || (new_val.negative? && pos != 0) || (new_val >= 100)

    zeros += 1 if new_pos.zero?

    [new_pos, zeros, new_wraps]
  end
end

def format(result)
  _, res1, res2 = result
  puts "Zeros (T1): #{res1}"
  puts "Wraps (T2): #{res2}"
end

# ugly ruby pipes
parser = proc { |d| parse(d) }
solver = proc { |d| solve(d) }
formatter = proc { |d| format(d) }

td.then(&parser).then(&solver).then(&formatter)
data.then(&parser).then(&solver).then(&formatter)
