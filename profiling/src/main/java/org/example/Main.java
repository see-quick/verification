package org.example;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.UUID;

public class Main {

    public static void main(String[] args) {
//        memoryLeak();
        fixedMemoryLeak();
    }

    public static void memoryLeak() {
        final Map<String, String> cache = new HashMap<>();

        while (true) {
            String key = UUID.randomUUID().toString();
            cache.put(key, "Leak" + key);

            // Simulating work
            if (cache.size() % 10000 == 0) {
                System.out.println("Cache size: " + cache.size());
            }
        }
    }

    public static void fixedMemoryLeak() {
        final int MAX_SIZE = 10000;
        final Map<String, String> cache = new LinkedHashMap<>(MAX_SIZE, 0.75f, true) {
            protected boolean removeEldestEntry(Map.Entry<String, String> eldest) {
                return size() > MAX_SIZE;
            }
        };

        while (true) {
            String key = UUID.randomUUID().toString();
            cache.put(key, "Leak" + key);

            // Simulating work
            if (cache.size() % 10000 == 0) {
                System.out.println("Cache size: " + cache.size());
            }
        }
    }
}