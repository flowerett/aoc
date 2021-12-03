#! /usr/bin/env ruby

input = <<INPUT
forward 5
down 5
forward 8
up 3
down 8
forward 2
INPUT

data = input.split("\n")
# data = File.read("../inputs/day2t").split("\n")
# data = File.read("../inputs/day2").split("\n")

class Parser
  def initialize(row)
    comm, val = row.split
    @comm = comm.to_sym
    @val = val.to_i
  end

  def get
    return @comm, @val
  end

  def deconstruct_keys(keys)
    Hash[@comm, @val]
  end
end

class Day2
  def initialize(data)
    @data = data
  end

  def run1
    res = @data.inject({ h: 0, v: 0 }) { |memo, row| task1(memo, row) }
    puts("res1: #{res[:h] * res[:v]}")
  end

  # well, ruby pattern matching suck...
  def task1(memo, row)
    case Parser.new(row)
    in forward: Integer => dig
      memo[:h] += dig
    in up: Integer => dig
      memo[:v] -= dig
    in down: Integer => dig
      memo[:v] += dig
    else
      :no_match
    end
    memo
  end
end

def task2(memo, row)
  com, dig = Parser.new(row).get

  case com
  when :forward
    memo[:h] += dig
    memo[:d] += memo[:aim] * dig
  when :up
    memo[:aim] -= dig
  when :down
    memo[:aim] += dig
  end

  memo
end

Day2.new(data).run1

res2 = data.inject({ h: 0, d: 0, aim: 0 }) { |memo, row| task2(memo, row) }
puts("res2: #{res2[:h] * res2[:d]}")
