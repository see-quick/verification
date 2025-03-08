# Language Performance Comparison

## HTTP Server Benchmark (wrk -t12 -c1000 -d30s http://localhost:8080/)

### **Go**
```
Running 30s test @ http://localhost:8080/
  12 threads and 1000 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     8.99ms  666.81us  36.06ms   86.88%
    Req/Sec     9.21k   679.94    10.00k    96.92%
  3298243 requests in 30.02s, 408.91MB read
  Socket errors: connect 0, read 3313, write 0, timeout 0
Requests/sec: 109876.59
Transfer/sec:     13.62MB
```

### **Rust**
```
Running 30s test @ http://localhost:8080/
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    19.64ms    8.09ms  80.86ms   78.49%
    Req/Sec    46.08    166.34     8.54k    99.53%
  13328 requests in 30.06s, 676.81KB read
  Socket errors: connect 0, read 623616, write 0, timeout 0
Requests/sec:    443.45
Transfer/sec:     22.52KB
```

### **C**
```
Running 30s test @ http://localhost:8080/
  12 threads and 1000 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    15.19ms    5.10ms  89.51ms   89.28%
    Req/Sec    84.63     77.57     3.01k    90.98%
  28425 requests in 30.04s, 1.41MB read
  Socket errors: connect 0, read 921246, write 0, timeout 0
Requests/sec:    946.35
Transfer/sec:     48.06KB
```

## Directory Structure and Performance

| Language | Test | Description                            | Execution Time (ms) |
|----------|------|----------------------------------------|---------------------|
| Go       | 00   | Single-threaded CPU-intensive          | 271 ms             |
| Go       | 01   | Concurrent CPU-intensive (goroutines)  | 70 ms              |
| Rust     | 00   | Single-threaded CPU-intensive          | 515 ms             |
| Rust     | 01   | Concurrent CPU-intensive (threads)     | <1 ms (0.07 ms)    |
| Go       | 02   | Large Prime Check (67280421310721)     | 277 ms             |
| Rust     | 02   | Large Prime Check (67280421310721)     | 204 ms             |
| Go       | 03   | Data Structure Performance Test (10M)  | 2540 ms            |
| Rust     | 03   | Data Structure Performance Test (10M)  | 1689 ms            |
| C        | 03   | Data Structure Performance Test (10M)  | 315 ms             |

## Comparison in table...

| Test | Go (ms)                | Rust (ms)                   | C (ms)               |
|------|------------------------|-----------------------------|----------------------|
| 00   | ██████████ 271 ms      | ██████████████████ 515 ms   |                      |
| 01   | ███ 70 ms              | ▏ <1 ms (0.07 ms)           |                      |
| 02   | ██████████ 277 ms      | █████████ 204 ms            |                      |
| 03   | ███████████████████████████ 2540 ms | ██████████████████ 1689 ms | ███ 315 ms |

```
█ = ~50 ms
```

## Data Structure Performance Breakdown

### **Go (10,000,000 elements)**
- **Slice Insert:** 9.1ms
- **Slice Remove:** 2.7ms
- **Map Insert:** 626.6ms
- **Map Remove:** 657.1ms
- **Set Insert:** 607.2ms
- **Set Remove:** 626.7ms

**Total Execution Time:** **2.540s**

### **Rust (10,000,000 elements)**
- **Vec Insert:** 9.3ms
- **Vec Remove:** 2.5ms
- **HashMap Insert:** 339.8ms
- **HashMap Remove:** 517.5ms
- **HashSet Insert:** 282.7ms
- **HashSet Remove:** 520.6ms

**Total Execution Time:** **1.689s**

### **C (10,000,000 elements)**
- **Array Insert:** 0.003ms
- **Array Remove:** 0.001ms
- **HashMap Insert:** 55.59ms
- **HashMap Remove:** 94.88ms

**Total Execution Time:** **0.315s**

