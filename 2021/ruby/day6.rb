#! /usr/bin/env ruby

input = <<INPUT
3,4,3,1,2
INPUT

# input = File.read("../inputs/day6").strip

data = input.strip.split(",").map(&:to_i).freeze

def grow(data, days)
  data = data.dup.map { |f| [f, 1] }

  days.times do |_|
    num_new = 0
    data.each_with_index do |f, i|
      if f[0] == 0
        data[i][0] = 6
        num_new += data[i][1]
      else
        data[i][0] -= 1
      end
    end

    data.push([8, num_new]) if num_new > 0
  end

  data.map { |f| f[1] }.sum
end

pp "res1: #{grow(data, 80)}"
pp "res2: #{grow(data, 256)}"
