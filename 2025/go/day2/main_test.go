package main

import (
	"aoc/2025/go/minitest"
	"os"
	"testing"
)

func TestDay2Examples(t *testing.T) {
	minitest.AssertOne(matchPart1("11881188"), true, "P1: 11881188 should match")
	minitest.AssertOne(matchPart1("1234"), false, "P1: 1234 should not match")
	minitest.AssertOne(matchPart1("123123"), true, "P1: 123123 should match")
	minitest.AssertOne(matchPart1("101"), false, "P1: 101 should not match")

	minitest.AssertOne(matchPart2("111"), true, "P2: 111 should match")
	minitest.AssertOne(matchPart2("123123"), true, "P2: 123123 should match")
	minitest.AssertOne(matchPart2("565656"), true, "P2: 565656 should match")
	minitest.AssertOne(matchPart2("1234"), false, "P2: 1234 should not match")

	tres := solve(parse(testData))
	minitest.AssertOne(tres.Part1, 1227775554, "Part 1 result")
	minitest.AssertOne(tres.Part2, 4174379265, "Part 2 result")
}

func TestFile(t *testing.T) {
	data, err := os.ReadFile("../../inputs/day2")
	if err != nil {
		t.Fatalf("Error reading file: %v", err)
	}
	res := solve(parse(string(data)))

	minitest.AssertOne(res.Part1, 12586854255, "Part 1 file result")
	minitest.AssertOne(res.Part2, 17298174201, "Part 2 file result")
}
