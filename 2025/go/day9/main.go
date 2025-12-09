package main

import (
	"fmt"
	"os"
	"sort"
	"strings"
)

const testData = `
7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3
`

const testData2 = `
1,1
9,1
9,9
1,9
1,7
7,7
7,3
1,3
`

const testData3 = `
1,1
9,1
9,9
1,9
1,6
7,6
7,3
1,3
`

type Point struct {
	x, y int
}

type Edge struct {
	x1, y1, x2, y2 int
}

type Pair struct {
	area, minX, maxX, minY, maxY int
	p1, p2                       Point
}

type Result struct {
	Part1       int
	Part2       int
	DebugPoints []Point
}

func main() {
	r1 := solve(testData)
	r2 := solve(testData2)
	r3 := solve(testData3)

	for i, r := range []Result{r1, r2, r3} {
		fmt.Printf("Input %d - res %v \n", i+1, r)
	}

	input, _ := os.ReadFile("../../inputs/day9")
	res := solve(string(input))

	fmt.Printf("Res1: %d\n", res.Part1)
	fmt.Printf("Res2: %d, points: %v\n", res.Part2, res.DebugPoints)
}

func solve(input string) Result {
	var res Result
	lines := strings.Split(strings.TrimSpace(input), "\n")

	// parse vertices
	vertices := make([]Point, len(lines))
	for i, line := range lines {
		var x, y int
		fmt.Sscanf(line, "%d,%d", &x, &y)
		vertices[i] = Point{x, y}
	}

	// build edges
	edges := make([]Edge, len(vertices))
	for i := range len(vertices) {
		next := (i + 1) % len(vertices)
		edges[i] = Edge{vertices[i].x, vertices[i].y, vertices[next].x, vertices[next].y}
	}

	// pre-compute pairs with area
	pairs := make([]Pair, 0, len(vertices)*(len(vertices)-1)/2)
	for i := range len(vertices) {
		for j := i + 1; j < len(vertices); j++ {
			p1, p2 := vertices[i], vertices[j]
			minX, maxX := minMax(p1.x, p2.x)
			minY, maxY := minMax(p1.y, p2.y)
			area := (maxX - minX + 1) * (maxY - minY + 1)
			pairs = append(pairs, Pair{area, minX, maxX, minY, maxY, p1, p2})
		}
	}

	// sort pairs by area descending
	sort.Slice(pairs, func(i, j int) bool {
		return pairs[i].area > pairs[j].area
	})

	res.Part1 = pairs[0].area

	// first valid rectangle is result (largest area first)
	for _, pair := range pairs {
		if edgeCrossesInterior(pair.minX, pair.minY, pair.maxX, pair.maxY, edges) {
			continue
		}
		// edge-case check point that 1,1 bigger (inside polygon)
		if !pointInsidePolygon(pair.minX+1, pair.minY+1, edges) {
			continue
		}

		res.Part2 = pair.area
		res.DebugPoints = []Point{pair.p1, pair.p2}
		return res
	}

	return res
}

// does any edge pass strictly through the interior of the rectangle?
func edgeCrossesInterior(minX, minY, maxX, maxY int, edges []Edge) bool {
	for _, e := range edges {
		eMinX, eMaxX := minMax(e.x1, e.x2)
		eMinY, eMaxY := minMax(e.y1, e.y2)

		if e.x1 == e.x2 { // vertical edge
			// edge x must be strictly inside, and edge y range must overlap interior
			if e.x1 > minX && e.x1 < maxX && eMinY < maxY && eMaxY > minY {
				return true
			}
		} else { // horizontal edge
			// edge y must be strictly inside, and edge x range must overlap interior
			if e.y1 > minY && e.y1 < maxY && eMinX < maxX && eMaxX > minX {
				return true
			}
		}
	}
	return false
}

// ray casting: count vertical edges that cross a horizontal ray to the right
func pointInsidePolygon(px, py int, edges []Edge) bool {
	crossings := 0
	for _, e := range edges {
		if e.x1 != e.x2 || e.x1 <= px { // not vertical or not to the right
			continue
		}
		minY, maxY := minMax(e.y1, e.y2)
		if py >= minY && py < maxY {
			crossings++
		}
	}
	return crossings%2 == 1
}

func minMax(a, b int) (int, int) {
	if a < b {
		return a, b
	}
	return b, a
}
