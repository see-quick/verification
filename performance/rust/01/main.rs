use std::thread;
use std::time::Instant;

fn sum_range(start: i64, end: i64) -> i64 {
    (start..=end).sum()
}

fn main() {
    let start = Instant::now();
    let partition = 250_000_000;
    let mut handles = vec![];

    for i in 0..4 {
        let s = i * partition + 1;
        let e = (i + 1) * partition;

        handles.push(thread::spawn(move || sum_range(s, e)));
    }

    let total: i64 = handles
        .into_iter()
        .map(|h| h.join().unwrap())
        .sum();

    let duration = start.elapsed();
    println!("Total: {}, Time: {:?}", total, duration);
}
