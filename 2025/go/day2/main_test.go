package main

import (
	"aoc/2025/go/minitest"
	"testing"
)

func TestDay2Examples(t *testing.T) {
	minitest.AssertOne(matchPart1("11881188"), true, "Part1: 11881188 should match")
	minitest.AssertOne(matchPart1("1234"), false, "Part1: 1234 should not match")
	minitest.AssertOne(matchPart1("123123"), true, "Part1: 123123 should match")
	minitest.AssertOne(matchPart1("101"), false, "Part1: 101 should not match")

	minitest.AssertOne(matchPart2("111"), true, "Part2: 111 should match")
	minitest.AssertOne(matchPart2("123123"), true, "Part2: 123123 should match")
	minitest.AssertOne(matchPart2("565656"), true, "Part2: 565656 should match")
	minitest.AssertOne(matchPart2("1234"), false, "Part2: 1234 should not match")

	tres := solve(parse(testData))
	minitest.AssertOne(tres.Part1, 1227775554, "Part 1 result")
	minitest.AssertOne(tres.Part2, 4174379265, "Part 2 result")
}
