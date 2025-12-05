package main

import (
	"fmt"
	"os"
	"strings"
)

const testData = `
987654321111111
811111111111119
234234234234278
818181911112111
`

type digitPos struct {
	value int
	pos   int
}

func pow10(n int) int {
	result := 1
	for i := 0; i < n; i++ {
		result *= 10
	}
	return result
}

func parse(rawData string) [][]int {
	rows := strings.Split(strings.TrimSpace(rawData), "\n")
	grid := make([][]int, len(rows))

	for i, row := range rows {
		grid[i] = make([]int, len(row))
		for j, char := range row {
			grid[i][j] = int(char - '0')
		}
	}
	return grid
}

func solve(data [][]int, numLen int) int {
	width := len(data[0])

	sum := 0
	for _, row := range data {
		start := 0
		rowSum := 0

		for cur := numLen - 1; cur >= 0; cur-- {
			end := width - cur
			maxDigit := findMaxInRange(row, start, end)
			start = maxDigit.pos + 1
			rowSum += maxDigit.value * pow10(cur)
		}
		sum += rowSum
	}
	return sum
}

// get max left digit in subarray (max value, leftmost position)
func findMaxInRange(row []int, start, end int) digitPos {
	maxDigit := digitPos{value: row[start], pos: start}

	for pos := start + 1; pos < end; pos++ {
		val := row[pos]

		if val > maxDigit.value {
			maxDigit = digitPos{value: val, pos: pos}
		}
	}

	return maxDigit
}

// edge case for struct with two fields
// for more complex cases, we can use function like:
// (max by x, min by y, min by z)
// func (a Pos) isBetter(b Pos) bool {
//     if a.x != b.x { return a.x > b.x }
//     if a.y != b.y { return a.y < b.y }
//     return a.z < b.z
// }
// sort.Slice(positions, func(i, j int) bool {
//     return positions[i].isBetter(positions[j])
// })

func main() {
	// 357
	// 3121910778619
	tdata := parse(testData)
	tres1 := solve(tdata, 2)
	tres2 := solve(tdata, 12)
	fmt.Printf("Part 1 (test): %d\n", tres1)
	fmt.Printf("Part 2 (test): %d\n", tres2)

	data, err := os.ReadFile("../../inputs/day3")
	if err != nil {
		fmt.Printf("Error reading file: %v\n", err)
		return
	}
	// 17343
	// 172664333119298
	parsedData := parse(string(data))
	res1 := solve(parsedData, 2)
	res2 := solve(parsedData, 12)
	fmt.Printf("Part 1: %d\n", res1)
	fmt.Printf("Part 2: %d\n", res2)
}
