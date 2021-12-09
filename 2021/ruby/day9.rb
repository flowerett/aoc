#! /usr/bin/env ruby
require "set"

input = <<INPUT
2199943210
3987894921
9856789892
8767896789
9899965678
INPUT

# input = File.read("../inputs/day9").strip

data = input.strip.split("\n").map do |row|
  row.split("").map(&:to_i)
end

# T1
res1 = []
H = data.size
L = data[0].size

def find_nbh(d, i, j)
  vn = [i - 1, i + 1].reject { |n| (n < 0) || (n >= H) }
  hn = [j - 1, j + 1].reject { |n| (n < 0) || (n >= L) }

  [vn, hn]
end

data.each_with_index do |row, i|
  row.each_with_index do |d, j|
    vn, hn = find_nbh(d, i, j)
    if vn.all? { |v| d < data[v][j] } && hn.all? { |h| d < data[i][h] }
      res1 << [d, i, j]
    end
  end
end

pp "res1: #{res1.sum { |r| r[0] + 1 }}"

# T2
def point_with_key(x, i, j, type)
  if type == :v
    [x, j, x * L + j]
  else
    [i, x, i * L + x]
  end
end

# it's faster to grab all neighbours that are not 9
# so check if neighbour is d+1 can be omitted
def find_basin_nbh(i, j, dd)
  v_idx = [i - 1, i + 1].filter { |ii| (ii >= 0) && (ii < H) && dd[ii][j] != 9 } #&& dd[ii][j] >= d}
  h_idx = [j - 1, j + 1].filter { |jj| (jj >= 0) && (jj < L) && dd[i][jj] != 9 } #&& dd[i][jj] >= d}

  [[v_idx, :v], [h_idx, :h]].map do |idx, type|
    idx.map do |x|
      point_with_key(x, i, j, type)
    end
  end.flatten(1)
end

def calc_basin(point, basin, data)
  i, j = point

  find_basin_nbh(i, j, data)
    .map do |ii, jj, key|
    unless basin.include?(key)
      basin.add(key)
      [ii, jj]
    end
  end
    .compact
    .reduce(basin) do |acc, p|
    calc_basin(p, acc, data)
  end
end

res2 = res1.map do |_d, i, j|
  calc_basin([i, j], Set[i * L + j], data).size
end

# pp res2.max(3)
pp "res2: #{res2.max(3).reduce(:*)}"
