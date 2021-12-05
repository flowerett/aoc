#! /usr/bin/env ruby

input = <<INPUT
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
INPUT

# input = File.read("../inputs/day5").strip

data = input.split("\n").map do |row|
  x, y = row.split(" -> ")
  [x, y].map { |el| el.split(",").map(&:to_i) }.flatten
end
# pp data

#T1
def to_dots1(row)
  x1, y1, x2, y2 = row

  # t1
  if x1 == x2
    any_range(y1, y2).map { |y| to_key(x1, y) }
  elsif y1 == y2
    any_range(x1, x2).map { |x| to_key(x, y1) }
  else
    nil
  end
end

#T2
def to_dots2(row)
  x1, y1, x2, y2 = row
  dx = x2 - x1
  dy = y2 - y1

  if x1 == x2
    any_range(y1, y2).map { |y| to_key(x1, y) }
  elsif y1 == y2
    any_range(x1, x2).map { |x| to_key(x, y1) }
  elsif dx.abs == dy.abs
    dsx = dsig(x1, x2)
    dsy = dsig(y1, y2)
    (0..dx.abs).map { |d| to_key(x1 + d * dsx, y1 + d * dsy) }
  else
    nil
  end
end

def any_range(a, b)
  a <= b ? (a..b).to_a : a.downto(b).to_a
end

def dsig(d1, d2)
  d1 > d2 ? -1 : 1
end

def to_key(x, y)
  [x, y].join("-").to_sym
end

def prepare_res(dots)
  dots
    .compact
    .flatten
    .group_by { |el| el }
    .filter { |k, v| v.size > 1 }
    .keys
end

d1 = data.map { |row| to_dots1(row) }
res1 = prepare_res(d1)
# pp res1

puts "res1: #{res1.count}"

d2 = data.map { |row| to_dots2(row) }
res2 = prepare_res(d2)
# pp res2

puts "res2: #{res2.count}"
