package main

import (
	"fmt"
	"sync"
	"time"
)

func sumRange(start, end int64, wg *sync.WaitGroup, result *int64) {
	defer wg.Done()
	var sum int64
	for i := start; i <= end; i++ {
		sum += i
	}
	*result = sum
}

func main() {
	start := time.Now()
	var wg sync.WaitGroup
	results := make([]int64, 4)
	partition := int64(250_000_000)

	for i := 0; i < 4; i++ {
		wg.Add(1)
		go sumRange(int64(i)*partition+1, (int64(i)+1)*partition, &wg, &results[i])
	}

	wg.Wait()

	var total int64
	for _, v := range results {
		total += v
	}

	duration := time.Since(start)
	fmt.Printf("Total: %d, Time: %v\n", total, duration)
}
