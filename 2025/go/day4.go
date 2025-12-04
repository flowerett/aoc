package main

import (
	"fmt"
	"os"
	"strings"
)

const testData = `
..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.
`

type Point struct {
	i, j int
}

type Result struct {
	Part1 int
	Part2 int
}

var dirs = []Point{
	{-1, -1}, {-1, 0}, {-1, 1},
	{0, -1}, {0, 1},
	{1, -1}, {1, 0}, {1, 1},
}

func parse(data string) map[Point]struct{} {
	papers := make(map[Point]struct{})

	rows := strings.Split(strings.TrimSpace(data), "\n")
	for i, row := range rows {
		for j, char := range row {
			if char == '@' {
				// struct{}{} is an empty struct
				// more memory efficient than using bool
				papers[Point{i, j}] = struct{}{}
			}
		}
	}
	return papers
}

func solve(data map[Point]struct{}) Result {
	var lifted []int

	for {
		var count int
		data, count = lift(data)
		lifted = append(lifted, count)
		if count == 0 {
			break
		}
	}

	return Result{Part1: lifted[0], Part2: sum(lifted)}
}

func lift(papers map[Point]struct{}) (map[Point]struct{}, int) {
	newPapers := make(map[Point]struct{})
	count := 0

	for point := range papers {
		if countNeighbors(papers, point) < 4 {
			count++
		} else {
			newPapers[point] = struct{}{}
		}
	}

	return newPapers, count
}

func countNeighbors(papers map[Point]struct{}, p Point) int {
	count := 0
	for _, dir := range dirs {
		neighbor := p.add(dir)
		if _, exists := papers[neighbor]; exists {
			count++
		}
	}
	return count
}

func (p Point) add(offset Point) Point {
	return Point{p.i + offset.i, p.j + offset.j}
}

func sum(nums []int) int {
	total := 0
	for _, val := range nums {
		total += val
	}
	return total
}

func main() {
	tdata := parse(testData)
	tres := solve(tdata)
	fmt.Printf("Part 1 (test): %d\n", tres.Part1)
	fmt.Printf("Part 2 (test): %d\n", tres.Part2)

	data, err := os.ReadFile("../inputs/day4")
	if err != nil {
		fmt.Printf("Error reading file: %v\n", err)
		return
	}
	parsedData := parse(string(data))
	res := solve(parsedData)
	fmt.Printf("Part 1: %d\n", res.Part1)
	fmt.Printf("Part 2: %d\n", res.Part2)
}
