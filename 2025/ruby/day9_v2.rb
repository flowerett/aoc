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

# build edges as [x1, y1, x2, y2] from consecutive vertices
def build_edges(vertices)
  edges = vertices.each_cons(2).map { |a, b| [a[0], a[1], b[0], b[1]] }
  # close the polygon
  edges << [vertices.last[0], vertices.last[1], vertices.first[0], vertices.first[1]]
  edges
end

# does the edge pass STRICTLY THROUGH the interior of the rectangle?
# (not just touching the boundary)
def edge_crosses_interior?(min_x, min_y, max_x, max_y, edge)
  ex1, ey1, ex2, ey2 = edge
  e_min_x, e_max_x = [ex1, ex2].minmax
  e_min_y, e_max_y = [ey1, ey2].minmax

  if ex1 == ex2  # vertical edge
    # edge x must be strictly inside, and edge y range must overlap interior y range
    ex1 > min_x && ex1 < max_x && e_min_y < max_y && e_max_y > min_y
  else  # horizontal edge (ey1 == ey2)
    # edge y must be strictly inside, and edge x range must overlap interior x range
    ey1 > min_y && ey1 < max_y && e_min_x < max_x && e_max_x > min_x
  end
end

# check if any edge crosses through the rectangle interior
def any_edge_crosses_interior?(min_x, min_y, max_x, max_y, edges)
  edges.any? { |edge| edge_crosses_interior?(min_x, min_y, max_x, max_y, edge) }
end

# ray casting: count vertical edges that cross a horizontal ray to the right of point
def point_inside_polygon?(px, py, edges)
  edges.count do |ex1, ey1, ex2, ey2|
    next false unless ex1 == ex2 && ex1 > px  # vertical edge to the right
    min_y, max_y = [ey1, ey2].minmax
    py >= min_y && py < max_y
  end.odd?
end

def solve(raw)
  tiles = parse(raw)
  edges = build_edges(tiles)

  puts "Vertices: #{tiles.size}, Edges: #{edges.size}"

  # pre-compute pairs with area, sorted descending
  pairs = tiles.combination(2).map do |p1, p2|
    min_x, max_x = [p1[0], p2[0]].minmax
    min_y, max_y = [p1[1], p2[1]].minmax
    area = (max_x - min_x + 1) * (max_y - min_y + 1)
    [area, min_x, max_x, min_y, max_y, p1, p2]
  end.sort_by { |area, *_| -area }

  puts "Res1: #{pairs.first.first}"

  # largest valid rectangle is result
  pairs.each do |area, min_x, max_x, min_y, max_y, p1, p2|
    next if any_edge_crosses_interior?(min_x, min_y, max_x, max_y, edges)
    next unless point_inside_polygon?(min_x + 1, min_y + 1, edges)

    puts "Res2: #{area}, p1=#{p1}, p2=#{p2}\n\n"
    return area
  end

  puts "Res2: not found"
end

solve(tdata)
solve(tdata2)
solve(tdata3)
solve(data)
