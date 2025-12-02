#!/usr/bin/env ruby

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

data = File.read("../inputs/day1").strip

def solve(data)
  start = 50
  res = data.split.map do |d|
    sign = d[0] == "L" ? -1 : 1
    [sign, d[1..].to_i]
  end.reduce([start, 0, 0]) do |(pos, zeros, wraps), (sign, num)|
    laps, steps = num.divmod(100)

    new_val = pos + sign * steps
    new_pos = new_val % 100

    new_wraps = wraps + laps
    new_wraps += 1 if (new_pos == 0 || (new_val < 0 && pos != 0) || (new_val >= 100))

    zeros += 1 if new_pos == 0

    [new_pos, zeros, new_wraps]
  end

  puts "Zeros (T1): #{res[1]}"
  puts "Wraps (T2): #{res[2]}"
end

solve(td)
solve(data)
