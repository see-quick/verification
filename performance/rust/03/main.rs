use std::collections::{HashMap, HashSet};
use std::time::Instant;

const N: usize = 10_000_000;

fn benchmark_vec() {
    let start = Instant::now();
    let mut v = Vec::new();
    for i in 0..N {
        v.push(i);
    }
    let duration = start.elapsed();
    println!("Vec Insert: {:?}", duration);

    let start = Instant::now();
    for _ in 0..N {
        v.pop();
    }
    println!("Vec Remove: {:?}", start.elapsed());
}

fn benchmark_hashmap() {
    let start = Instant::now();
    let mut map = HashMap::new();
    for i in 0..N {
        map.insert(i, i);
    }
    println!("HashMap Insert: {:?}", start.elapsed());

    let start = Instant::now();
    for i in 0..N {
        map.remove(&i);
    }
    println!("HashMap Remove: {:?}", start.elapsed());
}

fn benchmark_hashset() {
    let start = Instant::now();
    let mut set = HashSet::new();
    for i in 0..N {
        set.insert(i);
    }
    println!("HashSet Insert: {:?}", start.elapsed());

    let start = Instant::now();
    for i in 0..N {
        set.remove(&i);
    }
    println!("HashSet Remove: {:?}", start.elapsed());
}

fn main() {
    println!("Benchmarking Rust Data Structures with {} elements:", N);
    benchmark_vec();
    benchmark_hashmap();
    benchmark_hashset();
}
