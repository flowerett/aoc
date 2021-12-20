#! /usr/bin/env ruby
require 'set'
# require "enumerator"
require_relative "nanotest"

input = <<INPUT
--- scanner 0 ---
404,-588,-901
528,-643,409
-838,591,734
390,-675,-793
-537,-823,-458
-485,-357,347
-345,-311,381
-661,-816,-575
-876,649,763
-618,-824,-621
553,345,-567
474,580,667
-447,-329,318
-584,868,-557
544,-627,-890
564,392,-477
455,729,728
-892,524,684
-689,845,-530
423,-701,434
7,-33,-71
630,319,-379
443,580,662
-789,900,-551
459,-707,401

--- scanner 1 ---
686,422,578
605,423,415
515,917,-361
-336,658,858
95,138,22
-476,619,847
-340,-569,-846
567,-361,727
-460,603,-452
669,-402,600
729,430,532
-500,-761,534
-322,571,750
-466,-666,-811
-429,-592,574
-355,545,-477
703,-491,-529
-328,-685,520
413,935,-424
-391,539,-444
586,-435,557
-364,-763,-893
807,-499,-711
755,-354,-619
553,889,-390

--- scanner 4 ---
727,592,562
-293,-554,779
441,611,-461
-714,465,-776
-743,427,-804
-660,-479,-426
832,-632,460
927,-485,-438
408,393,-506
466,436,-512
110,16,151
-258,-428,682
-393,719,612
-211,-452,876
808,-476,-593
-575,615,604
-485,667,467
-680,325,-822
-627,-443,-432
872,-547,-609
833,512,582
807,604,487
839,-516,451
891,-625,532
-652,-548,-490
30,-46,-14
INPUT

VERBOSE = ARGV.delete("-v")
DEBUG = ARGV.delete("-d")
T1 = ARGV.delete("-t1")
T2 = ARGV.delete("-t2")

# https://github.com/okainov/advent-of-code-2021/blob/master/python/day_19.py

# def rotations()
#   rot = []
#   dd = [1, -1]
#   dd.each {|x| dd.each {|y|  dd.each{|z| rot << [x,y,z] }}}
#   rot
# end
# [0,1,2].permutation.to_a
PERM = [
  [0, 1, 2],
  [0, 2, 1],
  [1, 0, 2],
  [1, 2, 0],
  [2, 0, 1],
  [2, 1, 0]
]
ROT = [
 [1, 1, 1],
 [1, 1, -1],
 [1, -1, 1],
 [1, -1, -1],
 [-1, 1, 1],
 [-1, 1, -1],
 [-1, -1, 1],
 [-1, -1, -1]
] # should be 24 ???

MM = PERM.size * ROT.size

def prep_data(input)
  input.strip.split("\n\n").reduce({}) do |data, block|
    h, *r = block.strip.split("\n")
    k = h.split[2].to_i
    beacons = r.map{ |rr| rr.split(",").map(&:to_i) }
    data[k] = beacons
    data
  end
end

# [-364, -763, -893]
# [   1,   -1,   -1]
# [-892, -824, -901]
# [-364,  763,  893]
def rdist(coord, rel)
  coord.zip(rel).map{|a, b| a - b}.sum
end

# don't get why it's 24, use 48
def mutate(row)
  PERM.map do |x,y,z|
    [row[x],row[y],row[z]]
  end.map do |row|
    ROT.map{ |rt| row.zip(rt).map{|a, r| a * r }}
  end.flatten(1)
end

def delta(p1, p2)
  p1.zip(p2).map {|a, b| a-b }
end

def normalize(p1, p2)
  p1.zip(p2).map {|a, b| a+b }
end

def dist(p1, p2)
  p1.zip(p2).map { |a, b| (a-b).abs }.sum
end

def compare(v1, v2)
  vars = v2.map { |b| mutate(b) }

  res = {match: false}
  MM.times.each do |i|
    vars.each do |bz| #how to speedup???
      v1.each do |ba|
        off = delta(ba, bz[i]) #slow!!!

        v2s = vars.map {|bb| normalize(bb[i], off)}.to_set

        ints = v1.intersection(v2s)

        if ints.size >= 12
          res[:match] = true
          res[:i] = i
          res[:off] = off
          res[:vars] = v2s
          return res
        end
      end
    end
  end
  res
end

input = File.read("../inputs/day19t")
data = prep_data(input)

# add beacons from 0 beacon to known
scanners = {0 => [0,0,0]}
known = data[0].to_set

# pp data.size
# pp "known:"
# pp known
# pp known.size

missing = data.keys.to_set.delete(0)
# speedup my res
# missing = [17,20,24,29,10,23,11,30,7,19,21,25,27,33,4,5,6,8,12,14,22,31,32,1,2,3,9,13,15,16,18,26,28].to_set

if T1
  until missing.empty?
    pp missing
    missing.each do |k2|
      unless scanners.key?(k2) #skip known
        v2 = data[k2]
        pp "comparing known:#{known.size} - #{k2}:#{v2.size}"

        r = compare(known, v2)
        if r[:match]
          scanners[k2] = r[:off]
          # pp [r, 0, k2]
          known.merge(r[:vars])
          missing.delete(k2)
        end
      end
    end
  end
  pp "res1: #{known.size}"
  pp "scanners for T2:"
  pp scanners
end

#T2
if T2
  scanners = {
    0=>[0, 0, 0],
    1=>[68, -1246, -43],
    3=>[-92, -2380, -20],
    4=>[-20, -1133, 1061],
    2=>[1105, -1205, 1229]
  }
  # scanners = {
  #   0 => [0, 0, 0],
  #   17 => [96, 1235, 107],
  #   20 => [-1145, -57, 139],
  #   24 => [-1243, 46, -1130],
  #   29 => [-1, -1142, 56],
  #   10 => [-1216, 1165, -1052],
  #   23 => [-1191, -38, -2388],
  #   11 => [-2254, -77, -2271],
  #   30 => [-3490, -13, -2353],
  #   7 => [-3636, -1135, -2269],
  #   19 => [-4658, -1254, -2239],
  #   21 => [-3604, -52, -1099],
  #   25 => [-3517, 1202, -2343],
  #   27 => [-3478, -1284, -1212],
  #   33 => [-4724, -1255, -3626],
  #   4 => [-4738, -2411, -3610],
  #   5 => [-5895, -1139, -2259],
  #   6 => [-3456, -2358, -2307],
  #   8 => [-6018, -1091, -1151],
  #   12 => [-4778, -80, -3568],
  #   14 => [-4787, -2403, -1107],
  #   22 => [-3597, -2291, -1205],
  #   31 => [-6011, 35, -2356],
  #   32 => [-3613, -2442, 155],
  #   1 => [-6014, 67, -1181],
  #   2 => [-5973, -2323, -3620],
  #   3 => [-7221, 40, -1194],
  #   9 => [-2388, -2298, 58],
  #   13 => [-7168, 1135, -1179],
  #   15 => [-8293, 1300, -1124],
  #   16 => [-3622, -3626, -1184],
  #   18 => [-7105, 25, -2318],
  #   26 => [-8361, -37, -1096],
  #   28 => [-2258, -3667, -1217]
  # }

  maxd = 0
  scanners.each do |_, a|
    scanners.each do |_, b|
      d = dist(a, b)
      maxd = d if d > maxd
    end
  end

  pp "res2: #{maxd}"
end


# if $0 == __FILE__
#   Utils.day(2021, x)
#   t = NanoTest.new("test")
#   t.assert_all(tr, sol, "example 1")

#   Utils.pp([r1, r2])
# end
