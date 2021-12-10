#! /usr/bin/env ruby
# require "set"

input = <<INPUT
[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]
INPUT

# input = File.read("../inputs/day10").strip

data = input.strip.split("\n")

# T1
# close-open for check
CLOSE_OPEN = {
  ?) => ?(,
  ?] => ?[,
  ?} => ?{,
  ?> => ?<,
}

ERR_SCORE = {
  ?) => 3,
  ?] => 57,
  ?} => 1197,
  ?> => 25137,
}

def check(row)
  stack = []
  err_score = 0

  row.chars.each do |c|
    if CLOSE_OPEN.values.include?(c)
      stack.append(c)
    elsif stack.pop != CLOSE_OPEN[c]
      err_score = ERR_SCORE[c]
      break
    end
  end

  return err_score, stack
end

data = data.map { |row| check(row) }

res1 = data.sum { |sc, _| sc }
pp "res1: #{res1}"

# T2
# open-close - back conversion
OPEN_CLOSE = {
  ?( => ?),
  ?[ => ?],
  ?{ => ?},
  ?< => ?>,
}

COMPLETE_SCORE = {
  ?) => 1,
  ?] => 2,
  ?} => 3,
  ?> => 4,
}

r2 = data.filter { |score, _stack| score == 0 }
  .map do |_score, stack|
  stack.reverse
    .map { |c| OPEN_CLOSE[c] }
    .reduce(0) do |acc, c|
    acc *= 5
    acc += COMPLETE_SCORE[c]
  end
end

pp "res2: #{r2.sort[r2.size.div(2)]}"
