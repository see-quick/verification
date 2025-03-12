module DiningPhilosophers5 {
    // This module initializes the DiningPhilosophers model with N = 5
    import DiningPhilosophers(N = 5).*
}

module DiningPhilosophers {

    // --- MODEL PARAMETERS ---

    // Number of philosophers (must be set externally via import)
    const N : int

    // Type aliases for clarity
    type Philosopher = int  // Represents a philosopher (identified by an integer)
    type Fork = int         // Represents a fork (also identified by an integer)

    // --- STATE VARIABLES ---

    // Set of forks currently being held by any philosopher
    var forks : Set[Fork]

    // Set of pairs (Philosopher, Fork) indicating which philosopher holds which fork
    var taken : Set[(Philosopher, Fork)]

    // --- DERIVED VALUES ---

    // Set of all philosophers indexed from 0 to N-1
    val philosophers = 0.to(N - 1)

    // --- HELPER FUNCTIONS FOR FORK POSITIONS ---

    // Returns the left fork assigned to a given philosopher
    def leftFork(p : Philosopher): Fork = p

    // Returns the right fork assigned to a given philosopher (circular arrangement)
    def rightFork(p : Philosopher): Fork = (p + 1) % N

    // --- CHECK IF A PHILOSOPHER CAN PICK FORKS ---

    // Determines if a philosopher can pick up their left fork
    def canPickLeft(p: Philosopher): bool =
        not(leftFork(p).in(forks))  // Left fork must not be currently held by anyone

    // Determines if a philosopher can pick up their right fork
    def canPickRight(p: Philosopher): bool =
        not(rightFork(p).in(forks) and (p, leftFork(p)).in(taken))  
        // Right fork must be available, and the philosopher must already hold the left fork

    // --- INITIALIZATION ---

    // Initializes the simulation with no forks held and no philosophers having taken any forks
    action init = all {
      forks' = Set(),  // Initially, no forks are held
      taken' = Set()   // Initially, no philosopher has taken a fork
    }

    // --- ACTIONS FOR PHILOSOPHER BEHAVIOR ---

    // Philosopher attempts to pick up their left fork (only if available)
    action pickLeftFork(p) = all {
      canPickLeft(p),  // Ensure the left fork is available
      taken' = taken.union(Set((p, leftFork(p)))),  // Mark that philosopher `p` holds the left fork
      forks' = forks.union(Set(leftFork(p)))  // Add the left fork to the set of held forks
    }

    // Philosopher attempts to pick up their right fork (only if available)
    action pickRightFork(p) = all {
      canPickRight(p),  // Ensure the right fork is available and left fork is already held
      taken' = taken.union(Set((p, rightFork(p)))),  // Mark that philosopher `p` holds the right fork
      forks' = forks.union(Set(rightFork(p)))  // Add the right fork to the set of held forks
    }

    // Philosopher attempts to put down both forks
    action pickBothForks(p) = all {
      canPickRight(p) and canPickLeft(p),  // Ensure both forks are available
      taken' = taken.exclude(Set((p, leftFork(p)), (p, rightFork(p)))),  // Remove philosopher from taken forks
      forks' = forks.exclude(Set(leftFork(p), rightFork(p)))  // Remove forks from held set
    }

    // --- SYSTEM STEP FUNCTION ---

    // Represents the non-deterministic execution of a step in the system
    action step = {
      nondet p = oneOf(philosophers)  // Randomly select a philosopher
      any {
        pickLeftFork(p),   // Try to pick the left fork
        pickRightFork(p),  // Try to pick the right fork
        pickBothForks(p)   // Try to put down both forks
      }
    }

    // --- DEADLOCK PROPERTY ---

    // Defines a deadlock condition:
    // - Every philosopher must be holding at least one fork
    // - No philosopher should be able to pick up their second fork
    val DeadlockCondition = and {
        philosophers.forall(p => (p, leftFork(p)).in(taken) or (p, rightFork(p)).in(taken)),  // Everyone holds at least one fork
        philosophers.forall(p => not(canPickLeft(p)) and not(canPickRight(p)))  // No one can proceed
    }

    // Temporal property to verify if a deadlock state is **eventually** reached
    temporal DeadlockProperty = eventually(DeadlockCondition)

}
