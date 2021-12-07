#! /usr/bin/env ruby

# input = <<INPUT
# 16,1,2,0,4,2,7,1,2,14
# INPUT

input = File.read("../inputs/day7").strip

data = input.strip.split(",").map(&:to_i).freeze

def t1(pos, cur, _sums)
  (pos - cur).abs
end

def t2(pos, cur, sums)
  dd = t1(pos, cur, nil)
  unless sums.has_key?(dd)
    sums[dd] = (0..dd).inject(0, &:+)
  end
  sums[dd]
end

def find_min_fuel(data, fun)
  min, max = data.minmax
  pmin, fmin = 0, nil
  sums = Hash.new(0)

  (min..max).each do |pos|
    fuel = data.map { |cur|
      method(fun).call(pos, cur, sums)
    }.sum

    if fmin.nil? or fuel < fmin
      fmin = fuel
      pmin = pos
    end
  end

  [pmin, fmin]
end

pp "res1: #{find_min_fuel(data, :t1).last}"
pp "res2: #{find_min_fuel(data, :t2).last}"
