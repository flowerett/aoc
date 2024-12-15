#! /usr/bin/env ruby

VOWELS = %w(a e i o u)
BAD = %w(ab cd pq xy)

def has_vowels(str, n)
  num_v = str.split("").reduce(0) { |sum, c| VOWELS.include?(c) && sum+1 || sum }
  num_v >= n
end

def is_nice1(str)
  ss = str.split("")
  # pairs = ss[..-1].zip(ss[1..]).take(ss.size-1)
  pairs = ss.each_cons(2)

  has_vowels(str, 3) &&
    pairs.any? { |a, b| a == b } &&
    pairs.none? { |p| BAD.include?(p.join) }
end

def is_nice2(str)
  one_between(str) &&
    has_repeating_pairs?(str)
end

def one_between(str)
  tri = str.split("").each_cons(3)
  tri.any? { |a, b, c| a == c && b != a}
end

# with regexp
# def has_repeating_pairs?(str)
#   str.match?(/(..).*\1/)
# end

def has_repeating_pairs?(str)
  (0..str.length-2).any? do |i|
    pair = str[i..i+1]
    str[i+2..-1]&.include?(pair)
  end
end

inp = File.read("../inputs/day5")

t1 = <<INPUT
ugknbfddgicrmopn
aaa
jchzalrnumimnmhp
haegwjzuvuyypxyu
dvszwmarrgswjxmb
INPUT

t2 = <<INPUT
qjhvhtzxzqqjkmpb
xxyxx
uurcxstgmygtbstg
ieodomkazucvgmuy
INPUT

data = inp.split

res1 = data.reduce(0) do |sum, str|
  is_nice1(str) && sum + 1 || sum
end

res2 = data.reduce(0) do |sum, str|
  is_nice2(str) && sum + 1 || sum
end

pp [res1, res2]
