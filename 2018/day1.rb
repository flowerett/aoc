require 'set'

input = File.read("inputs/day1").split("\n").map(&:to_i).freeze

puts input.sum

freq = 0
seen = Set.new

input.cycle { |delta|
  freq += delta
  (puts freq; break) if seen.include?(freq)
  seen << freq
}