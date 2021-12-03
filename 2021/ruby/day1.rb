#! /usr/bin/env ruby
# this one is too simple, don't want to optimize much, just make it work

data = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]
# data = File.read("../inputs/day1").split.map(&:to_i)

# t1
count, prev = 0, nil

data.each { |val|
  count += 1 if !!prev && prev < val
  prev = val
}
puts("res1: #{count}")

# t2
count, prev = 0, nil

data.each_with_index { |val, i|
  #task1 - curr = val and no break
  break if data[i + 2].nil?
  curr = data[i..i + 2].sum

  count += 1 if !!prev && prev < curr
  prev = curr
}

puts("res2: #{count}")
