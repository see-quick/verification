use std::time::Instant;

fn main() {
    let start = Instant::now();
    let mut sum: i64 = 0;
    for i in 1..=1_000_000_000 {
        sum = sum.wrapping_add(i);
    }
    let duration = start.elapsed();
    println!("Sum: {}, Time: {:?}", sum, duration);
}
