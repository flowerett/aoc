#!/usr/bin/env ruby
# frozen_string_literal: true

# modified inputs to test both part1 and part2
tdata = <<~TDATA
  svr: out
  aaa: you hhh
  you: bbb ccc
  bbb: ddd eee
  ccc: ddd eee fff
  ddd: ggg
  eee: out
  fff: out
  ggg: out
  hhh: ccc fff iii
  iii: out
TDATA

tdata2 = <<~TDATA
  you: aaa bbb
  svr: aaa bbb
  aaa: fft
  fft: ccc
  bbb: tty
  tty: ccc
  ccc: ddd eee
  ddd: hub
  hub: fff
  eee: dac
  dac: fff
  fff: ggg hhh
  ggg: out
  hhh: out
TDATA

data = File.read('../inputs/day11').strip

def parse(input)
  input.split("\n").reduce({}) do |acc, row|
    st, *nodes = row.split
    st = st.tr(':', '')
    acc[st] = nodes
    acc
  end
end

# DFS
def task1(graph, st)
  queue = [st]
  count = 0

  while !queue.empty?
    cur = queue.pop
    next count += 1 if cur == 'out'
    raise "impossible #{cur}" unless graph.has_key?(cur)
    graph[cur].each { |node| queue << node }
  end

  count
end

# DP
# track state and count paths from that state to 'out'
# state: (node, has_seen_fft, has_seen_dac)
def task2(graph, st)
  memo = {}

  # can be function with memo arg but lambda is faster
  # since we don't need to copy memo between steps
  count_paths = lambda do |cur, has_fft, has_dac|
    return 1 if cur == 'out' && has_fft && has_dac
    return 0 if cur == 'out'
    raise "impossible #{cur}" unless graph.has_key?(cur)

    key = [cur, has_fft, has_dac]
    return memo[key] if memo.has_key?(key)

    total = 0

    graph[cur].each do |node|
      new_fft = has_fft || node == 'fft'
      new_dac = has_dac || node == 'dac'
      total += count_paths.call(node, new_fft, new_dac)
    end

    memo[key] = total
    total
  end

  count_paths.call(st, false, false)
end

def solve(raw, verbose = false)
  inp = parse(raw)
  r1 = task1(inp, 'you')
  r2 = task2(inp, 'svr')
  [r1, r2]
end

pp solve(tdata)
pp solve(tdata2)
pp solve(data)
