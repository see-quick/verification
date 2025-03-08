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

## Comparison in table...

| Test | Go (ms)                | Rust (ms)                   |
|------|------------------------|-----------------------------|
| 00   | ██████████ 271 ms      | ██████████████████ 515 ms   |
| 01   | ███ 70 ms              | ▏ <1 ms (0.07 ms)           |
| 02   | ██████████ 277 ms      | █████████ 204 ms            |

```
█ = ~50 ms
```

