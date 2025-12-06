package main

import (
	"fmt"
	"os"
	"slices"
	"strconv"
	"strings"
)

const testData = `
123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +  
`

type Result struct {
	Part1 int
	Part2 int
	Debug Input
}

type Input struct {
	Data []string
	Ops  []string
}

func parse(data string) Input {
	// trim trailing \n for test input
	data = strings.Trim(data, "\n")

	rows := strings.Split(data, "\n")
	ops := strings.Fields(rows[len(rows)-1])
	parsed := rows[0 : len(rows)-1]

	return Input{Data: parsed, Ops: ops}
}

type Column struct {
	Nums []int
	Op   string
}

func solve(data Input) Result {
	res1 := calcSum(parse1(data))
	res2 := calcSum(parse2(data))
	return Result{Part1: res1, Part2: res2, Debug: data}
}

func parse1(data Input) []Column {
	parsed := make([][]int, len(data.Ops))

	for _, row := range data.Data {
		for i, num := range strings.Fields(row) {
			pnum, _ := strconv.Atoi(num)
			parsed[i] = append(parsed[i], pnum)
		}
	}

	return zipColumns(parsed, data.Ops)
}

func parse2(data Input) []Column {
	vNums := make([]string, len(data.Data[0]))

	for _, row := range data.Data {
		chars := strings.Split(row, "")
		slices.Reverse(chars)
		for i, sym := range chars {
			vNums[i] += sym
		}
	}

	// fmt.Printf("vNums: %q\n", vNums)
	parsed := make([][]int, len(data.Ops))

	i := 0
	for _, vNum := range vNums {
		vNum = strings.TrimSpace(vNum)
		pnum, _ := strconv.Atoi(vNum)
		if pnum == 0 {
			i++
			continue
		} else {
			parsed[i] = append(parsed[i], pnum)
		}
	}

	slices.Reverse(parsed)
	// fmt.Printf("parsed: %v\n", parsed)

	return zipColumns(parsed, data.Ops)
}

func calcSum(columns []Column) int {
	sum := 0
	for _, col := range columns {
		subSum := col.Nums[0]
		for _, num := range col.Nums[1:] {
			switch col.Op {
			case "*":
				subSum *= num
			case "+":
				subSum += num
			}
		}
		sum += subSum
	}
	return sum
}

func zipColumns(nums [][]int, ops []string) []Column {
	var zipped []Column
	for i, colNums := range nums {
		zipped = append(zipped, Column{Nums: colNums, Op: ops[i]})
	}
	return zipped
}

func main() {
	tdata := parse(testData)
	tres := solve(tdata)
	fmt.Printf("Part 1 (test): %d\n", tres.Part1)
	fmt.Printf("Part 2 (test): %d\n", tres.Part2)
	// fmt.Printf("Debug: %+v\n", tres.Debug)

	data, err := os.ReadFile("../../inputs/day6")
	if err != nil {
		fmt.Printf("Error reading file: %v\n", err)
		return
	}
	parsedData := parse(string(data))
	res := solve(parsedData)
	fmt.Printf("Part 1: %d\n", res.Part1)
	fmt.Printf("Part 2: %d\n", res.Part2)
}
