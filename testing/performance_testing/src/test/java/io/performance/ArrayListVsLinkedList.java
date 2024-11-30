package io.performance;

import org.openjdk.jmh.annotations.Benchmark;
import org.openjdk.jmh.annotations.BenchmarkMode;
import org.openjdk.jmh.annotations.Fork;
import org.openjdk.jmh.annotations.Level;
import org.openjdk.jmh.annotations.Measurement;
import org.openjdk.jmh.annotations.Mode;
import org.openjdk.jmh.annotations.OutputTimeUnit;
import org.openjdk.jmh.annotations.Scope;
import org.openjdk.jmh.annotations.Setup;
import org.openjdk.jmh.annotations.State;
import org.openjdk.jmh.annotations.Threads;
import org.openjdk.jmh.annotations.Timeout;
import org.openjdk.jmh.annotations.Warmup;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.concurrent.TimeUnit;

@BenchmarkMode(Mode.Throughput)
@OutputTimeUnit(TimeUnit.MILLISECONDS)
@State(Scope.Thread)
@Timeout(time = 15)
@Threads(value = 2)
@Warmup(iterations = 1, time = 3, timeUnit = TimeUnit.SECONDS)
@Measurement(iterations = 5, time = 3, timeUnit = TimeUnit.SECONDS)
@Fork(value = 1)
public class ArrayListVsLinkedList {

    private static final int MAX_SIZE = 10_000_000;

    private ArrayList<Integer> arrayList;
    private LinkedList<Integer> linkedList;

    @Setup(Level.Iteration)
    public void setup() {
        arrayList = new ArrayList<>();
        linkedList = new LinkedList<>();
    }

    /**
     * 1. LinkedList Performance is Significantly Higher
     *
     * addToLinkedList shows a throughput that is ~213x higher than addToArrayList.
     * This is expected because LinkedList.add(0, element) involves adding a new node at the head of a doubly linked list,
     * which is an O(1) operation.
     * In contrast, ArrayList.add(0, element) involves shifting all elements one position to the right, making it an O(n) operation.
     * ------------------------------------------------------------------------------------------------
     * Benchmark                                    Mode  Cnt      Score       Error   Units
     * ArrayListVsLinkedList.addToFirstArrayList   thrpt    5    170.371 ±     7.397  ops/ms
     * ArrayListVsLinkedList.addToFirstLinkedList  thrpt    5  36622.131 ± 24426.913  ops/ms
     */
    @Benchmark
    public void addToFirstArrayList() {
        arrayList.add(0, 1);
    }

    @Benchmark
    public void addToFirstLinkedList() {
        linkedList.add(0, 1);
    }

    /** without pre-allocation
     * Benchmark                                   Mode  Cnt       Score       Error   Units
     * ArrayListVsLinkedList.addToLastArrayList   thrpt    5  730921.897 ± 80121.419  ops/ms
     * ArrayListVsLinkedList.addToLastLinkedList  thrpt    5   56675.997 ± 14699.860  ops/ms
     */
//    @Benchmark
//    public void addToLastArrayList() {
//        if (arrayList.size() >= MAX_SIZE) {
//            arrayList.clear(); // Reset the list to prevent OOM
//        }
//        arrayList.add(1); // Add to the end
//    }
//
//    @Benchmark
//    public void addToLastLinkedList() {
//        if (linkedList.size() >= MAX_SIZE) {
//            linkedList.clear(); // Reset the list to prevent excessive memory usage
//        }
//        linkedList.addLast(1); // Add to the end
//    }
}
