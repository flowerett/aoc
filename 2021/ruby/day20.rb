#! /usr/bin/env ruby
require_relative "nanotest"

input = <<INPUT
..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

#..#.
#....
##..#
..#..
..###
INPUT

VERBOSE = ARGV.delete("-v")
DEBUG = ARGV.delete("-d")
T2 = ARGV.delete("-t2")

MOD = (-1..1).to_a
ADJ = MOD.product(MOD).freeze

def parse_data(input)
  key, img = input.strip.split("\n\n").map { |r| r.strip }
  img = img.split("\n").map { |r| r.strip }
  img = prep_img(img)
  [key, img]
end

def prep_img(arr)
  img = {}
  h = arr.size
  l = arr[0].size

  h.times do |ri|
    l.times do |ci|
      if arr[ri][ci] == "#"
        img[[ri, ci]] = true
      end
    end
  end

  img
end

def get_size(img)
  kk = img.keys
  y1, y2 = kk.map { |y, x| y }.minmax
  x1, x2 = kk.map { |y, x| x }.minmax
  pp [y1, y2, x1, x2] if DEBUG
  [y1, y2, x1, x2]
end

def print_img(img)
  puts "img, size: #{img.size}\n"

  s = 1
  y1, y2, x1, x2 = get_size(img)

  (y1 - s..y2 + s).each do |ri|
    row = (x1 - s..x2 + s).map do |ci|
      img[[ri, ci]] ? "#" : "."
    end.join
    puts row
  end
end

# on=true treat img data as 'on'
# on=false treat img data as 'off' (reverse img)
# handling 'infinity' can also be done by cutting
# but both solutions are not purfect and can't
# handle test and real inputs
def lit?(img, key, y, x, on, test)
  ind = ADJ.map { |yi, xi|
    if test
      (img[[y + yi, x + xi]]) && "1" || "0"
    else
      (img.key?([y + yi, x + xi]) == on) && "1" || "0"
    end
  }.join.to_i(2)

  if test
    (key[ind] == "#")
  else
    (key[ind] == "#") != on
  end
end

def enhance(img, key, on, test)
  imgn = {}
  y1, y2, x1, x2 = get_size(img)

  ii = 5

  (y1 - ii..y2 + ii).each do |ri|
    (x1 - ii..x2 + ii).each do |ci|
      if lit?(img, key, ri, ci, on, test)
        imgn[[ri, ci]] = true
      end
    end
  end

  imgn
end

def count_lit(img)
  img.sum { |k, v| v ? 1 : 0 }
end

def run(img, key, n)
  # treat test input as edgecase
  # so either my solution or problem suck
  test = key[0] == "."

  n.times do |i|
    on = i % 2 == 0
    img = enhance(img, key, on, test)
    if VERBOSE
      pp "after step #{i + 1}, #{on}"
      print_img(img)
      pp count_lit(img)
      puts "\n"
    end
  end

  puts count_lit(img)
end

if $0 == __FILE__
  Utils.day(2021, 20)
  input = File.read("../inputs/day20")
  key, img = parse_data(input)

  print_img(img) if VERBOSE

  run(img, key, 2)
  run(img, key, 50) if T2

  # r1: 35 | 5179
  # r2: 3351 | 16112
end
