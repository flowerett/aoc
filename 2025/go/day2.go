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

func makeRange(first, last int) []int {
	var result []int
	for i := first; i <= last; i++ {
		result = append(result, i)
	}
	return result
}

func parse(rawData string) [][]string {
	rows := strings.Split(rawData, ",")
	var data [][]string

	for _, row := range rows {
		trimmed := strings.TrimSpace(row)
		elems := strings.Split(trimmed, "-")

		first, _ := strconv.Atoi(elems[0])
		last, _ := strconv.Atoi(elems[1])
		numbers := makeRange(first, last)

		var strNums []string
		for _, num := range numbers {
			strNums = append(strNums, strconv.Itoa(num))
		}

		data = append(data, strNums)
	}

	return data
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

func solve(data [][]string) {
	var res1 []int
	var res2 []int
	// pattern1 := regexp.MustCompile(`^(.+)\1$`) bummer doesn't work in Go

	for _, row := range data {
		// fmt.Printf("Processing range: %v\n", row)
		for _, digit := range row {
			if matchPart1(digit) {
				num, _ := strconv.Atoi(digit)
				res1 = append(res1, num)
			}
			if matchPart2(digit) {
				num, _ := strconv.Atoi(digit)
				res2 = append(res2, num)
			}
		}
	}

	fmt.Printf("Res, p1: %d\n", sum(res1))
	fmt.Printf("Res, p2: %d\n", sum(res2))
}

func main() {
	tdata := parse(testData)
	// 1227775554, 4174379265
	solve(tdata)

	data, err := os.ReadFile("../inputs/day2")
	if err != nil {
		fmt.Printf("Error reading file: %v\n", err)
		return
	}
	parsedData := parse(string(data))
	solve(parsedData)
}
