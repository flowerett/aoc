package main

import (
	"aoc/2025/go/minitest"
	"os"
	"testing"
)

func TestExamples(t *testing.T) {
	parsedData := parse(testData)
	tres := solve(parsedData, 10)

	minitest.AssertOne(tres.Part1, 40, "Part 1 test result")
	minitest.AssertOne(tres.Part2, 25272, "Part 2 test result")
}

func TestFile(t *testing.T) {
	data, err := os.ReadFile("../../inputs/day8")
	if err != nil {
		t.Fatalf("Error reading file: %v", err)
	}
	parsedData := parse(string(data))
	res := solve(parsedData, 1000)

	minitest.AssertOne(res.Part1, 181584, "Part 1 file result")
	minitest.AssertOne(res.Part2, 8465902405, "Part 2 file result")
}
