#! /usr/bin/env ruby
require_relative "nanotest"

input = <<INPUT
target area: x=20..30, y=-10..-5
INPUT

VERBOSE = ARGV.delete("-v")
DEBUG = ARGV.delete("-d")

# can also do eval("244..303")
# or just hardcode, as input is small
def prep_data(input)
  _, _, xs, ys = input.strip.split
  [xs, ys].map { |e|
    a, b = e.split("..")
    [a[2..-1].to_i, b.to_i]
  }
end

def move(x, y, xv, yv)
  x += xv
  y += yv
  xv -= 1 if xv > 0
  xv += 1 if xv < 0
  yv -= 1

  [x, y, xv, yv]
end

# 1. X doesn't matter for finding max Y
# 2. At 0 Y velocity will be -V (initial with negative sign)
# 3. To hit at least bottom of target area, at 0 velocity should be abs(DownBottom)-1
# 4. Max height will be sum of Y pos increasing from 0 to abs(DownBottom)-1
def solve1(xt, yt)
  z = abs(yt[0]) - 1
  (0..z).sum
end

def solve(xt, yt)
  res = {}

  # if X velocity is higher than right bound there will be a miss after step 1
  # so the X range is 0..X-RightBound
  (0..xt[1]).each do |xvi|
    # if Y velocity is lower than down bound there will be a miss after step 1
    # with positive Y, when the probe pass 0 its velocity will be -V (same but negative)
    # so the Y range is from -DownBourn...+DownBound
    (yt[0]..-yt[0]).each do |yvi|
      x, y, xv, yv = [0, 0, xvi, yvi]
      my = 0

      loop {
        # the probe is within the target area
        if (x >= xt[0] and x <= xt[1]) and (y <= yt[1] and y >= yt[0])
          res[[xvi, yvi]] = my
          break
        end
        # the probe miss the target
        if (x > xt[1] or y < yt[0])
          res[[xvi, yvi]] = :out
          break
        end
        x, y, xv, yv = move(x, y, xv, yv)
        my = y if y > my
      }
      pp ["velocity", xvi, yvi, "res: ", res[[xvi, yvi]]] if DEBUG
    end
  end

  puts "total attempts: #{res.size}" if VERBOSE
  targets = res.filter { |k, v| v != :out }
  r1 = targets.max_by { |k, v| v }.last
  r2 = targets.count

  [r1, r2]
end

if $0 == __FILE__
  Utils.day(2021, 17)
  tt = prep_data(input)
  pp tt if VERBOSE
  tres = solve(*tt)

  input = File.read("../inputs/day17")
  tmy = prep_data(input)
  pp tmy if VERBOSE

  myres = solve(*tmy)
  Utils.pp(myres)

  t = NanoTest.new("test")
  t.assert_all(tres, [45, 112], "example 1")
  t.assert_all(myres, [4095, 3773], "my")
end
