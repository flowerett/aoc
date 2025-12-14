#!/usr/bin/env ruby
# frozen_string_literal: true

tdata = <<~TDATA
  0:
  ###
  ##.
  ##.

  1:
  ###
  ##.
  .##

  2:
  .##
  ###
  ##.

  3:
  ##.
  ###
  ##.

  4:
  ###
  #..
  ###

  5:
  ###
  .#.
  ###

  4x4: 0 0 0 0 2 0
  12x5: 1 0 1 0 2 2
  12x5: 1 0 1 0 3 2
TDATA

data = File.read('../inputs/day12').strip

def parse(input)
  str_shapes = input.split("\n\n")
  str_reg = str_shapes.pop

  shapes = parse_shapes(str_shapes)

  regions = str_reg.split("\n").map do |row|
    row.split(': ').map {|p| p.split(/x| /).map(&:to_i)}
  end

  [shapes, regions]
end

def parse_shapes(raw)
  raw.map do |rs|
    _ind, *shape_lines = rs.split("\n")
    parsed = []
    shape_lines.each_with_index do |row, r|
      row.chars.each_with_index do |c, col|
        parsed << [r, col] if c == '#'
      end
    end
    parsed
  end
end

# canonical shape representation
# shifts everything to the minimum
def normalize(shape)
  return [] if shape.empty?
  min_r = shape.map(&:first).min
  min_c = shape.map(&:last).min
  shape.map { |r, c| [r - min_r, c - min_c] }
end

def rotate_cw(shape)
  shape.map { |r, c| [c, -r] }
end

def flip_h(shape)
  shape.map { |r, c| [r, -c] }
end

def all_orientations(shape)
  orientations = Set.new
  current = shape
  2.times do
    4.times do
      orientations << normalize(current)
      current = rotate_cw(current)
    end
    current = flip_h(shape)
  end
  orientations.to_a
end

def cell_to_bit(r, c, width)
  1 << (r * width + c)
end

# precompute all valid placements for a shape in a grid
# convert shapes to bitmask for faster comparison
def all_placements(shape_orientations, width, height)
  placements = Set.new

  shape_orientations.each do |shape|
    max_r = shape.map(&:first).max
    max_c = shape.map(&:last).max

    (0..(height - 1 - max_r)).each do |pr|
      (0..(width - 1 - max_c)).each do |pc|
        mask = 0
        shape.each { |r,c| mask |= cell_to_bit(pr+r, pc+c, width) }
        placements << mask
      end
    end
  end

  placements
end

def backtrack(shapes_needed, placements_by_type, occupied, idx)
  return true if idx == shapes_needed.size

  shape_idx = shapes_needed[idx]
  placements = placements_by_type[shape_idx]

  placements.each do |mask|
    # collision, skip mask
    next if (mask & occupied) != 0

    # try to place cells, otherwise continue with next mask
    return true if backtrack(shapes_needed, placements_by_type, occupied | mask, idx + 1)
  end

  false
end

def solve(raw, cheat=false)
  shapes, regions = parse(raw)
  shape_orientations = shapes.map { |s| all_orientations(s) }

  total = 0
  regions.each_with_index do |((width, height), counts), step|
    shapes_needed = []
    counts.each_with_index do |cnt, shape_idx|
      cnt.times { shapes_needed << shape_idx }
    end

    total_cells = shapes_needed.sum { |idx| shape_orientations[idx][0].size }
    available = width * height

    puts "Step #{step}: #{width}x#{height}, #{total_cells}/#{available} cells"

    if total_cells > available
      puts "  -> SKIP (area #{total_cells} > #{available})"
      next
    end

    # without this condition part2 runs ~140s which is ok for general solution
    # with condition runs ~7s
    # with cheat flag - 0.05s
    if counts.sum * 9 < available || (cheat && counts.sum * 9 == available)
      total += 1
      puts "  -> YES (fit without packing - #{counts.sum * 9} cells)"
      next
    end

    # precompute all valid placements for each shape type
    placements_by_type = {}
    shapes_needed.uniq.each do |shape_idx|
      placements_by_type[shape_idx] = all_placements(shape_orientations[shape_idx], width, height)
    end

    # sort shapes by number of placements (fewest first = prune faster)
    shapes_needed.sort_by! { |idx| placements_by_type[idx].size }

    result = backtrack(shapes_needed, placements_by_type, 0, 0)
    if result
      total += 1
      puts "  -> YES"
    else
      puts "  -> NO"
    end
  end
  total
end

puts "Test:"
puts solve(tdata)
puts
puts "Real:"
puts solve(data)
