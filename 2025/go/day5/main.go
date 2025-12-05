package main

import (
	"fmt"
	"os"
	"sort"
	"strconv"
	"strings"
)

const testData = `
3-5
10-14
16-20
12-18

1
5
8
11
17
32
`

type Range struct {
	Start int
	End   int
}

type Input struct {
	Ranges  []Range
	Numbers []int
}

type Result struct {
	Part1 int
	Part2 int
	Debug any
}

func parse(data string) Input {
	input := Input{Ranges: []Range{}, Numbers: []int{}}

	parts := strings.Split(strings.TrimSpace(data), "\n\n")

	for _, line := range strings.Split(parts[0], "\n") {
		rangeParts := strings.Split(line, "-")
		start, _ := strconv.Atoi(rangeParts[0])
		end, _ := strconv.Atoi(rangeParts[1])
		input.Ranges = append(input.Ranges, Range{Start: start, End: end})
	}

	fields := strings.Fields(parts[1])
	for _, field := range fields {
		num, _ := strconv.Atoi(field)
		input.Numbers = append(input.Numbers, num)
	}

	return input
}

func inRange(num int, ranges []Range) bool {
	for _, rn := range ranges {
		if num >= rn.Start && num <= rn.End {
			return true
		}
	}
	return false
}

func (r Range) Size() int {
	return r.End - r.Start + 1
}

func solve(input Input) Result {
	merged := compact(input.Ranges)
	res := Result{Part1: 0, Part2: 0, Debug: merged}

	for _, num := range input.Numbers {
		if inRange(num, merged) {
			res.Part1++
		}
	}

	for _, rn := range merged {
		res.Part2 += rn.Size()
	}

	return res
}

func compact(ranges []Range) []Range {
	// check edge-cases
	if len(ranges) == 0 {
		return ranges
	}

	sort.Slice(ranges, func(i, j int) bool {
		return ranges[i].Start < ranges[j].Start
	})

	merged := []Range{ranges[0]}

	for _, curr := range ranges[1:] {
		// pointer to last
		last := &merged[len(merged)-1]

		if curr.Start <= last.End+1 {
			last.End = max(last.End, curr.End)
		} else {
			merged = append(merged, curr)
		}
	}

	return merged
}

func main() {
	tdata := parse(testData)
	tres := solve(tdata)
	fmt.Printf("Part 1 (test): %d\n", tres.Part1)
	fmt.Printf("Part 2 (test): %d\n", tres.Part2)
	// fmt.Printf("Debug: %v\n", tres.Debug)

	data, err := os.ReadFile("../../inputs/day5")
	if err != nil {
		fmt.Printf("Error reading file: %v\n", err)
		return
	}
	parsedData := parse(string(data))
	res := solve(parsedData)
	fmt.Printf("Part 1: %d\n", res.Part1)
	fmt.Printf("Part 2: %d\n", res.Part2)
}
