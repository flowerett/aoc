#!/usr/bin/env ruby
# frozen_string_literal: true

# modified inputs to test both part1 and part2
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
    _ind, *shape = rs.split("\n")

    parsed = Set.new
    shape.each_with_index.map do |r, i|
      r.split('').each_with_index do |c, j|
        parsed << [i, j] if c == '#'
      end
    end
    parsed
  end
end

MAX=2

def place_at(shape, coord)
  row, col = coord
  shape.map { |r, c| [row + r, col + c] }.to_set
end

def rotate_cw(shape)
  shape.reduce(Set.new){ |acc, (r,c)| acc << [c, MAX-r] }
end

# horizontal flip
def mirror(shape)
  shape.reduce(Set.new){ |acc, (r,c)| acc << [r, MAX-c] }
end

def collides?(a, b)
  (a & b).any?
end

def in_bounds?(shape, height, width)
  shape.all? { |r, c| r >= 0 && r < height && c >= 0 && c < width }
end

def all_vars(shape)
  variants = Set.new
  [shape, mirror(shape)].each do |sv|
    cur = sv
    4.times do
      variants << cur
      cur = rotate_cw(cur)
    end
  end
  variants
end

def visualize(height, width, *placed_shapes)
  grid = Array.new(height) { Array.new(width, '.') }
  placed_shapes.each_with_index do |shape, idx|
    label = ('A'.ord + idx).chr
    shape.each { |r, c| grid[r][c] = label }
  end
  grid.each { |row| puts row.join }
end

# def pshape(shape)
#   for r in 0..MAX
#     puts (0..MAX).map{|c| shape.include?([r, c]) && '#' || '.'}.join
#   end
#   puts "\n"
# end

def solve_step(s_req, height, width)
  check_coll = lambda do |a, b, height, width|
    check = collides?(a, b)
    a_fit = in_bounds?(a, height, width)
    b_fit = in_bounds?(b, height, width)

    res = !check && a_fit && b_fit
    # if res
    #   puts "Collides: #{check}"
    #   puts "A in bounds: #{a_fit}"
    #   puts "B in bounds: #{b_fit}"
    #   visualize(height, width, a, b)
    # end
    return [res, a | b]
  end

  find_fit = lambda do |pos_vars, a, b|
    for a_pos, b_pos in pos_vars do
      for bvar in all_vars(b) do
        av_pl = place_at(a, a_pos)
        bv_pl = place_at(bvar, b_pos)

        is_fit, res = check_coll.call(av_pl, bv_pl, height, width)

        return [is_fit, res] if is_fit
      end
    end

    return [false, nil]
  end

  pos_vars = (0..height-MAX)
    .flat_map {|rvar| (0..width-MAX)
    .map {|cvar| [rvar, cvar] }}
    .combination(2).to_a

  merged = s_req[0]
  can_fit = true

  s_req[1..].each do |shape_b|
    # check pair
    check, res = find_fit.call(pos_vars, merged, shape_b)
    can_fit = can_fit && check

    break if !can_fit
    merged = res
  end

  can_fit
end

def solve(raw)
  shapes, regions = parse(raw)

  total = 0
  regions.each_with_index do |((height, width), pos), step|
    pp "step: #{step}"
    # pp [height, width, pos]

    s_req = []
    pos.each_with_index do |num, ii|
     num.times { s_req << shapes[ii]}
    end
    # pp s_req

    res = solve_step(s_req, height, width)
    total += 1 if res
    pp res
  end
  total
end

# part2 only
def solve_cheat(raw)
  shapes, regions = parse(raw)
  # pp shapes.map {|s| s.size }
  regions.count { |(h, w), counts| counts.sum * 9 <= h * w }
end

pp solve(tdata)
pp solve_cheat(data)
