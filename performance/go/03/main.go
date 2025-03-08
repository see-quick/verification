package main

import (
	"fmt"
	"time"
)

const N = 10000000

func benchmarkSlice() {
	start := time.Now()
	slice := make([]int, 0, N)
	for i := 0; i < N; i++ {
		slice = append(slice, i)
	}
	fmt.Println("Slice Insert:", time.Since(start))

	start = time.Now()
	for len(slice) > 0 {
		slice = slice[:len(slice)-1]
	}
	fmt.Println("Slice Remove:", time.Since(start))
}

func benchmarkMap() {
	start := time.Now()
	m := make(map[int]int)
	for i := 0; i < N; i++ {
		m[i] = i
	}
	fmt.Println("Map Insert:", time.Since(start))

	start = time.Now()
	for i := 0; i < N; i++ {
		delete(m, i)
	}
	fmt.Println("Map Remove:", time.Since(start))
}

func benchmarkSet() {
	start := time.Now()
	set := make(map[int]struct{})
	for i := 0; i < N; i++ {
		set[i] = struct{}{}
	}
	fmt.Println("Set Insert:", time.Since(start))

	start = time.Now()
	for i := 0; i < N; i++ {
		delete(set, i)
	}
	fmt.Println("Set Remove:", time.Since(start))
}

func main() {
	fmt.Printf("Benchmarking Go Data Structures with %d elements:\n", N)
	benchmarkSlice()
	benchmarkMap()
	benchmarkSet()
}
