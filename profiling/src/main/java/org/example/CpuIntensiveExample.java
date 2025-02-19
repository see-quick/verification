package org.example;

public class CpuIntensiveExample {
    public static void main(String[] args) {
        long start = System.nanoTime();
        findPrimes(50_000); // Find prime numbers up to 50,000
        long end = System.nanoTime();
        System.out.println("Execution time: " + (end - start) / 1_000_000 + " ms");
    }

    private static void findPrimes(int limit) {
        for (int num = 2; num <= limit; num++) {
            if (isPrimeOptimized(num)) {
                System.out.println(num);
            }
        }
    }

    private static boolean isPrime(int num) {
        if (num < 2) return false;
        for (int i = 2; i < num; i++) { // Inefficient loop
            if (num % i == 0) return false;
        }
        return true;
    }

    private static boolean isPrimeOptimized(int num) {
        if (num < 2) return false;
        if (num == 2) return true; // 2 is prime
        if (num % 2 == 0) return false; // Skip even numbers

        // Check only odd numbers up to √num
        for (int i = 3; i * i <= num; i += 2) {
            if (num % i == 0) return false;
        }
        return true;
    }

}