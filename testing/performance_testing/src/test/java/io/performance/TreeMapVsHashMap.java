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

import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;
import java.util.concurrent.TimeUnit;

@BenchmarkMode(Mode.Throughput)
@OutputTimeUnit(TimeUnit.MILLISECONDS)
@State(Scope.Thread)
@Timeout(time = 15)
@Threads(value = 2)
@Warmup(iterations = 1, time = 3, timeUnit = TimeUnit.SECONDS)
@Measurement(iterations = 5, time = 3, timeUnit = TimeUnit.SECONDS)
@Fork(value = 1)
public class TreeMapVsHashMap {

    private static final int DATA_SIZE = 1_000;

    private Map<Integer, Integer> hashMap;
    private TreeMap<Integer, Integer> treeMap;

    @Setup(Level.Iteration)
    public void setup() {
        hashMap = new HashMap<>();
        treeMap = new TreeMap<>();
        for (int i = 0; i < DATA_SIZE; i++) {
            int value = i * 10;
            hashMap.put(i, value);
            treeMap.put(i, value);
        }
    }

    /**
     * HashMap: Backed by a hash table, offering O(1) average complexity for most operations.
     * TreeMap: Backed by a red-black tree, providing O(log n) operations and maintaining sorted order.
     *
     * Benchmark                     Mode  Cnt        Score        Error   Units
     * TreeMapVsHashMap.getHashMap  thrpt    5  1691658.735 ±  50866.559  ops/ms
     * TreeMapVsHashMap.getTreeMap  thrpt    5   144765.037 ±   4210.951  ops/ms
     * TreeMapVsHashMap.putHashMap  thrpt    5   754794.523 ± 135308.963  ops/ms
     * TreeMapVsHashMap.putTreeMap  thrpt    5   113490.755 ±   2015.297  ops/ms
     */
    @Benchmark
    public void putHashMap() {
        hashMap.put(DATA_SIZE + 1, 42);
    }

    @Benchmark
    public void putTreeMap() {
        treeMap.put(DATA_SIZE + 1, 42);
    }

    @Benchmark
    public void getHashMap() {
        hashMap.get(DATA_SIZE / 2);
    }

    @Benchmark
    public void getTreeMap() {
        treeMap.get(DATA_SIZE / 2);
    }
}
