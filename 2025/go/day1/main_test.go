package main

import (
	"aoc/2025/go/minitest"
	"os"
	"testing"
)

func TestExamples(t *testing.T) {
	tres := solve(testData)

	minitest.AssertOne(tres.Part1, 3, "Part 1 result")
	minitest.AssertOne(tres.Part2, 6, "Part 2 result")
}

func TestFile(t *testing.T) {
	data, err := os.ReadFile("../../inputs/day1")
	if err != nil {
		t.Fatalf("Error reading file: %v", err)
	}
	res := solve(string(data))

	minitest.AssertOne(res.Part1, 1034, "Part 1 file result")
	minitest.AssertOne(res.Part2, 6166, "Part 2 file result")
}
