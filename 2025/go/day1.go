package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

const testData = `L68
L30
R48
L5
R60
L55
L1
L99
R14
L82`

func solve(data string) {
	start := 50
	pos := start
	zeros := 0
	wraps := 0

	instructions := strings.Fields(strings.TrimSpace(data))

	// returns index, value
	for _, instruction := range instructions {
		// parse
		sign := -1
		if instruction[0] == 'R' {
			sign = 1
		}
		num, _ := strconv.Atoi(instruction[1:])

		laps := num / 100
		steps := num % 100

		newVal := pos + sign*steps
		newPos := pmod(newVal, 100)

		newWraps := wraps + laps
		if newPos == 0 || (newVal < 0 && pos != 0) || (newVal >= 100) {
			newWraps++
		}

		if newPos == 0 {
			zeros++
		}

		pos = newPos
		wraps = newWraps
	}

	fmt.Printf("Zeros (T1): %d\n", zeros)
	fmt.Printf("Wraps (T2): %d\n", wraps)
}

// Go's modulo operator returns negative values, we need next function to
// return positive modulo results
func pmod(x, d int) int {
	x = x % d
	if x >= 0 {
		return x
	}
	if d < 0 {
		return x - d
	}
	return x + d
}

func main() {
	solve(testData)

	data, err := os.ReadFile("../inputs/day1")
	if err != nil {
		fmt.Printf("Error reading file: %v\n", err)
		return
	}
	solve(string(data))
}
