package main

import "fmt"

// AssertOne checks if a single result matches the expected solution
func AssertOne[T comparable](res T, solution T, name string) {
	testRes := "."
	if res != solution {
		testRes = "X"
	}
	fmt.Printf("%s: %s\n", name, testRes)
}

// AssertAll checks if all results in a slice match their corresponding solutions
func AssertAll[T comparable](results []T, solutions []T, name string) {
	fmt.Printf("Running tests for all results in %s ...\n", name)
	
	var testResults []string
	for i, r := range results {
		if i >= len(solutions) {
			testResults = append(testResults, "X")
			continue
		}
		if r == solutions[i] {
			testResults = append(testResults, ".")
		} else {
			testResults = append(testResults, "X")
		}
	}
	
	for _, res := range testResults {
		fmt.Print(res, " ")
	}
	fmt.Println()
}
