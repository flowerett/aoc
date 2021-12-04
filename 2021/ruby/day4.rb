#! /usr/bin/env ruby

# input = <<INPUT
# 7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

# 22 13 17 11  0
#  8  2 23  4 24
# 21  9 14 16  7
#  6 10  3 18  5
#  1 12 20 15 19

#  3 15  0  2 22
#  9 18 13 17  5
# 19  8  7 25 23
# 20 11 10 24  4
# 14 21 16 12  6

# 14 21 17 24  4
# 10 16 15  9 19
# 18  8 23 26 20
# 22 11 13  6  5
#  2  0 12  3  7
# INPUT

input = File.read("../inputs/day4").strip

data = input.split("\n\n").map(&:strip)
nums = data[0]
boards = data[1..]
nums = nums.split(",").map(&:strip)


# convert input into matrix of binary arrays
# m = data.map do |el|
#   el.split("").map(&:to_i)
# end

def prep_board(b)
  board = {}
  b.each_with_index do |el, ind|
    r, c = ind.divmod(5)
    board[el] = {r: r+1, c: c+1, w: false}
  end

  board[:r] = {}
  board[:c] = {}
  board[:w] = false

  (1..5).each do |i|
    board[:r][i] = 0
    board[:c][i] = 0
  end

  board
end

def prep_boards(bds)
  bds.map do |b|
    b = b.split().map(&:strip)
    prep_board(b)
  end
end

def move(board, num)
  # win = false
  if board.has_key?(num)
    el = board[num]
    el[:w] = true
    rk = el[:r]
    ck = el[:c]
    board[num] = el #write win back

    board[:r][rk] += 1
    board[:c][ck] += 1
    puts("#{num} - r#{rk} - #{board[:r][rk]} >>>")
    puts("#{num} - c#{ck} - #{board[:c][rk]} >>>")

    if board[:r][rk] == 5 or board[:c][ck] == 5
      board[:w] = true
      # win = true
    end
  end
  board[:w]
end

def calc_winner(board, num)
  win_sum = 0
  num = num.to_i
  board.each do |k, v|
    unless [:r, :c, :w].include?(k)
      unless board[k][:w]
        win_sum += k.to_i
      end
    end
  end

  p win_sum, num
  win_sum * num
end

def play1(nums, boards)
  nums.each do |num|
    boards.each_with_index do |b, ind|
      if !b[:w] && move(b, num)
        p "b#{ind}wins - #{num}"
        p calc_winner(b, num)
      end
    end
  end
end


#T1
pboards = prep_boards(boards)

play1(nums, pboards)

# res1 = m
# puts "res1: #{res1}"

#T2
