#! /usr/bin/env ruby
# require "set"
require_relative "nanotest"

# first priority queue that I found
# https://github.com/rubyworks/pqueue
require "pqueue"

input = <<INPUT
1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581
INPUT

VERBOSE = ARGV.delete("-v")

def prep_data(input)
  input.strip.split("\n").map do |r|
    r.split("").map(&:to_i).freeze
  end.freeze
end

def fill(data, h, l)
  res = {}
  res[[0, 0]] = 0

  h.times do |y|
    l.times do |x|
      prev = ADJ1.map do |yi, xi|
        res[[y + yi, x + xi]]
      end.compact.min || 0

      nxt = prev + data[y][x]
      k = res[[y, x]]

      res[[y, x]] = nxt if !k || k > nxt
    end
  end

  ppres(res, h, l) if VERBOSE
  res[[h - 1, l - 1]]
end

# helper, prints res
def ppres(res, h, l)
  h.times do |y|
    r = l.times.to_a.map do |x|
      k = res[[y, x]] || "."
      k.to_s.rjust(3, " ")
    end
    puts r.join(" ")
  end
end

def multiply(data, n)
  (H * n).times.map do |y|
    (L * n).times.map do |x|
      incx, xx = x.divmod(L)
      incy, yy = y.divmod(H)
      vt = ((data[yy][xx] + incx + incy) % 9)
      vt == 0 ? 9 : vt
    end
  end
end

# it's not A*, just Dijkstra actually
def astar(data, h, l)
  res = {}
  res[[0, 0]] = 0
  seen = {}

  pq = PQueue.new { |a, b| a[0] < b[0] }
  pq.push([0, 0, 0])

  while !pq.empty?
    d, y, x = pq.pop

    next if seen[[y, x]]
    seen[[y, x]] = true

    nxt = ADJ.map do |yi, xi|
      yy = y + yi
      xx = x + xi

      if xx >= 0 && yy >= 0 && xx < l && yy < h
        r = data[yy][xx]
        prev = res[[yy, xx]]
        rr = r + d

        res[[yy, xx]] = rr if !prev || prev > rr

        [rr, yy, xx]
      end
    end

    nxt.compact
      .each do |p|
      d, y, x = p
      pq.push(p) if !seen[[y, x]]
    end
  end

  res[[h - 1, l - 1]]
end

if $0 == __FILE__
  Utils.day(2021, 15)
  # input = File.read("../inputs/day15")
  data = prep_data(input)

  H = data.size
  L = data[0].size
  puts data.map { |r| r.join(" ") } if VERBOSE

  # U-L neighbours
  ADJ1 = [[-1, 0], [0, -1]]

  # all for neighbours U-D-L-R
  ADJ = [[-1, 0], [1, 0], [0, -1], [0, 1]].freeze

  #T1
  res1 = fill(data, H, L)
  # produces correct result - 707
  puts "res1: #{res1}"

  res1st = astar(data, H, L)
  puts "res1*: #{res1st}"

  #T2
  n = 5
  data = multiply(data, n)

  res2 = fill(data, H * n, L * n)
  # produces wrong result - 2948
  puts "res2f: #{res2}"

  res2st = astar(data, H * n, L * n)
  puts "res2*: #{res2st}"

  t = NanoTest.new("test")
  t.assert_all([res1, res2], [40, 315])
  t.assert_all([res1st, res2st], [40, 315])
end
