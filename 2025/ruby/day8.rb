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

def parse(raw)
  dd = raw.split("\n").map { |row| row.split(',').map(&:to_i) }
  pairs = []
  dd.each_with_index do |p1, i|
    ((i + 1)...dd.length).each do |j|
      p2 = dd[j]
      pairs << [dist(p1, p2), p1, p2]
    end
  end
  [pairs.sort_by! { |d, _, _| d }, dd.length]
end

def solve(raw, n)
  pairs, len = parse(raw)

  connected = {}
  id = 0
  r1, r2 = nil

  pairs.each_with_index do |(_d, a, b), step|
    id_a = connected[a]
    id_b = connected[b]

    case
    when id_a && id_a == id_b
      # already connected to the same net, do nothing count as 'step'
      :noop
    when id_a && id_b
      # both connected and different nets: merge two nets
      connected.each { |k, v| connected[k] = id_a if v == id_b }
    when id_a
      # connect b to a's net
      connected[b] = id_a
    when id_b
      # connect a to b's net
      connected[a] = id_b
    else
      # new net
      id += 1
      connected[a] = id
      connected[b] = id
    end

    if step == n - 1
      # pp "step: #{step+1}, #{connected.length}"
      r1 = l3_mul(connected)
    end

    next if connected.length != len

    # pp "step: #{step+1}, #{connected.length}"
    r2 = a[0] * b[0]
    break
  end

  [r1, r2]
end

def l3_mul(nets)
  nets.group_by { |_, id| id }
      .map { |_k, v| v.length }
      .sort_by(&:-@)[..2]
      # .tap { |l3| pp l3 }
      .reduce(:*)
end

def dist(a, b)
  x1, y1, z1 = a
  x2, y2, z2 = b
  (x2 - x1)**2 + (y2 - y1)**2 + (z2 - z1)**2
end

pp solve(tdata, 10)
pp solve(data, 1000)
