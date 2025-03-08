package main

import (
    "fmt"
    "time"
)

func main() {
    start := time.Now()
    var sum int64 = 0
    for i := int64(1); i <= 1_000_000_000; i++ {
        sum += i
    }
    duration := time.Since(start)
    fmt.Printf("Sum: %d, Time: %v\n", sum, duration)
}
