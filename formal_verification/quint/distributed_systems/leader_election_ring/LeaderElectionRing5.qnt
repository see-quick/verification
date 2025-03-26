module LeaderElectionRing {
    // --- MODEL PARAMETERS ---
    const N: int // Number of processes

    // Type aliases for clarity
    type Process = int
    type State = Idle | Election | Leader | Failed

    // --- STATE VARIABLES ---
    var leader: Process // The elected leader
    var messages: Set[(Process, Process)] // (receiver, ID)
    var states: Process -> State
    var failed: Set[Process] // Set of failed processes

    // --- DERIVED VALUES ---
    val processes = 0.to(N - 1)

    def nextProcess(p: Process): Process = (p + 1) % N

    def firstElement(vals: Set[Process]): Process =
      vals.fold(-1, (acc, v) => if (acc == -1) v else acc)

    def maxValue(vals: Set[Process]): Process =
      if (size(vals) == 0) -1
      else vals.fold(firstElement(vals), (max, v) => if (v > max) v else max)

    def maxId(messages: Set[(Process, Process)], p: Process): int =
      maxValue(messages.filter(m => m._1 == p and m._2 >= 0).map(m => m._2))

    def canElect(p: Process): bool =
      not(p.in(failed)) and
      size(messages.filter(m => m._1 == p)) > 0 and
      maxId(messages, p) == p

    // --- INITIALIZATION ---
    action init = all {
        leader' = -1,
        messages' = processes.map(i => (i, i)),
        states' = processes.mapBy(p => Election),
        failed' = Set()
    }

    // --- MESSAGE PROPAGATION ---
    action propagateMessage(p) = all {
        not(p.in(failed)),
        if (maxId(messages, p) >= 0)
          messages' = messages.filter(m => m._1 != p)
                      .union(Set((nextProcess(p), maxId(messages, p))))
        else 
          messages' = messages.filter(m => m._1 != p),
        leader' = leader,
        states' = states,
        failed' = failed
    }

    // --- LEADER ELECTION ---
    action electLeader(p) = all {
       canElect(p),
       leader' = p,
       states' = processes.mapBy(i => if (i == p and not(i.in(failed))) Leader else Idle),
       messages' = Set(),
       failed' = failed
    }

    // --- PROCESS FAILURE ---
    action failProcess(p) = all {
        not(p.in(failed)),
        failed' = failed.union(Set(p)),
        states' = states.set(p, Failed),
        leader' = if (p == leader) -1 else leader,
        messages' =
          if (p == leader)
            processes.filter(i => not(i.in(failed))).map(i => (i, i))
          else
            messages.filter(m => m._1 != p)
    }

    // --- SYSTEM STEP ---
    action step = {
        nondet p = oneOf(processes)
        any {
            propagateMessage(p),
            electLeader(p),
            failProcess(p)
        }
    }

    // --- INVARIANTS ---
    val UniqueLeader =
        size(states.keys().filter(p => states.get(p) == Leader)) <= 1

    val ValidLeader =
        (leader >= 0 and leader < N).implies(not(leader.in(failed)))

    // All messages in the system must have:
	//    •	a sender that is a valid process (exists in the system)
	//    •	a message ID that is not negative
    val ValidMessages =
        messages.forall(m => m._2 >= 0 and m._1.in(processes))

    val vars = (messages, states, leader, failed)

    // --- TEMPORAL PROPERTIES ---
    temporal WeakFairness = weakFair(step, vars)
    temporal StrongFairElection = processes.forall(p => strongFair(electLeader(p), vars))
    temporal StrongFairMessagePassing = processes.forall(p => strongFair(propagateMessage(p), vars))

    // --- EVENTUAL LEADER LIVENESS ---
    temporal EventualLeader =
      (WeakFairness and StrongFairElection and StrongFairMessagePassing)
        implies (
          always(eventually(processes.exists(p => not(p.in(failed)))))  // someone remains alive
            implies
          always(
            processes.exists(p => canElect(p))
              implies eventually(
                (leader != -1) and
                (states.get(leader) == Leader) and
                (not(leader.in(failed))) and
                (size(states.keys().filter(p => states.get(p) == Leader)) == 1)
              )
          )
        )
}

module LeaderElectionRing5 {
    import LeaderElectionRing(N = 5).*
}

