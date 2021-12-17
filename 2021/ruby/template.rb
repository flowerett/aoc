#! /usr/bin/env ruby
# require "set"
# require "enumerator"
require_relative "nanotest"

input = <<INPUT
test
INPUT

# input = File.read("../inputs/day1x")

VERBOSE = ARGV.delete("-v")
DEBUG = ARGV.delete("-d")

def prep_data(input)
  input.strip.split("\n").map { |r| r }
end

data = prep_data(input)
pp data

# if $0 == __FILE__
#   Utils.day(2021, x)
#   t = NanoTest.new("test")
#   t.assert_all(tr, sol, "example 1")

#   Utils.pp([r1, r2])
# end
