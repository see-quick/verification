package io.performance;

import org.openjdk.jmh.annotations.*;

import java.util.HashSet;
import java.util.TreeSet;
import java.util.concurrent.TimeUnit;

@BenchmarkMode(Mode.Throughput)
@OutputTimeUnit(TimeUnit.MILLISECONDS)
@State(Scope.Thread)
@Timeout(time = 15)
@Threads(value = 2)
@Warmup(iterations = 1, time = 3, timeUnit = TimeUnit.SECONDS)
@Measurement(iterations = 5, time = 3, timeUnit = TimeUnit.SECONDS)
@Fork(value = 1)
public class HashSetVsTreeSet {

    private static final int DATA_SIZE = 1_000;

    private HashSet<Integer> hashSet;
    private TreeSet<Integer> treeSet;

    @Setup(Level.Iteration)
    public void setup() {
        hashSet = new HashSet<>();
        treeSet = new TreeSet<>();
        for (int i = 0; i < DATA_SIZE; i++) {
            hashSet.add(i);
            treeSet.add(i);
        }
    }

    /**
     * HashSet: Backed by a HashMap, offering O(1) average complexity.
     * TreeSet: Backed by a TreeMap, providing O(log n) complexity and maintaining sorted order.
     *
     * Benchmark                          Mode  Cnt        Score        Error   Units
     * HashSetVsTreeSet.addHashSet       thrpt    5   794076.290 ± 496411.771  ops/ms
     * HashSetVsTreeSet.addTreeSet       thrpt    5   112753.085 ±  11084.394  ops/ms
     * HashSetVsTreeSet.containsHashSet  thrpt    5  1674300.907 ± 185622.782  ops/ms
     * HashSetVsTreeSet.containsTreeSet  thrpt    5   166111.596 ±   7450.862  ops/ms
     */
    @Benchmark
    public void addHashSet() {
        hashSet.add(DATA_SIZE + 1);
    }

    @Benchmark
    public void addTreeSet() {
        treeSet.add(DATA_SIZE + 1);
    }

    @Benchmark
    public void containsHashSet() {
        hashSet.contains(DATA_SIZE / 2);
    }

    @Benchmark
    public void containsTreeSet() {
        treeSet.contains(DATA_SIZE / 2);
    }
}