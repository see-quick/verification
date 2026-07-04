package org.example;

import java.util.HashMap;
import java.util.Map;

public class MemoryIntensiveExample {
    public static void main(String[] args) {
        long total = 0;
        for (int i = 0; i < 5_000_000; i++) {
            Map<String, String> map = new HashMap<>();
            map.put("key-" + i, "value-" + i);
            total += map.get("key-" + i).length();
        }
        System.out.println("Total: " + total);
    }
}