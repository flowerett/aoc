#! /usr/bin/env ruby
require "set"

input = File.read("../inputs/day12").strip.split("\n")

g = {}
input.each do |row|
  a, b = row.split("-")

  g.has_key?(a) ? g[a].add(b) : g[a] = Set.new([b])
  g.has_key?(b) ? g[b].add(a) : g[b] = Set.new([a])
end

def is_lower?(str)
  str == str.downcase
end

def traverse(g, n, seen, dup)
  return 1 if n == "end"
  if is_lower?(n) && seen.member?(n)
    return 0 if n == "start" or !dup
    dup = false
  end

  g[n].reduce(0) do |sum, nxt|
    snext = seen.clone.add(n)
    sum + traverse(g, nxt, snext, dup)
  end
end

puts traverse(g, "start", Set.new, false)
puts traverse(g, "start", Set.new, true)
