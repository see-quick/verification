# Leader Election in a Ring Network

## Overview
This specification models a **Leader Election Algorithm** in a distributed system where processes are arranged in a **ring topology**. The model follows the **Ring Election Algorithm**, ensuring that only one process is elected as the leader at a time, even in the presence of failures.

## Features
- **Processes in a ring**: Each process forwards election messages to its neighbor.
- **Leader Election**: A process becomes the leader if it detects that it has the highest ID in the system.
- **Failure Handling**: If a process fails, a new election is triggered among the remaining active processes.
- **Safety Invariants**: Ensure correctness properties such as unique leader existence and valid leader election.

## State Variables
- `leader`: The currently elected leader.
- `messages`: A set of tuples `(sender, ID)` representing the election messages.
- `states`: A mapping of processes to their states (`"idle"`, `"election"`, `"leader"`, `"failed"`).
- `failed`: A set of failed processes.

## Actions
### Initialization (`init`)
- Every process starts an election with its own ID.
- All processes are initially in the `"election"` state.
- No failures exist initially.

### Message Propagation (`propagateMessage`)
- A process sends an election message to its next neighbor.
- The highest ID received is passed forward.

### Leader Election (`electLeader`)
- If a process receives its own ID as the highest, it declares itself the leader.
- The system updates states to reflect the new leader.

### Process Failure (`failProcess`)
- A process may fail at any point.
- If the leader fails, a new election is initiated.
- Messages originating from the failed process are removed.

## Safety Invariants
- **Unique Leader (`UniqueLeader`)**: At most one leader exists at any time.
- **Leader Exists (`LeaderExists`)**: If there are active processes, there must be one leader.
- **Valid Leader (`ValidLeader`)**: The elected leader must not be a failed process.
- **Valid Messages (`ValidMessages`)**: Messages should not contain failed processes.

## Running the Specification
To execute the model using the **Quint Model-Based Testing (MBT)** framework:
```bash
quint run LeaderElectionRing5.qnt --mbt --verbosity=5
```
This will simulate the system's behavior and verify that the safety properties hold under different conditions.

## Future Improvements
- Optimize election efficiency by reducing message complexity.
- Extend failure recovery mechanisms for dynamic process rejoining.
- Enhance handling of concurrent elections in large-scale networks.

This model provides a robust foundation for leader election in distributed systems, ensuring coordination and fault tolerance in a decentralized environment.


