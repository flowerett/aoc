#! /usr/bin/env ruby

input = <<INPUT
00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010
INPUT

data = input.split("\n")
# data = File.read("../inputs/day3").split("\n")

# convert input into matrix of binary arrays
m = data.map do |el|
  el.split("").map(&:to_i)
end

# returns [most_common, less_common] pair
def common(bit_arr)
  zeros, ones = bit_arr.partition(&:zero?).map(&:size)
  ones >= zeros ? [1, 0] : [0, 1]
end

# filters given matrix by type
def filter(m, i)
  # transpose matrix
  # get freqs for bit we interested in
  bit = m.transpose[i]

  # find most common digit
  comm = common(bit).first

  # partition by most/less common bit
  # most - ox, less - co2
  ratings = m.partition { |row| row[i] == comm }
  [:ox, :co2].zip(ratings).to_h
end

# recursively find type of rating
# stop when only 1 num remains
# convert to num
def find(m, type, i = 0)
  m = filter(m, i)[type]
  if m.size == 1
    m.first.join("").to_i(2)
  else
    find(m, type, i + 1)
  end
end

#T1
res1 = m
  .transpose # rotate matrix
  .map { |el| common(el) } # for each bit find most/less common
  .transpose # rotate back to get 2 bit arrays
  .map { |el| el.join("").to_i(2) } # convert to num
  .inject(&:*) # multiply 2 nums (gamma * epsilon)

puts "res1: #{res1}"

#T2
ox = find(m, :ox)
co2 = find(m, :co2)

puts "res2: #{ox * co2}"
