#!/usr/bin/env ruby
# rubocop:disable all
# frozen_string_literal: true

tdata = <<~TDATA
  7,1
  11,1
  11,7
  9,7
  9,5
  2,5
  2,3
  7,3
TDATA

tdata2 = <<~TDATA
  1,1
  9,1
  9,9
  1,9
  1,7
  7,7
  7,3
  1,3
TDATA

tdata3 = <<~TDATA
  1,1
  9,1
  9,9
  1,9
  1,6
  7,6
  7,3
  1,3
TDATA

data = File.read('../inputs/day9').strip

def parse(input)
  input.split("\n").map { |row| row.split(',').map(&:to_i) }
end

# all points on the polygon boundary (vertices + points between them)
def build_edge_points(vertices)
  edges = vertices.each_cons(2).to_a << [vertices.last, vertices.first]

  edge_points = edges.flat_map { |a, b| points_between(a, b) }
  (edge_points + vertices).uniq
end

# all points on an axis-aligned edge (exclusive of endpoints)
def points_between((x1, y1), (x2, y2))
  if x1 == x2
    (([y1, y2].min + 1)...([y1, y2].max)).map { |y| [x1, y] }
  else
    (([x1, x2].min + 1)...([x1, x2].max)).map { |x| [x, y1] }
  end
end

BUCKET_SIZE = 1000

def build_grid(edge_points)
  grid = Hash.new { |h, k| h[k] = [] }
  edge_points.each do |x, y|
    bx = x / BUCKET_SIZE
    by = y / BUCKET_SIZE
    grid[[bx, by]] << [x, y]
  end
  grid
end

# faster version using grid bucketing for quick rejection
def rectangle_valid_grid?(p1, p2, grid, edge_set, x_max)
  x1, y1 = p1
  x2, y2 = p2

  min_x, max_x = [x1, x2].minmax
  min_y, max_y = [y1, y2].minmax

  # check buckets that overlap with the interior of the rectangle
  bx_start = (min_x + 1) / BUCKET_SIZE
  bx_end = (max_x - 1) / BUCKET_SIZE
  by_start = (min_y + 1) / BUCKET_SIZE
  by_end = (max_y - 1) / BUCKET_SIZE

  (bx_start..bx_end).each do |bx|
    (by_start..by_end).each do |by|
      # skip empty buckets (most are empty)
      next unless grid.key?([bx, by])

      # only check points in this bucket
      grid[[bx, by]].each do |x, y|
        if x > min_x && x < max_x && y > min_y && y < max_y
          return false
        end
      end
    end
  end

  # edgecase check that the rectangle is actually INSIDE the polygon
  # testing a point just inside the rectangle (ray casting)
  # big input works without this, but tdata2 fails
  test_x = min_x + 1
  test_y = min_y + 1
  crossings = (test_x + 1..x_max).count { |x| edge_set.include?([x, test_y]) }
  return false unless crossings.odd?

  true
end

def solve(raw, verbose = false)
  tiles = parse(raw)

  # build all candidate rectangles, sorted by area descending
  pairs = tiles.combination(2).map { |p1, p2|
    x1, y1 = p1
    x2, y2 = p2
    area = ((x2 - x1).abs + 1) * ((y2 - y1).abs + 1)
    [area, p1, p2]
  }.sort_by { |area, p1, p2| -area }

  r1 = pairs.first.first
  puts "Res1: #{r1}" if verbose

  # build polygon boundary
  edge_points = build_edge_points(tiles)
  # print_edge(edge_points)

  # grid for fast bucket-based rejection
  grid = build_grid(edge_points)
  edge_set = edge_points.to_set
  x_max = edge_points.map(&:first).max

  if verbose
    puts "Total edge points: #{edge_points.size}"
    puts "Total pairs: #{pairs.size}"
  end

  pairs.each_with_index do |(area, p1, p2), idx|
    if verbose && idx > 0 && idx % 10000 == 0
      puts "Progress: #{idx}/#{pairs.size}"
    end

    if rectangle_valid_grid?(p1, p2, grid, edge_set, x_max)
      puts "Res2: area: #{area}, p1: #{p1.inspect}, p2: #{p2.inspect}\n\n" if verbose
      return r1, area
    end
  end

  puts "Not found!"
end

def print_edge(edge_points)
  h = edge_points.reduce({}) { |h, (x, y)| h[[x, y]] = "#"; h }
  xmax = edge_points.map { |x, _y| x }.max
  ymax = edge_points.map { |_x, y| y }.max

  for y in (0..(ymax+1))
    row = ""
    for x in (0..(xmax+1))
      row += h.fetch([x, y], ".")
    end
    puts row
  end
  :ok
end

pp solve(tdata)
pp solve(tdata2)
pp solve(tdata3)
pp solve(data, true)
