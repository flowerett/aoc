#! /usr/bin/env ruby
# require "set"
require_relative "nanotest"

input_t1 = <<INPUT
start-A
start-b
A-c
A-b
b-d
A-end
b-end
INPUT

input_t2 = <<INPUT
dc-end
HN-start
start-kj
dc-start
dc-HN
LN-dc
HN-end
kj-sa
kj-HN
kj-dc
INPUT

input_t3 = <<INPUT
fs-end
he-DX
fs-he
start-DX
pj-DX
end-zg
zg-sl
zg-pj
pj-he
RW-he
fs-DX
pj-RW
zg-RW
start-pj
he-WI
zg-he
pj-fs
start-RW
INPUT

input = File.read("../inputs/day12")

VERBOSE = ARGV.delete("-v")

def prep_data(input)
  input.strip.split("\n").map { |cmd| cmd.split("-") }
end

def add_child(g, node, val)
  if g.has_key?(node)
    g[node] << val
  else
    g[node] = [val]
  end
end

def prep_graph(data)
  g = {}
  data.each do |st, en|
    add_child(g, st, en)
    add_child(g, en, st)
  end
  g
end

def t1(n, pathc)
  n.is_upper? or !pathc.include?(n)
end

def t2(n, pathc)
  return true if n.is_upper?

  return false if n == "start" || (n == "end" && pathc.include?(n))

  dups = pathc
    .filter { |n| n.is_lower? }
    .tally # group items in arr
    .filter { |_n, v| v == 2 }
    .keys

  dups.empty? || !pathc.include?(n)
end

def traverse(g, check_fun)
  pts = 0
  path = []
  paths = []

  st = [["start", path]]
  until st.empty?
    # BFS (st.pop for DFS) doesn't matter for this task
    node, path = st.shift
    pathc = path.clone # with indexes will be less expensive

    pathc << node
    nxt = g.fetch(node, [])

    if node == "end"
      pts += 1
      paths << pathc.join(",")
    else
      nxt.each do |n|
        check = method(check_fun).call(n, pathc)
        st << [n, pathc] if check
      end
    end
  end

  return [pts, paths]
end

EXAMPLE_RES = [[10, 36], [19, 103], [226, 3509]]

if $0 == __FILE__
  test_res = [input_t1, input_t2, input_t3]
    .map { |inp| prep_data(inp) }
    .map { |d| prep_graph(d) }
    .map do |g|
    r1, _ = traverse(g, :t1)
    r2, _ = traverse(g, :t2)
    [r1, r2]
  end

  Utils.day(2021, 12)
  t = NanoTest.new("test")
  test_res.zip(EXAMPLE_RES).each_with_index do |res, i|
    run, test = res
    t.assert_all(run, test, "example #{i + 1}")
  end

  # real
  data = prep_data(input)
  g = prep_graph(data)
  pp "=== Graph ===", g if VERBOSE

  puts "Getting my results ..."
  res1, paths1 = traverse(g, :t1)
  puts "=== Paths 1 ====", paths1 if VERBOSE

  res2, paths2 = traverse(g, :t2)
  puts "=== Paths 2 ====", paths2 if VERBOSE

  # r1 5874
  # r2 153592
  Utils.pp([res1, res2])
end
