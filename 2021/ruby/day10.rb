#! /usr/bin/env ruby
# require "set"
require_relative "nanotest"

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

def prep_data(input)
  input.strip.split("\n")
    .map { |row| check(row) }
end

def run1(data)
  data.sum { |sc, _| sc }
end

def run2(data)
  scores = data
    .filter { |score, _stack| score == 0 }
    .map do |_score, stack|
    stack
      .reverse
      .map { |c| OPEN_CLOSE[c] }
      .reduce(0) do |acc, c|
      acc *= 5
      acc += COMPLETE_SCORE[c]
    end
  end

  scores.sort[scores.size.div(2)]
end

if $0 == __FILE__
  d = prep_data(input)
  rt = [run1(d), run2(d)]
  t = NanoTest.new()

  Utils.day(2021, 10)
  Utils.pp(rt)
  t.assert_all(rt, [26397, 288957])

  input = File.read("../inputs/day10")
  d = prep_data(input)
  my = [run1(d), run2(d)]
  Utils.pp(my)
  t.assert_all(my, [318081, 4361305341], "task")
end
