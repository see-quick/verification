package org.example;

public class ThreadContentionExample {
    private static final Object LOCK = new Object();

    public static void main(String[] args) {
        for (int i = 0; i < 10; i++) {
            new Thread(ThreadContentionExample::criticalSection).start();
        }
    }

    private static void criticalSection() {
        synchronized (LOCK) {
            try {
                Thread.sleep(1000); // Simulate work in critical section
                System.out.println(Thread.currentThread().getName() + " completed work.");
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}