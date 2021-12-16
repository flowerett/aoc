#! /usr/bin/env ruby
require_relative "nanotest"

# p1
# input = "D2FE28"
# input = "38006F45291200"
# input = "EE00D40C823060"
# input = "8A004A801A8002F478"
# input = "620080001611562C8802118E34"
# input = "C0015000016115A2E0802F182340"
# input = "A0016C880162017C3686B18A3D4780"

#p2
# input = "C200B40A82"
# input = "04005AC33890"
# input = "880086C3E88112"
# input = "CE00C43D881120"
# input = "D8005AC2A8F0"
# input = "F600BC2D8F"
# input = "9C005AC2F8F0"
# input = "9C0141080250320F1802104A08"

input = File.read("../inputs/day16")

VERBOSE = ARGV.delete("-v")

OPS = {
  0 => ->(arr) { arr.sum },
  1 => ->(arr) { arr.reduce(&:*) },
  2 => ->(arr) { arr.min },
  3 => ->(arr) { arr.max },
  5 => ->(arr) { a, b = arr; a > b ? 1 : 0 },
  6 => ->(arr) { a, b = arr; a < b ? 1 : 0 },
  7 => ->(arr) { a, b = arr; a == b ? 1 : 0 },
  :noop => ->(_) { raise "halt, unknown operation!" },
}

def prep_data(input)
  input.strip.split("").map { |c|
    c.to_i(16).to_s(2).rjust(4, "0")
  }.join
end

# decode packet
# first 3 bits - version
# second 3 bits - OP ID
# OP 4 - literal (argument packet)
# anything else - operation packet (with it's own arguments)
# root is always a single packet
def decode(str, i, acc)
  v = str[i..i + 2].to_i(2)
  id = str[i + 3..i + 5].to_i(2)
  ix = i + 6

  raise "halt, unknown continue code!" unless %w(0 1).include?(str[ix])
  args, i = (id == 4) ? dec_num(str, ix) : dec_op(str, ix)
  acc << { v: v, id: id, args: args }
  return acc, i
end

# type ID 4 - literal value
# take 4bit numbers
# first bit:
# 1 - continue with next packet,
# 0 - stop and return value
def dec_num(str, i, acc = "")
  acc += str[i + 1..i + 4]
  return [acc.to_i(2), i + 5] if str[i] == ?0

  dec_num(str, i + 5, acc)
end

# process other ID types (0-3, 5-7)
# first bit is type of argument count
# 0 - 15 bit num - subpackets len in bits
# 1 - 11 bit num - number of subpackets
def dec_op(str, i)
  type = str[i]

  len = (type == ?0) ? 15 : 11
  checksum = str[i + 1..i + len].to_i(2)
  acc = []
  ix = i + len + 1

  loop {
    cond = (type == ?0) ? ix - (i + len + 1) : acc.size
    break if cond == checksum
    acc, ix = decode(str, ix, acc)
  }

  return acc, ix
end

def sum_versions(h, acc)
  acc += h[:args].map { |hh| sum_versions(hh, acc) }.sum if h[:id] != 4
  acc += h[:v]
  acc
end

def reduce_bin(h)
  id = h[:id]
  return h[:args] if id == 4

  args = h[:args].map { |hh| reduce_bin(hh) }
  OPS.fetch(id, :noop).call(args)
end

if $0 == __FILE__
  Utils.day(2021, 16)
  data = prep_data(input)
  pp data if VERBOSE

  # start at 0
  acc, p = decode(data, 0, [])
  pp acc[0] if VERBOSE

  r1 = sum_versions(acc[0], 0)
  r2 = reduce_bin(acc[0])

  Utils.pp([r1, r2])

  t = NanoTest.new("test")
  t.assert_all([r1, r2], [938, 1495959086337])
end
