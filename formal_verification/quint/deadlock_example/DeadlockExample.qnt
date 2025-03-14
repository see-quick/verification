module DeadlockExample {
  val P1 : int = 1
  val P2 : int = 2
  val R1 : int = 1
  val R2 : int = 2
  
  // State variable: (R1 owner, R2 owner)
  var heldBy: (int, int) 

  // -- ACTIONS --
 
 // (-1 means free)
  action init = 
    heldBy' = (-1, -1)
  
   // A process acquires R1 if it is free
  def acquireR1(p: int): (int, int) =
    if (heldBy._1 == -1) (p, heldBy._2) else heldBy

  // A process acquires R2 if it is free
  def acquireR2(p: int): (int, int) =
    if (heldBy._2 == -1) (heldBy._1, p) else heldBy

  // A process releases R1 if it holds it
  def releaseR1(p: int): (int, int) =
    if (heldBy._1 == p) (-1, heldBy._2) else heldBy

  // A process releases R2 if it holds it
  def releaseR2(p: int): (int, int) =
    if (heldBy._2 == p) (heldBy._1, -1) else heldBy
  
   // --- DEADLOCK CONDITION ---
  def deadlock: bool = 
    and {
      (heldBy._1 != -1), (heldBy._2) != -1, // Both resources must be held
      or { 
        ((heldBy._1 == P1) and (heldBy._2 == P2)), // P1 holds R1, P2 holds R2
        ((heldBy._1 == P2) and (heldBy._2 == P1))  // P2 holds R1, P1 holds R2    
    }
  }

  // --- NEXT-STATE TRANSITIONS ---
  action step = {
    nondet p = oneOf(Set(P1, P2))
    heldBy' = oneOf(Set(
      acquireR1(p),
      acquireR2(p),
      releaseR1(p),
      releaseR2(p)
    ))
  }

  // --- SAFETY PROPERTY: CHECKING FOR DEADLOCK ---
  val DeadlockCondition = not(deadlock)
}
