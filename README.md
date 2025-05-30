# Formal Verification, Compilers, and Testing Repository

This repository contains a collection of formal verification models, compiler experiments, and testing suites designed to improve software reliability and correctness. The projects within this repository utilize TLA+ for formal verification, Java for property-based testing, and ANTLR for compiler development.

## Structure

The repository is organized into several sections:

- Formal Verification
- Compilers
- Assembly
- Profiling
- Performance
- Testing
- Other

### Formal Verification

The `formal_verification` directory includes various subdirectories, each targeting different systems and concepts:

- **TLA+**: Contains specific implementations for distributed systems algorithms and designs. Models cover areas like Kafka's leader election, Raft consensus, Strimzi topic lifecycle management, and various simple algorithmic examples (e.g., Dining Philosophers, Stack operations, counter implementations). The Strimzi models (see `formal_verification/TLA+/strimzi/README.md`) delve into operator behavior, Zookeeper interactions, failover/recovery, scaling, and more.

- **Quint**: A specification language and tool used for modeling and verifying systems, similar to TLA+. This section includes examples of Quint for distributed systems like leader election in a ring network (`formal_verification/quint/distributed_systems/leader_election_ring/README.md`) and simple concurrent scenarios like deadlock detection (`formal_verification/quint/simple/deadlock_example/README.md`). Quint is also utilized for model-based testing.

- **Abstract Interpretation**: Features examples using a "point language" to illustrate static analysis concepts by analyzing program states in a 2D geometric space. This approach helps in understanding how abstractions can prove safety properties (e.g., a point never entering a negative x-axis). More details can be found in `formal_verification/abstract_interpretation/point_language/README.md`.

- **Model Checking**: This section provides examples (like `formal_verification/model_checking/example/wire.tla`) and an overview of model checking concepts, a method to verify complex interactions in concurrent and distributed systems by exhaustively exploring system states against a formal property. See `formal_verification/model_checking/README.md` for more details, including references to TLA+ as a specification language for model checking."

### Compilers

The `compilers` directory contains work related to programming languages and compiler construction:

- **O-language**: A simple arithmetic language supporting integers and basic operations (`+`, `-`, `*`, `/`). It's designed for educational purposes, demonstrating lexical analysis, parsing, and x86 assembly code generation. The grammar and examples can be found in `compilers/OLang/README.md`.
- **Unicorn-language**: A Java-like experimental language built with ANTLR where semicolons (`;`) are replaced with `🦄`. It supports variable declarations, function definitions, and while loops, and compiles into Java code. See `compilers/Unicorn/README.md` for more details and examples.
- **C-compiler (Tacky-to-Assembly)**: A minimal compiler for a subset of C, illustrating lexing, parsing, TACKY IR (Three-Address Code) generation, Assembly IR generation (with pseudo-registers), and final x86-64 assembly emission. Details of its stages and grammar are in `compilers/Compiler-Design/II/README.md`."

### Assembly

The `assembly` directory contains various experiments and implementations related to low-level programming, with a particular focus on assembly for macOS M3 (aarch64). It includes examples and build/debug instructions (see `assembly/README.md`).

### Profiling

The `profiling` directory includes tools and experiments for analyzing performance characteristics of programs.

### Performance

The `performance` directory contains benchmarks and comparisons of different programming languages for various tasks. Key highlights include:

- **HTTP Server Benchmarks**: Performance tests (using `wrk`) comparing HTTP server implementations in Go, Rust, and C.
- **CPU-Intensive Tasks**: Comparisons for single-threaded and concurrent CPU-intensive operations.
- **Large Number Computations**: Tests like large prime number checking.
- **Data Structure Performance**: Benchmarks for operations (insert, remove) on common data structures (slices/vectors, maps/hashmaps, sets/hashsets) in Go, Rust, and C.

Detailed results and methodologies can be found in `performance/README.md`.

### Testing

The `testing` directory is focused on software testing methodologies:

- **Model-Based Testing**: This directory (`testing/model_based_testing`) is intended for model-based testing projects. (Note: The current `README.md` in this directory duplicates the content of Mutation Testing.)
- **Mutation Testing**: Demonstrates evaluating test suite effectiveness by introducing small code changes (mutations) and checking if tests detect them. Uses PIT, a popular mutation testing tool for Java, with a Calculator example. Details are in `testing/mutation_testing/README.md`.
- **Performance Testing**: Contains strategies and examples for performance testing. Notably, this includes a detailed test strategy for the "Unidirectional Topic Operator (UTO)" in Kafka, outlining objectives, scenarios, metrics, and environment for evaluating UTO performance and scalability (see `testing/performance_testing/uto/TestStrategy.md`).
- **Property-Based Testing**: Demonstrates property-based testing in Java, including stateful testing concepts using the jqwik framework. More information can be found in `testing/property_based_testing/README.md`.

### Other

The `other` directory contains miscellaneous projects and experiments, including small games implemented in C like Snake (see `other/snake/README.md`) and Ping-Pong.

## Resources

[1] *Introduction to Static Analysis* - [Link](https://www.amazon.com/Introduction-Static-Analysis-Interpretation-Perspective/dp/0262043416)
