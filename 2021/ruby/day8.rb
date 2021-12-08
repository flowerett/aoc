#! /usr/bin/env ruby

# segments
#   0:      1:      2:      3:      4:
#  aaaa    ....    aaaa    aaaa    ....
# b    c  .    c  .    c  .    c  b    c
# b    c  .    c  .    c  .    c  b    c
#  ....    ....    dddd    dddd    dddd
# e    f  .    f  e    .  .    f  .    f
# e    f  .    f  e    .  .    f  .    f
#  gggg    ....    gggg    gggg    ....

#   5:      6:      7:      8:      9:
#  aaaa    aaaa    aaaa    aaaa    aaaa
# b    .  b    .  .    c  b    c  b    c
# b    .  b    .  .    c  b    c  b    c
#  dddd    dddd    ....    dddd    dddd
# .    f  e    f  .    f  e    f  .    f
# .    f  e    f  .    f  e    f  .    f
#  gggg    gggg    ....    gggg    gggg

# input = <<INPUT
# acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf
# INPUT

input = <<INPUT
be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
INPUT

# input = File.read("../inputs/day8").strip

data = input.strip.split("\n").map do |row|
  row.split(" | ").map(&:split)
end

# T1
# d1 = {
#   1 => 2, #cf
#   4 => 4, #bcdf
#   7 => 3, #acf
#   8 => 7  #abcdefg
# }
dd1 = [2, 4, 3, 7]

res1 = data.sum do |_in, out|
  out.count { |code| dd1.include?(code.size) }
end

pp "res1: #{res1}"

#T2
# d2 = {
#   0 => 6, #abcefg
#   1 => 2, #cf
#   2 => 5, #acdeg
#   3 => 5, #acdfg
#   4 => 4, #bcdf
#   5 => 5, #abdfg
#   6 => 6, #abdefg
#   7 => 3, #acf
#   8 => 7, #abcdefg
#   9 => 6, #abcdfg
# }

def build_decoder(inp)
  dd = {}

  # 1 - map C-F (right)
  one = inp.find { |el| el.size == 2 }
  dd[:CF] = one.chars

  # 7 - map A (top)
  seven = inp.find { |el| el.size == 3 }
  dd[:A] = seven.chars - dd[:CF]

  # 4 - map B-D (top bottom left corner)
  four = inp.find { |el| el.size == 4 }
  dd[:BD] = four.chars - dd[:CF]

  # 8 - map E-G (bottom bottom left corner)
  eight = inp.find { |el| el.size == 7 }
  dd[:EG] = eight.chars - (dd[:CF] + dd[:BD] + dd[:A])

  # digits with 5 sections (2,3,5), map D-G
  n235 = inp.filter { |el| el.size == 5 }
  dd[:DG] = n235.map do |code|
    code.chars - (dd[:A] + dd[:CF])
  end.find { |rest| rest.size == 2 }

  # map E, G, B, D
  dd[:E] = dd[:EG] - dd[:DG]
  dd[:G] = dd[:EG] - dd[:E]
  dd[:B] = dd[:BD] - dd[:DG]
  dd[:D] = dd[:BD] - dd[:B]

  # digits with 6 sections (0,6,0), map C, F
  n069 = inp.filter { |el| el.size == 6 }
  dd[:C] = n069.map do |code|
    dd[:CF] - code.chars
  end.find { |rest| rest.size == 1 }

  dd[:F] = dd[:CF] - dd[:C]

  # building digits
  dd[0] = (eight.chars - dd[:D]).sort.join
  dd[1] = dd[:CF].sort.join
  dd[2] = (dd[:A] + dd[:DG] + dd[:C] + dd[:E]).sort.join
  dd[3] = (dd[:A] + dd[:DG] + dd[:C] + dd[:F]).sort.join
  dd[4] = four.chars.sort.join
  dd[5] = (dd[:A] + dd[:DG] + dd[:B] + dd[:F]).sort.join
  dd[6] = (dd[:A] + dd[:DG] + dd[:B] + dd[:F] + dd[:E]).sort.join
  dd[7] = seven.chars.sort.join
  dd[8] = eight.chars.sort.join
  dd[9] = (dd[:A] + dd[:DG] + dd[:B] + dd[:F] + dd[:C]).sort.join

  # reverse decoder
  (0..9).map do |i|
    [dd[i], i.to_s]
  end.to_h
end

def decode(d, out)
  out.map do |str|
    d[str.chars.sort.join]
  end.join.to_i
end

res2 = data.map do |inp, out|
  d = build_decoder(inp)
  decode(d, out)
end.sum

pp "res2: #{res2}"
