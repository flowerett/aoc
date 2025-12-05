package main

import (
	"aoc/2025/go/minitest"
	"os"
	"testing"
)

func TestExamples(t *testing.T) {
	parsedData := parse(testData)
	tres1 := solve(parsedData, 2)
	tres2 := solve(parsedData, 12)

	minitest.AssertOne(tres1, 357, "Part 1 result")
	minitest.AssertOne(tres2, 3121910778619, "Part 2 result")
}

func TestFile(t *testing.T) {
	data, err := os.ReadFile("../../inputs/day3")
	if err != nil {
		t.Fatalf("Error reading file: %v", err)
	}
	parsedData := parse(string(data))
	res1 := solve(parsedData, 2)
	res2 := solve(parsedData, 12)

	minitest.AssertOne(res1, 17343, "Part 1 file result")
	minitest.AssertOne(res2, 172664333119298, "Part 2 file result")
}
