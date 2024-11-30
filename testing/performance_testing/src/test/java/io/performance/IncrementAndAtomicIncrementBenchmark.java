package io.performance;

import org.openjdk.jmh.annotations.Benchmark;
import org.openjdk.jmh.annotations.BenchmarkMode;
import org.openjdk.jmh.annotations.Fork;
import org.openjdk.jmh.annotations.Mode;
import org.openjdk.jmh.annotations.OutputTimeUnit;
import org.openjdk.jmh.annotations.Scope;
import org.openjdk.jmh.annotations.State;
import org.openjdk.jmh.annotations.Threads;
import org.openjdk.jmh.annotations.Timeout;

import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

@BenchmarkMode(Mode.Throughput)
@OutputTimeUnit(TimeUnit.MILLISECONDS)
@State(Scope.Thread)
@Fork(value = 1)
@Timeout(time = 30)
@Threads(value = 8)
/**
 * 1.	Throughput:
 * 	testRegularIncrement achieves 2x the throughput of testAtomicIncrement.
 * 	This is expected because regularCounter++ is a simple, non-thread-safe operation, while atomicCounter.incrementAndGet()
 * 	ensures atomicity and incurs synchronization overhead.
 */
public class IncrementAndAtomicIncrementBenchmark {

    private int regularCounter = 0;
    private AtomicInteger atomicCounter = new AtomicInteger(0);

    @Benchmark
    public void testRegularIncrement() {
        regularCounter++;
    }

    @Benchmark
    public void testAtomicIncrement() {
        atomicCounter.incrementAndGet();
    }
}
