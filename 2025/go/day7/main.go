package main

import (
	"fmt"
	"os"
	"strings"
)

const testData = `
.......S.......
...............
.......^.......
...............
......^.^......
...............
.....^.^.^.....
...............
....^.^...^....
...............
...^.^...^.^...
...............
..^...^.....^..
...............
.^.^.^.^.^...^.
...............
`

type Result struct {
	Part1 int
	Part2 int
	Debug any
}

type Input struct {
	Start     Point
	Splitters map[Point]struct{}
	Size      int
}

type Point struct {
	y, x int
}

func parse(data string) Input {
	rows := strings.Split(strings.TrimSpace(data), "\n")
	start := Point{0, 0}
	splitters := make(map[Point]struct{})

	for y, row := range rows {
		for x, char := range row {
			if char == 'S' {
				start = Point{y, x}
			}
			if char == '^' {
				splitters[Point{y, x}] = struct{}{}
			}
		}
	}

	return Input{Start: start, Splitters: splitters, Size: len(rows)}
}

func solve(data Input) Result {
	splits := 0
	times := make(map[Point]int)
	times[data.Start] = 1

	for i := 0; i < data.Size; i++ {
		rowTimes := make(map[Point]int)
		for p, t := range times {
			_, exists := data.Splitters[Point{i, p.x}]
			if exists {
				splits++
				rowTimes[Point{i, p.x - 1}] += t
				rowTimes[Point{i, p.x + 1}] += t
			} else {
				rowTimes[Point{i, p.x}] += t
			}
		}
		times = rowTimes
	}

	numTimes := 0
	for _, t := range times {
		numTimes += t
	}

	return Result{Part1: splits, Part2: numTimes}
}

func main() {
	tdata := parse(testData)
	tres := solve(tdata)
	fmt.Printf("Part 1 (test): %d\n", tres.Part1)
	fmt.Printf("Part 2 (test): %d\n", tres.Part2)

	data, err := os.ReadFile("../../inputs/day7")
	if err != nil {
		fmt.Printf("Error reading file: %v\n", err)
		return
	}
	parsedData := parse(string(data))
	res := solve(parsedData)
	fmt.Printf("Part 1: %d\n", res.Part1)
	fmt.Printf("Part 2: %d\n", res.Part2)
}
