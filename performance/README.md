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
| Go       | 03   | Data Structure Performance Test (10M)  | 2915 ms            |
| Rust     | 03   | Data Structure Performance Test (10M)  | 1927 ms            |

## Comparison in table...

| Test | Go (ms)                | Rust (ms)                   |
|------|------------------------|-----------------------------|
| 00   | ██████████ 271 ms      | ██████████████████ 515 ms   |
| 01   | ███ 70 ms              | ▏ <1 ms (0.07 ms)           |
| 02   | ██████████ 277 ms      | █████████ 204 ms            |
| 03   | ████████████████████████████████ 2915 ms | ██████████████████████ 1927 ms |

```
█ = ~50 ms
```

## Data Structure Performance Breakdown

### **Go (10,000,000 elements)**
- **Slice Insert:** 18.3ms
- **Slice Remove:** 5.76ms
- **Map Insert:** 626.7ms
- **Map Remove:** 630.3ms
- **Set Insert:** 606.9ms
- **Set Remove:** 624.6ms

**Total Execution Time:** **2.915s**

### **Rust (10,000,000 elements)**
- **Vec Insert:** 24.0ms
- **Vec Remove:** 5.54ms
- **HashMap Insert:** 349.0ms
- **HashMap Remove:** 507.9ms
- **HashSet Insert:** 297.3ms
- **HashSet Remove:** 492.3ms

**Total Execution Time:** **1.927s**

