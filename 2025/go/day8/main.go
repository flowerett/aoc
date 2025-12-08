package main

import (
	"fmt"
	"os"
	"sort"
	"strconv"
	"strings"
)

const testData = `
162,817,812
57,618,57
906,360,560
592,479,940
352,342,300
466,668,158
542,29,236
431,825,988
739,650,466
52,470,668
216,146,977
819,987,18
117,168,530
805,96,715
346,949,466
970,615,88
941,993,340
862,61,35
984,92,344
425,690,689
`

type Point [3]int

type Pair struct {
	P1, P2 Point
	Dist   int
}

type Result struct {
	Part1 int
	Part2 int
}

func parse(data string) []Point {
	lines := strings.Split(strings.TrimSpace(data), "\n")
	points := make([]Point, len(lines))
	for idx, line := range lines {
		parts := strings.Split(strings.TrimSpace(line), ",")
		var p Point
		for i, part := range parts {
			val, _ := strconv.Atoi(part)
			p[i] = val
		}
		points[idx] = p
	}
	return points
}

func sq(x int) int {
	return x * x
}

func dist(a, b Point) int {
	return sq(a[0]-b[0]) + sq(a[1]-b[1]) + sq(a[2]-b[2])
}

type DSU map[Point]Point

func (dsu DSU) find(x Point) Point {
	if parent, ok := dsu[x]; ok {
		if parent == x {
			return x
		}
		root := dsu.find(parent)
		dsu[x] = root // path compression: point directly to the root
		return root
	}
	dsu[x] = x // x is not in DSU, adding it
	return x
}

func (dsu DSU) union(a, b Point) {
	rootA := dsu.find(a)
	rootB := dsu.find(b)
	if rootA != rootB {
		dsu[rootB] = rootA
	}
}

func (d DSU) size3largest() int {
	counts := make(map[Point]int)

	for node := range d {
		root := d.find(node)
		counts[root]++
	}

	var sizes []int
	for _, size := range counts {
		sizes = append(sizes, size)
	}

	sort.Slice(sizes, func(i, j int) bool {
		return sizes[i] > sizes[j]
	})

	return sizes[0] * sizes[1] * sizes[2]
}

func solve(points []Point, n int) Result {
	// making pairs with triangle matrix traversal
	// . x x x
	//   . x x
	//     . x
	//       .
	var pairs []Pair
	for i := range points {
		for j := i + 1; j < len(points); j++ {
			p1 := points[i]
			p2 := points[j]
			d := dist(p1, p2)
			pairs = append(pairs, Pair{P1: p1, P2: p2, Dist: d})
		}
	}

	sort.Slice(pairs, func(i, j int) bool {
		return pairs[i].Dist < pairs[j].Dist
	})

	dsu := make(DSU)
	var res Result
	totalPoints := len(points)

	for step, pair := range pairs {
		// we don't need to initialize points in dsu
		// find inside union will do that
		dsu.union(pair.P1, pair.P2)

		if step == n-1 {
			res.Part1 = dsu.size3largest()
		}

		if len(dsu) == totalPoints {
			res.Part2 = pair.P1[0] * pair.P2[0]
			return res
		}
	}
	return res
}

func main() {
	tdata := parse(testData)
	tres := solve(tdata, 10)
	fmt.Printf("Part 1 (test): %d\n", tres.Part1)
	fmt.Printf("Part 2 (test): %d\n", tres.Part2)

	data, err := os.ReadFile("../../inputs/day8")
	if err != nil {
		fmt.Printf("Error reading file: %v\n", err)
		return
	}

	parsedData := parse(string(data))
	res := solve(parsedData, 1000)
	fmt.Printf("Part 1: %d\n", res.Part1)
	fmt.Printf("Part 2: %d\n", res.Part2)
}
