#! /usr/bin/env ruby
require_relative "nanotest"

input_t1 = <<INPUT
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

input_t2 = <<INPUT
[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
[[[5,[2,8]],4],[5,[[9,9],0]]]
[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
[[[[5,4],[7,7]],8],[[8,3],8]]
[[9,3],[[9,9],[6,[4,9]]]]
[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
INPUT

VERBOSE = ARGV.delete("-v")
DEBUG = ARGV.delete("-d")

def prep_data(input)
  input.strip.split("\n").map { |r| eval(r) }
end

def add_left(a, b)
  return a if !b
  return a + b if a.is_a?(Integer)
  [add_left(a[0], b), a[1]]
end

def add_right(a, b)
  return a if !b
  return a + b if a.is_a?(Integer)
  [a[0], add_right(a[1], b)]
end

def explode(node, d)
  # if node is digit, return false
  return false, node, 0, 0 if node.is_a?(Integer)

  l, r = node

  # if depth is 5 do explode
  return true, 0, l, r if d == 5

  # try explode left part
  exploded, nxt, ex_l, ex_r = explode(l, d + 1)
  return true, [nxt, add_left(r, ex_r)], ex_l, 0 if exploded

  # try explode right part
  exploded, nxt, ex_l, ex_r = explode(r, d + 1)
  return true, [add_right(l, ex_l), nxt], 0, ex_r if exploded

  # return false if nothing to explode
  return false, node, 0, 0
end

def split(node)
  if node.is_a?(Integer)
    return false, node if node <= 9

    return true, [node / 2, node - node / 2]
  end

  l, r = node

  splitted, sp_l = split(l)
  return true, [sp_l, r] if splitted

  splitted, sp_r = split(r)
  return splitted, [l, sp_r]
end

def do_reduce(node)
  exploded, node, _, _ = explode(node, 1)
  return do_reduce(node) if exploded

  splitted, node = split(node)
  return do_reduce(node) if splitted

  node
end

def magnitude(node)
  return node if node.is_a?(Integer)
  l, r = node
  3 * magnitude(l) + 2 * magnitude(r)
end

# magical eval oneliner
# def magnitude(n)
#   eval n.to_s.split(",").join("*3+2*").gsub("[", "(").gsub("]", ")")
# end

def task1(data)
  st, *rest = data
  snum = rest.reduce(st) { |acc, n| do_reduce([acc, n]) }
  magnitude(snum)
end

def task2(data)
  maxn = 0

  data.each do |d1|
    data.each do |d2|
      if d1 != d2
        snum = do_reduce([d1, d2])
        mg = magnitude(snum)
        maxn = [maxn, mg].max
      end
    end
  end

  maxn
end

if $0 == __FILE__
  Utils.day(2021, 18)
  input = File.read("../inputs/day18")
  d1 = prep_data(input_t1)
  d2 = prep_data(input_t2)
  dm = prep_data(input)

  tr11 = task1(d1)
  tr12 = task1(d2)
  r1my = task1(dm) #4140

  tr21 = task2(d1)
  tr22 = task2(d2)
  r2my = task2(dm) # 4706

  t = NanoTest.new("test")
  t.assert_all([tr11, tr12], [3488, 4140], "task 1")
  t.assert_all([tr21, tr22], [3805, 3993], "task 2")

  Utils.pp([r1my, r2my])
end
