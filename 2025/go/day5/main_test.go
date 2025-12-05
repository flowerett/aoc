package main

import (
	"aoc/2025/go/minitest"
	"os"
	"testing"
)

func TestExamples(t *testing.T) {
	parsedData := parse(testData)
	tres := solve(parsedData)

	minitest.AssertOne(tres.Part1, 3, "Part 1 test result")
	minitest.AssertOne(tres.Part2, 14, "Part 2 test result")
}

func TestFile(t *testing.T) {
	data, err := os.ReadFile("../../inputs/day5")
	if err != nil {
		t.Fatalf("Error reading file: %v", err)
	}
	parsedData := parse(string(data))
	res := solve(parsedData)

	minitest.AssertOne(res.Part1, 821, "Part 1 file result")
	minitest.AssertOne(res.Part2, 344771884978261, "Part 2 file result")
}
