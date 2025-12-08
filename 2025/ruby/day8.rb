#!/usr/bin/env ruby

# frozen_string_literal: true

tdata = <<~TDATA
  162,817,812
  57,618,57
  906,360,560
  592,479,940
  352,342,300
  466,668,158
  542,29,236
  431,825,988
  739,650,466
  52,470,668
  216,146,977
  819,987,18
  117,168,530
  805,96,715
  346,949,466
  970,615,88
  941,993,340
  862,61,35
  984,92,344
  425,690,689
TDATA

data = File.read('../inputs/day8').strip

def parse(input)
  pairs = input.split("\n")
               .map { |row| row.split(',').map(&:to_i) }
               .combination(2)
               .sort_by { |p1, p2| dist(p1, p2) }

  [pairs, input.lines.length]
end

def solve(raw, n)
  pairs, len = parse(raw)
  r1 = nil

  # Disjoint Set Union (Union-Find) with path compression
  # https://www.hackerearth.com/practice/notes/disjoint-set-union-union-find/
  dsu = {}

  pairs.each_with_index do |(a, b), step|
    dsu[a] ||= a
    dsu[b] ||= b

    union(dsu, a, b)

    r1 = size3largest(dsu) if step == n - 1

    return r1, a[0] * b[0] if dsu.length == len
  end
end

def dist(a, b)
  x1, y1, z1 = a
  x2, y2, z2 = b
  (x2 - x1)**2 + (y2 - y1)**2 + (z2 - z1)**2
end

def find(dsu, x)
  return x if dsu[x] == x

  # path compression
  dsu[x] = find(dsu, dsu[x])
end

def union(dsu, a, b)
  root_a = find(dsu, a)
  root_b = find(dsu, b)
  dsu[root_b] = root_a if root_a != root_b
end

def sizes(dsu)
  dsu.keys.each_with_object(Hash.new(0)) do |node, acc|
    root = find(dsu, node)
    acc[root] += 1
  end
end

def size3largest(dsu)
  sizes(dsu).values.sort_by(&:-@)[..2].reduce(:*)
end

pp solve(tdata, 10)
pp solve(data, 1000)
