package main

import (
	"aoc/2025/go/minitest"
	"testing"
)

func TestDay3Examples(t *testing.T) {
	parsedData := parse(testData)
	tres1 := solve(parsedData, 2)
	tres2 := solve(parsedData, 12)

	minitest.AssertOne(tres1, 357, "Part 1 result")
	minitest.AssertOne(tres2, 3121910778619, "Part 2 result")
}
