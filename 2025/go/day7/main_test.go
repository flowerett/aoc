package main

import (
	"aoc/2025/go/minitest"
	"os"
	"testing"
)

func TestExamples(t *testing.T) {
	parsedData := parse(testData)
	tres := solve(parsedData)

	minitest.AssertOne(tres.Part1, 21, "Part 1 test result")
	minitest.AssertOne(tres.Part2, 40, "Part 2 test result")
}

func TestFile(t *testing.T) {
	data, err := os.ReadFile("../../inputs/day7")
	if err != nil {
		t.Fatalf("Error reading file: %v", err)
	}
	parsedData := parse(string(data))
	res := solve(parsedData)

	minitest.AssertOne(res.Part1, 1675, "Part 1 file result")
	minitest.AssertOne(res.Part2, 187987920774390, "Part 2 file result")
}
