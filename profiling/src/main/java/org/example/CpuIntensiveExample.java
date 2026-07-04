package org.example;

public class CpuIntensiveExample {
    public static void main(String[] args) {
        int count = 0;
        for (int num = 2; num <= 200_000; num++) {
            if (isPrime(num)) {
                count++;
            }
        }
        System.out.println("Found " + count + " primes");
    }

    private static boolean isPrime(int num) {
        if (num < 2) return false;
        for (int i = 2; i < num; i++) {
            if (num % i == 0) return false;
        }
        return true;
    }
}