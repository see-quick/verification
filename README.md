# Formal Verification, Compilers, and Testing Repository

This repository contains a collection of formal verification models, compiler experiments, and testing suites designed to improve software reliability and correctness. The projects within this repository utilize TLA+ for formal verification, Java for property-based testing, and ANTLR for compiler development.

## Structure

The repository is organized into several sections:

### Formal Verification

The `formal_verification` directory includes various subdirectories, each targeting different systems and concepts using TLA+:

- **TLA+**: Contains specific implementations for distributed systems algorithms and designs, such as Kafka's leader election, Raft consensus, and simple algorithmic examples.
    - `kafka`: Models focusing on leader election within Kafka.
    - `raft`: Contains implementations for Raft distributed consensus.
    - `simple`: Simple models like Dining Philosophers, Stack operations, and counter implementations.
    - `strimzi`: Models related to Strimzi operations, like topic lifecycle management.

- **Abstract Interpretation**: Contains examples in a point language demonstrating abstract interpretation concepts.
- **Model Checking**: A directory dedicated to examples that demonstrate model checking.

### Compilers

The `compilers` directory contains work related to programming languages and compiler construction:

- **O-language**: A simple imperative language with integer and boolean support, focusing on arithmetic operations and loops.
- **Unicorn-language**: A Java-like language that replaces semicolons (`;`) with `🦄`, built with ANTLR.

### Assembly

The `assembly` directory contains various experiments and implementations related to low-level programming.

### Profiling

The `profiling` directory includes tools and experiments for analyzing performance characteristics of programs.

### Testing

The `testing` directory is focused on software testing methodologies:

- **Performance Testing**: Contains strategies for performance testing, particularly of the `uto` system.
- **Property-Based Testing**: Demonstrates the implementation of property-based testing in Java.

### Other

The `other` directory contains miscellaneous projects and experiments.

### Output

The `out` directory is used for generated or compiled outputs.

## Resources

[1] *Introduction to Static Analysis* - [Link](https://www.amazon.com/Introduction-Static-Analysis-Interpretation-Perspective/dp/0262043416)
