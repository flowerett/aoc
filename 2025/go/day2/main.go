package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

const testData = `
11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124
`

type NumberRange struct {
	Start int
	End   int
}

type Result struct {
	Part1 int
	Part2 int
}

func parse(rawData string) []NumberRange {
	rows := strings.Split(rawData, ",")
	var ranges []NumberRange

	for _, row := range rows {
		trimmed := strings.TrimSpace(row)
		elems := strings.Split(trimmed, "-")

		first, _ := strconv.Atoi(elems[0])
		last, _ := strconv.Atoi(elems[1])

		ranges = append(ranges, NumberRange{Start: first, End: last})
	}

	return ranges
}

func matchPart1(s string) bool {
	length := len(s)
	if length%2 != 0 {
		return false
	}
	mid := length / 2
	return s[:mid] == s[mid:]
}

func matchPart2(s string) bool {
	length := len(s)

	// all possible pattern lengths from 1 to length/2
	for patternLen := 1; patternLen <= length/2; patternLen++ {
		// continue if the string length is not divisible by pattern length
		if length%patternLen != 0 {
			continue
		}

		// get the potential pattern
		pattern := s[:patternLen]
		matches := true

		// check if this pattern repeats throughout the string
		for i := patternLen; i < length; i += patternLen {
			if s[i:i+patternLen] != pattern {
				matches = false
				break
			}
		}

		if matches {
			return true
		}
	}

	return false
}

func sum(nums []int) int {
	total := 0
	for _, val := range nums {
		total += val
	}
	return total
}

func solve(ranges []NumberRange) Result {
	var res1 []int
	var res2 []int
	// pattern1 := regexp.MustCompile(`^(.+)\1$`) bummer, backreferences doesn't work in Go

	for _, r := range ranges {
		// fmt.Printf("Processing range: %d-%d\n", r.Start, r.End)
		for i := r.Start; i <= r.End; i++ {
			numStr := strconv.Itoa(i)
			if matchPart1(numStr) {
				res1 = append(res1, i)
			}
			if matchPart2(numStr) {
				res2 = append(res2, i)
			}
		}
	}

	return Result{Part1: sum(res1), Part2: sum(res2)}
}

func main() {
	tdata := parse(testData)
	tres := solve(tdata)
	fmt.Printf("Part 1 (test): %d\n", tres.Part1)
	fmt.Printf("Part 2 (test): %d\n", tres.Part2)

	data, err := os.ReadFile("../inputs/day2")
	if err != nil {
		fmt.Printf("Error reading file: %v\n", err)
		return
	}
	parsedData := parse(string(data))
	res := solve(parsedData)
	fmt.Printf("Part 1: %d\n", res.Part1)
	fmt.Printf("Part 2: %d\n", res.Part2)
}
