package io.performance;

import org.openjdk.jmh.annotations.*;

import java.util.*;
import java.util.concurrent.TimeUnit;

@BenchmarkMode(Mode.AverageTime)
@OutputTimeUnit(TimeUnit.MILLISECONDS)
@State(Scope.Thread)
@Timeout(time = 15)
@Threads(2)
@Warmup(iterations = 1, time = 3, timeUnit = TimeUnit.SECONDS)
@Measurement(iterations = 5, time = 3, timeUnit = TimeUnit.SECONDS)
@Fork(value = 1)
public class Day1Benchmark2024 {

    private final int DATA_SIZE = 1_000_000;

    private List<Integer> arrayList;
    private List<Integer> linkedList;
    private PriorityQueue<Integer> priorityQueue;

    /**
     * 1_000 items
     * Benchmark                            Mode  Cnt  Score   Error  Units
     * Day1Benchmark2024.pollPriorityQueue  avgt    5  0.022 ± 0.001  ms/op
     * Day1Benchmark2024.sortArrayList      avgt    5  0.024 ± 0.002  ms/op
     * Day1Benchmark2024.sortLinkedList     avgt    5  0.033 ± 0.009  ms/op
     *
     * 10_000 items
     * Benchmark                            Mode  Cnt  Score   Error  Units
     * Day1Benchmark2024.pollPriorityQueue  avgt    5  0.554 ± 0.033  ms/op
     * Day1Benchmark2024.sortArrayList      avgt    5  0.466 ± 0.130  ms/op
     * Day1Benchmark2024.sortLinkedList     avgt    5  0.654 ± 0.467  ms/op
     *
     * 100_000 items
     * Benchmark                            Mode  Cnt   Score   Error  Units
     * Day1Benchmark2024.pollPriorityQueue  avgt    5  11.983 ± 3.279  ms/op
     * Day1Benchmark2024.sortArrayList      avgt    5  10.347 ± 0.938  ms/op
     * Day1Benchmark2024.sortLinkedList     avgt    5  10.703 ± 0.366  ms/op
     *
     * 1_000_000 items
     * Benchmark                            Mode  Cnt    Score    Error  Units
     * Day1Benchmark2024.pollPriorityQueue  avgt    5  250.467 ± 25.133  ms/op
     * Day1Benchmark2024.sortArrayList      avgt    5  157.029 ± 85.524  ms/op
     * Day1Benchmark2024.sortLinkedList     avgt    5  187.514 ± 38.139  ms/op
     */
    @Setup(Level.Iteration)
    public void setup() {
        Random random = new Random();
        arrayList = new ArrayList<>();
        linkedList = new LinkedList<>();
        priorityQueue = new PriorityQueue<>();

        for (int i = 0; i < DATA_SIZE; i++) {
            int value = random.nextInt();
            arrayList.add(value);
            linkedList.add(value);
            priorityQueue.add(value);
        }
    }

    @Benchmark
    public List<Integer> sortArrayList() {
        List<Integer> listCopy = new ArrayList<>(arrayList);
        Collections.sort(listCopy);
        return listCopy;
    }

    @Benchmark
    public List<Integer> sortLinkedList() {
        List<Integer> listCopy = new LinkedList<>(linkedList);
        Collections.sort(listCopy);
        return listCopy;
    }

    @Benchmark
    public List<Integer> pollPriorityQueue() {
        List<Integer> sorted = new ArrayList<>();
        PriorityQueue<Integer> pqCopy = new PriorityQueue<>(priorityQueue);
        while (!pqCopy.isEmpty()) {
            sorted.add(pqCopy.poll());
        }
        return sorted;
    }
}