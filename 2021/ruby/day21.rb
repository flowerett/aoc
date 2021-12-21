#! /usr/bin/env ruby
require_relative "nanotest"

test = <<INPUT
Player 1 starting position: 4
Player 2 starting position: 8
INPUT

VERBOSE = ARGV.delete("-v")
DEBUG = ARGV.delete("-d")

def parse_data(input)
  input.strip.split("\n").map { |s| s[-1].to_i }
end

def roll(dice)
  return 1 if dice == 100
  dice += 1
end

def move(dice)
  moves = 3.times.sum { |_dice| dice = roll(dice) }
  [moves, dice]
end

def game1(pos)
  dice = 100
  cnt = 0
  scores = [0, 0]
  i = 0
  res = nil

  loop {
    p = i % 2
    pp "-- turn #{i} player #{p}--" if DEBUG
    sc, dice = move(dice)
    cnt += 3
    pp "score: #{sc}, dice: #{dice}, cnt: #{cnt}" if DEBUG

    pos[p] = ((pos[p] + sc - 1) % 10) + 1
    scores[p] += pos[p]

    i += 1

    if scores[p] >= 1000
      res = scores[1 - p] * cnt
      break
    end
  }
  pp pos if VERBOSE
  pp scores if VERBOSE
  res
end

# how many universes where thrown score is (key) after 3 dices
DICE3by3 = Hash.new(0)
[1, 2, 3].each do |u1|
  [1, 2, 3].each do |u2|
    [1, 2, 3].each do |u3|
      DICE3by3[u1 + u2 + u3] += 1
    end
  end
end
pp DICE3by3 if VERBOSE

def game2(pos1, pos2, sc1, sc2, p)
  win = [0, 0]

  cur_pos = p == 0 ? pos1 : pos2
  cur_sc = p == 0 ? sc1 : sc2

  DICE3by3.each { |dice, u|
    new_pos = cur_pos + dice
    new_pos = ((new_pos - 1) % 10) + 1
    new_score = cur_sc + new_pos

    if new_score >= 21
      win[p] += u
    else
      pp "close ==========> #{new_score}" if DEBUG
      nxtp = 1 - p
      win1, win2 = if p == 0
          game2(new_pos, pos2, new_score, sc2, nxtp)
        else
          game2(pos1, new_pos, sc1, new_score, nxtp)
        end

      win[0] += (win1 * u)
      win[1] += (win2 * u)
    end
  }
  pp win if DEBUG
  win
end

def t2(pos)
  p1, p2 = pos
  game2(p1, p2, 0, 0, 0).max
end

if $0 == __FILE__
  Utils.day(2021, 21)
  testd = parse_data(test)
  data = parse_data(File.read("../inputs/day21")).freeze

  puts "running T1..."
  st = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  tr1 = game1(testd.dup)
  r1 = game1(data.dup)
  en1 = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  puts "elapsed #{en1 - st} sec"

  puts "running T2..."
  tr2 = t2(testd.dup)
  r2 = t2(data.dup)
  en2 = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  puts "elapsed #{en2 - st} sec"

  t = NanoTest.new("test")
  t.assert_all([tr1, tr2], [739785, 444356092776315], "example 1")
  t.assert_all([r1, r2], [556206, 630797200227453], "my")

  Utils.pp([r1, r2])
end
