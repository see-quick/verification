# Formal Verification and Testing Repository

This repository contains a collection of formal verification models and testing suites designed to improve software reliability and correctness. The projects within this repository utilize TLA+ for formal verification and Java for property-based testing.

## Structure

The repository is organized into two main sections: `formal_verification` and `testing`.

### Formal Verification

The `formal_verification` directory includes various subdirectories, each targeting different systems and concepts using TLA+:

- **TLA+**: Contains specific implementations for distributed systems algorithms and designs, such as Kafka's leader election, Raft consensus, and simple algorithmic examples.
    - `kafka`: Models focusing on leader election within Kafka.
    - `raft`: Contains implementations for Raft distributed consensus.
    - `simple`: Simple models like Dining Philosophers, Stack operations, and counter implementations.
    - `strimzi`: Models related to Strimzi operations, like topic lifecycle management.

- **Abstract Interpretation**: Contains examples in a point language demonstrating abstract interpretation concepts.
- **Model Checking**: A directory dedicated to examples that demonstrate model checking.

### Testing

The `testing` directory is focused on software testing methodologies:

- **Performance Testing**: Contains strategies for performance testing, particularly of the `uto` system.
- **Property Based Testing**: Demonstrates the implementation of property-based testing in Java.

#### Resources

[1 Introduction to Static Analysis](https://www.amazon.com/Introduction-Static-Analysis-Interpretation-Perspective/dp/0262043416)