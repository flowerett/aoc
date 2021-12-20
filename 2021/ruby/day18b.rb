#! /usr/bin/env ruby
require_relative "nanotest"

test = <<INPUT
[[[[4,3],4],4],[7,[[8,4],9]]]
[1,1]
INPUT

input = <<INPUT
[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
[[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]
[[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
[7,[5,[[3,8],[1,4]]]]
[[2,[2,2]],[8,[8,1]]]
[2,9]
[1,[[[9,3],9],[[9,0],[0,7]]]]
[[[5,[7,4]],7],1]
[[[[4,2],2],6],[8,7]]
INPUT

VERBOSE = ARGV.delete("-v")
DEBUG = ARGV.delete("-d")

def prep_data(input)
  input.strip.split("\n").map { |r| eval(r) }
end

def to_node(n, ind = 1, h = nil)
  h = {} if h.nil?
  if n.is_a?(Integer)
    h[ind] = n
  else
    l, r = n
    to_node(l, 2 * ind, h)
    to_node(r, 2 * ind + 1, h)
  end

  return h
end

def explode(h)
  sk = h.keys.sort_by { |i| i.to_s(2) }
  st = sk.first
  en = sk.last
  ll = sk.size

  ll.times do |i| # travers list
    if sk[i] >= 32 # level 5 found (2**5)
      a, b = sk[i..i + 1] # take L & R nums
      h[sk[i - 1]] += h[a] if a != st # moving L left
      h[sk[i + 2]] += h[b] if b != en # moving R right
      h.delete(a) # delete old nums
      h.delete(b)
      h[a / 2] = 0 # put new node - 0
      return true
    end
  end
  return false
end

def split(h)
  # sort node by key string len (bin sort)
  sorted = h.sort_by { |k, v| k.to_s(2) }

  sorted.each do |k, v|
    if v >= 10 # if split, add 2 new nodes
      h[2 * k] = v / 2
      h[2 * k + 1] = v - v / 2
      h.delete(k) # delete old one
      return true
    end
  end
  return false
end

# replacing left '1' in all keys with
# - '10' for the left child
# - '11' for right child
def add(a, b)
  aa = a.map { |k, v|
    kk = ("10" + k.to_s(2)[1..-1]).to_i(2)
    [kk, v]
  }.to_h

  bb = b.map { |k, v|
    kk = ("11" + k.to_s(2)[1..-1]).to_i(2)
    [kk, v]
  }.to_h
  aa.merge(bb)
end

def do_reduce(h)
  do_reduce(h) if explode(h)
  do_reduce(h) if split(h)
  h
end

# decoding binary tree back:
# 1. remove first digit from keys
# 2. each '0' in digit means multiplication by 3 (3-0)
# 3. each '1' in digit means multiplication by 2 (3-1)
# 4. find multiplication of digits and multiply by node value
# 5. sum all elements
def magnitude(h)
  h.sum do |k, v|
    digits = k.to_s(2)[1..-1].chars.map(&:to_i)
    pp digits if VERBOSE
    x = digits.map { |d| 3 - d }.reduce(&:*)
    v * x
  end
end

def task1(nodes)
  st, *rest = nodes

  snum = rest.reduce(st) do |acc, n|
    nxt = add(acc, n)
    do_reduce(nxt)
  end

  magnitude(snum)
end

def task2(nodes)
  nodes.product(nodes).map do |d1, d2|
    d1 != d2 ? magnitude(do_reduce(add(d1, d2))) : 0
  end.max
end

# nice solution from:
# https://github.com/fuglede/adventofcode/blob/master/2021/day18/solutions.py

# Use hash to represent binary tree:
# - The children of a node has index 2*i, 2*i+1 where i is the index of the parent.
#
# - The parent of a node has index i//2 where i is the index of the child.
#
# - Using .to_s(2) to generate binary representations of each index,
#   iterating over nodes in increasing bin-order is the same as in-order traversal.
#
# - In the binary representation, the length of the string is the depth of a given node,
#   while the remaining digits indicate whether we are moving left or right in the tree,
#   so adding two trees amounts to replacing the outermost '1'
#   with '10' and '11' for the left and right parts respectively.

if DEBUG
  dt = prep_data(test)
  pp "-- test input --"
  dt.each { |r| pp r }

  a, b = dt.map { |arr| to_node(arr) }

  pp "-- adding --"
  pp r = add(a, b)
  pp "-- reducing --"
  r = do_reduce(r)
  pp r.sort_by { |k, v| k.to_s(2) }.to_h
  pp r.sort_by { |k, v| k.to_s(2) }.map { |k, v| [k.to_s(2), v] }
  pp "-- calc magnitude --"
  pp magnitude(r)
end

data = prep_data(input)
nodes = data.map(&method(:to_node))
r1t = task1(nodes)
r2t = task2(nodes)

NanoTest.new("test").assert_all([r1t, r2t], [3488, 3805], "example 1")
puts "test res1: #{r1t}"
puts "test res2: #{r2t}"

input = File.read("../inputs/day18")
data = prep_data(input)
nodes = data.map(&method(:to_node))
res1 = task1(nodes)
res2 = task2(nodes)
puts "res1: #{res1}"
puts "res1: #{res2}"
