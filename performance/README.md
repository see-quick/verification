# Language Performance Comparison

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

