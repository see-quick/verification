package main

import (
	"fmt"
)

func isPrime(n uint64) bool {
	if n < 2 {
		return false
	}
	if n == 2 || n == 3 {
		return true
	}
	if n%2 == 0 || n%3 == 0 {
		return false
	}
	for i := uint64(5); i*i <= n; i += 6 {
		if n%i == 0 || n%(i+2) == 0 {
			return false
		}
	}
	return true
}

func main() {
	num := uint64(67280421310721) // 14-digit prime candidate
	fmt.Printf("%d is prime: %v\n", num, isPrime(num))
}
