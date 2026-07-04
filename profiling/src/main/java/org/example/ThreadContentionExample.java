package org.example;

public class ThreadContentionExample {
    private static final Object LOCK = new Object();
    private static long sharedCounter = 0;

    public static void main(String[] args) throws InterruptedException {
        Thread[] threads = new Thread[8];
        for (int i = 0; i < threads.length; i++) {
            threads[i] = new Thread(ThreadContentionExample::work);
            threads[i].start();
        }
        for (Thread t : threads) {
            t.join();
        }
        System.out.println("Counter: " + sharedCounter);
    }

    private static void work() {
        for (int i = 0; i < 1_000_000; i++) {
            synchronized (LOCK) {
                sharedCounter++;
                busyWork();
            }
        }
    }

    private static void busyWork() {
        double x = 1.0;
        for (int i = 0; i < 50; i++) {
            x = Math.sin(x) + Math.cos(x);
        }
    }
}