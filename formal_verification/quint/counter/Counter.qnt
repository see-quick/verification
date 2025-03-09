module Counter {
  /// State variable representing the counter
  var count: int

  /// Initial condition: count starts at 0
  action init = {
    count' = 0
  }

  /// Transition: increment the counter up to 10
  action step = any {
    if (count < 10) {
      count' = count + 1
    } else {
      count' = count  // Stays at 10 once reached
    }
  }

  /// Safety invariant: count should never exceed 10
  val TypeInvariant = count <= 10
}
