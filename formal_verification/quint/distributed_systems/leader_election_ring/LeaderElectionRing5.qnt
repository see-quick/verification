module LeaderElectionRing {
    // --- MODEL PARAMETERS ---
    const N: int // Number of processes

    // Type aliases for clarity
    type Process = int
    type State = str  // "idle", "election", "leader", "failed"
    
    // --- STATE VARIABLES ---
    var leader: Process // The elected leader
    var messages: Set[(Process, Process)] // (sender, ID)
    var states: Process -> State
    var failed: Set[Process] // Set of failed processes

    // --- DERIVED VALUES ---
    val processes = 0.to(N - 1)
  
    def nextProcess(p : Process) : int = (p + 1) % N
    def firstElement(vals: Set[Process]): Process =
      vals.fold(-1, (acc, v) => if (acc == -1) v else acc)

    // Computes the maximum value in a set of integers
    def maxValue(vals: Set[Process]): Process =
      if (size(vals) == 0) 
        -1 
      else 
        vals.fold(firstElement(vals), (max, v) => if (v > max) v else max)
    
    def maxId(messages: Set[(Process, Process)], p: Process): int =
      maxValue(messages.filter(m => m._1 == p and m._2 >= 0).map(m => m._2))

    // --- INITIALIZATION ---
    action init = all {
        leader' = -1,
        messages' = processes.map(i => (i, i)), // Each process starts an election with its own ID
        states' = processes.mapBy(p => "election"),
        failed' = Set() // No failures initially
    }

    action propagateMessage(p) = all {
        not(p.in(failed)),  // Only non-failed processes send messages
        messages' = messages.filter(m => m._1 != p) // removed processed messages 
                      .union(Set((
                          nextProcess(p), 
                          maxId(messages, p)))), // pass to next
        leader' = leader,  // No change in leader, but must include it
        states' = states,  // No change in states, but must include it
        failed' = failed   // Ensure failed is updated (even if unchanged)
    }
    
    action electLeader(p) = all {
       not(p.in(failed)),
       size(messages.filter(m => m._1 == p)) > 0, // Process received at least one message
       maxId(messages, p) == p, // The highest ID received is its own
       leader' = p, // This process is the new leader
       states' = processes.mapBy(i => if (i == p and not(i.in(failed))) "leader" else "idle"),
       messages' = Set(), // Clear messages after election
       failed' = failed  // Ensure failed is updated (even if unchanged)
    }

    // --- PROCESS FAILURE ---
    action failProcess(p) = all {
        not(p.in(failed)),  // Process must be active
        failed' = failed.union(Set(p)),  // Mark the process as failed
        states' = states.set(p, "failed"),  // Update its state
        leader' = if (p == leader) -1 else leader,  // Reset leader if failed
         // Remove messages from the failed process and restart election if needed
        messages' = 
          if (p == leader) 
            processes.filter(i => not(i.in(failed))).map(i => (i, i)) // Restart election
          else 
            messages.filter(m => m._1 != p) // Otherwise, just remove failed process messages        
    }

    // --- SYSTEM STEP FUNCTION ---
    action step = {
        nondet p = oneOf(processes)
        any {
            propagateMessage(p),
            electLeader(p),
            failProcess(p)
        }
    }

    // --- SAFETY INVARIANTS ---

    //At most one leader exists at any time
    val UniqueLeader = 
        size(states.keys().filter(p => states.get(p) == "leader")) <= 1

    // ✅ The leader must not be a failed process
    val ValidLeader = (leader >= 0 and leader < N).implies(not(leader.in(failed)))

    val vars = (messages, states, leader, failed)

    temporal WeakFairness =
      weakFair(step, vars)
    temporal StrongFairElection =
       processes.forall(p => strongFair(electLeader(p), vars))
    temporal StrongFairMessagePassing =
       processes.forall(p => strongFair(propagateMessage(p), vars))

    // TODO: still this would crash because we do not handle failures (it can happen that all nodes will crash...)
    temporal EventualLeader =
      (WeakFairness and StrongFairElection and StrongFairMessagePassing)
        implies always(eventually(
          (leader != -1) and
          (size(states.keys().filter(p => states.get(p) == "leader")) == 1)
        ))
}

module LeaderElectionRing5 {
    import LeaderElectionRing(N = 5).*
}

