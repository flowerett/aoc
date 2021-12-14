#! /usr/bin/env ruby
# require "set"
require_relative "nanotest"

input = <<INPUT
NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C
INPUT

VERBOSE = ARGV.delete("-v")

def prep_data(input)
  st, d = input.strip.split("\n\n")

  r = d.strip.split("\n")
    .map { |r| r.split(" -> ") }
    .to_h

  [st.freeze, r]
end

# def mutate1(st, r)
#   l = st.size

#   (0..l-1).map do |i|
#     k = st[i..i+1]
#     if r.key?(k)
#       [i+i, r[k]]
#     end
#   end.compact.reduce(st.dup) do |acc, inst|
#     i, ch = inst
#     acc.insert(i+1, ch)
#   end
# end

def prep_counter(st)
  cnt = Hash.new(0)

  (st.size - 1).times.reduce(cnt) do |acc, i|
    pair = st[i..i + 1]
    acc[pair] += 1
    acc
  end
end

def mutate2(cnt, r)
  c2 = Hash.new(0)

  cnt.keys.each do |k|
    if r.key?(k)
      c2[k[0] + r[k]] += cnt[k]
      c2[r[k] + k[1]] += cnt[k]
    end
  end
  c2
end

# def t1(st, r)
#   st1 = st.dup
#   10.times do |i|
#     st1 = mutate1(st1, r)
#     pp st1 if i < 4 && VERBOSE
#   end

#   mn, mx = st1.split("").tally.minmax {|a, b| a[1] <=> b[1]}.map {|n| n[1]}
#   pp "min: #{mn}, max: #{mx}" if VERBOSE
#   mx - mn
# end

def t2(st, r, n)
  cnt = prep_counter(st)
  pp "new counter:", cnt if VERBOSE

  cnt = n.times.reduce(cnt) { |acc, _n| mutate2(acc, r) }
  pp "mutated:", cnt if VERBOSE

  # count chars
  freq = Hash.new(0)
  cnt.keys.each do |k|
    freq[k[0]] += cnt[k]
  end
  freq[st[-1]] += 1

  mn, mx = freq.values.minmax
  pp "min: #{mn}, max: #{mx}" if VERBOSE
  mx - mn
end

if $0 == __FILE__
  Utils.day(2021, 14)
  t = NanoTest.new("test")

  st, r = prep_data(input)
  pp st, r if VERBOSE

  # T1 - works but slow
  # r1 = t1(st, r)
  # pp "res1: #{r1}"

  # T2
  rt = [t2(st, r, 10), t2(st, r, 40)]
  t.assert_all(rt, [1588, 2188189693529])

  input = File.read("../inputs/day14")
  st, r = prep_data(input)
  my = [t2(st, r, 10), t2(st, r, 40)]

  t.assert_all(my, [2967, 3692219987038])
  Utils.pp(my)
end
