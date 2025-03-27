module RaftElection {
  const N: int

  type Process = int
  type Role = Follower | Candidate | Leader
  type Entry = (int, str)  // (term, command)

  // State variables
  var roles: Process -> Role
  var currentTerm: Process -> int
  var votedFor: Process -> int  // -1 if not voted
  var votes: Set[(Process, Process)]  // (voter, candidate)
  var leader: int  // -1 if none
  // 2nd ===== adding 
  var logs : Process -> List[Entry]

  val processes = 0.to(N - 1)

  def majority(n: int): int = (n / 2) + 1

  def hasMajorityVotes(votes: Set[(Process, Process)], p: Process): bool =
      votes.filter(v => v._2 == p).size() >= majority(N)
  
  def noLeaderInTerm(term: int): bool =
    processes.forall(p =>
      not(roles.get(p) == Leader and currentTerm.get(p) == term))

  // INIT
  action init = all {
    roles' = processes.mapBy(p => Follower),
    currentTerm' = processes.mapBy(p => 0),
    votedFor' = processes.mapBy(p => -1),
    votes' = Set(),
    leader' = -1
  }

  // CANDIDATE REQUESTS VOTES
  action startElection(p) = all {
    roles.get(p) != Leader,
    currentTerm' = currentTerm.set(p, currentTerm.get(p) + 1),
    roles' = roles.set(p, Candidate),
    votedFor' = votedFor.set(p, p),
    votes' = votes.union(Set((p, p))),
    leader' = -1
  }

  // VOTE RESPONSE
  action vote(p, q) = all {
    p != q,
    roles.get(p) != Leader,
    currentTerm.get(p) <= currentTerm.get(q),
    votedFor.get(p) == -1 or votedFor.get(p) == q,

    votedFor' = votedFor.set(p, q),
    votes' = votes.union(Set((p, q))),
    currentTerm' = currentTerm,
    roles' = roles,
    leader' = leader
  }

  // CANDIDATE BECOMES LEADER
  action becomeLeader(p) = all {
    roles.get(p) == Candidate,
    hasMajorityVotes(votes, p),
    noLeaderInTerm(currentTerm.get(p)),

    roles' = roles.set(p, Leader),
    leader' = p,
    currentTerm' = currentTerm,
    votedFor' = votedFor,
    votes' = Set()
  }

  // SYSTEM STEP
  action step = {
    nondet p = oneOf(processes)
    nondet q = oneOf(processes)
    any {
      startElection(p),
      vote(p, q),
      becomeLeader(p)
    }
  }

  val vars = (roles, currentTerm, votedFor, votes, leader)

  // INVARIANTS
  val UniqueLeaderPerTerm =
    processes.fold(true, (acc, p) =>
      acc and (
        processes.filter(q =>
          roles.get(q) == Leader and currentTerm.get(q) == currentTerm.get(p)
        ).size() <= 1
      )
    )

  val ValidVotes =
    votes.forall(v => v._1.in(processes) and v._2.in(processes))

  // TEMPORAL
  temporal WeakFair = weakFair(step, vars)
  temporal FairStart = processes.forall(p => strongFair(startElection(p), vars))
  temporal FairVote = processes.forall(p => strongFair(vote(p, p), vars))  // assume self-voting fairness
  temporal FairLeadership = processes.forall(p => strongFair(becomeLeader(p), vars))

  // N = 5 -> this takes too much to prove use, N = 3 if you want to prove it (it reduce state space drastically)
  temporal EventualLeader =
    (WeakFair and FairStart and FairVote and FairLeadership) implies 
      always(eventually(processes.exists(p => roles.get(p) == Leader)))
}

module RaftElection5 {
  import RaftElection(N = 5).*
}
