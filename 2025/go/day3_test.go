package main

import (
	"testing"
)

func TestDay3Examples(t *testing.T) {
	parsedData := parse(testData)
	tres1 := solve(parsedData, 2)
	tres2 := solve(parsedData, 12)

	AssertOne(tres1, 357, "Part 1 result")
	AssertOne(tres2, 3121910778619, "Part 2 result")
}
