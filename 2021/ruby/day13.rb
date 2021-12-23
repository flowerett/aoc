#! /usr/bin/env ruby
# require "set"
require_relative "nanotest"

# input = <<INPUT
# 6,10
# 0,14
# 9,10
# 0,3
# 10,4
# 4,11
# 6,0
# 6,12
# 4,1
# 0,13
# 10,12
# 3,4
# 3,0
# 8,4
# 1,10
# 2,14
# 8,10
# 9,0

# fold along y=7
# fold along x=5
# INPUT

input = File.read("../inputs/day13")

VERBOSE = ARGV.delete("-v")

def prep_data(input)
  data, cmds = input.strip.split("\n\n")
  dots = {}

  data.split("\n").each do |r|
    k = r.split(",").map(&:to_i)
    dots[k] = true
  end

  cmds = cmds.split("\n").map do |r|
    f, n = r.split(" ").last.split("=")
    [f.to_sym, n.to_i]
  end

  [dots, cmds]
end

def fold(d, cmd)
  dir, n = cmd

  d.keys.reduce({}) do |acc, k|
    x, y = k

    kk = case dir
      when :x
        x < n ? [x, y] : [2 * n - x, y]
      when :y
        y < n ? [x, y] : [x, 2 * n - y]
      end
    acc[kk] = true
    acc
  end
end

def pmax(dots)
  kk = dots.keys
  xm = kk.map { |x, y| x }.max
  ym = kk.map { |x, y| y }.max
  [xm, ym]
end

if $0 == __FILE__
  Utils.day(2021, 13)
  dots, cmds = prep_data(input)

  # T1
  t1 = fold(dots, cmds[0])
  puts "res1:", "(after #{cmds[0]}) #{t1.size}"

  # T2
  dots = cmds.reduce(dots) { |acc, cmd| fold(acc, cmd) }

  xx, yy = pmax(dots)
  puts "res2:"

  (0..yy + 1).each do |y|
    r = (0..xx + 1).map do |x|
      dots.has_key?([x, y]) ? "#".white : " "
    end.join
    print("#{r}\n")
  end
end
