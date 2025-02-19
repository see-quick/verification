package org.example;

import java.util.ArrayList;
import java.util.List;

public class MemoryIntensiveExample {
    public static void main(String[] args) {
        List<int[]> bigList = new ArrayList<>();
        for (int i = 0; i < 10_000; i++) {
            bigList.add(new int[1_000_000]); // Allocate large arrays
            System.out.println("Allocated " + (i + 1) + "MB");
        }
    }
}