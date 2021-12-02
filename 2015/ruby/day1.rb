#! /usr/bin/env ruby

# input = ")())())"
# input = "()())"
input = File.read("../inputs/day1").strip.freeze

#T1/2
r1, r2 = input.split("").each_with_index.reduce([0, nil]) do |(sum, base), (el, ind)|
  sum += 1 if el == "("
  sum -= 1 if el == ")"
  base ||= ind + 1 if sum == -1

  [sum, base]
end

puts("res1: #{r1}")
puts("res2: #{r2}")
