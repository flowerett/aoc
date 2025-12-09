package main

import (
	"aoc/2025/go/minitest"
	"os"
	"testing"
)

func TestExamples(t *testing.T) {
	var tres Result
	tres = solve(testData)
	minitest.AssertOne(tres.Part1, 50, "Inp 1, r1")
	minitest.AssertOne(tres.Part2, 24, "Inp 1, r2")

	tres = solve(testData2)
	minitest.AssertOne(tres.Part1, 81, "Inp 2, r1")
	minitest.AssertOne(tres.Part2, 27, "Inp 2, r2")

	tres = solve(testData3)
	minitest.AssertOne(tres.Part1, 81, "Inp 3, r1")
	minitest.AssertOne(tres.Part2, 36, "Inp 3, r2")
}

func TestFile(t *testing.T) {
	data, _ := os.ReadFile("../../inputs/day9")
	res := solve(string(data))

	minitest.AssertOne(res.Part1, 4746238001, "Part 1 file result")
	minitest.AssertOne(res.Part2, 1552139370, "Part 2 file result")
}
