package org.example;

public class SlowMethodExample {
    public static void main(String[] args) {
        for (int i = 0; i < 5; i++) {
            slowMethod();
        }
    }

    private static void slowMethod() {
        try {
            Thread.sleep(2000); // Simulate slow I/O operation
            System.out.println("Completed slow task");
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}