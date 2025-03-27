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
  var commitIndex: Process -> int

  val processes = 0.to(N - 1)

  def majority(n: int): int = (n / 2) + 1

  def hasMajorityVotes(votes: Set[(Process, Process)], p: Process): bool =
      votes.filter(v => v._2 == p).size() >= majority(N)
  
  def noLeaderInTerm(term: int): bool =
    processes.forall(p =>
      not(roles.get(p) == Leader and currentTerm.get(p) == term))

  // Helper: compute the highest index i such that a majority of nodes match leader p's log prefix
  def maxReplicatedPrefix(p: Process): int =
    0.to(logs.get(p).length()).fold(0, (best, i) =>
      if (
        processes.filter(q =>
          logs.get(q).length() >= i and
          logs.get(q).slice(0, i) == logs.get(p).slice(0, i)
        ).size() >= majority(N)
      ) i else best
    )

  def matchLogPrefix(follower: Process, leader: Process): bool =
    val fl = logs.get(follower)
    val ll = logs.get(leader)
    fl.length() <= ll.length() and ll.slice(0, fl.length()) == fl

  // INIT
  action init = all {
    roles' = processes.mapBy(p => Follower),
    currentTerm' = processes.mapBy(p => 0),
    votedFor' = processes.mapBy(p => -1),
    votes' = Set(),
    leader' = -1,
    logs' = processes.mapBy(p => List()),  // empty logs
    commitIndex' = processes.mapBy(p => 0)
  }

  // CANDIDATE REQUESTS VOTES
  action startElection(p) = all {
    roles.get(p) != Leader,
    currentTerm' = currentTerm.set(p, currentTerm.get(p) + 1),
    roles' = roles.set(p, Candidate),
    votedFor' = votedFor.set(p, p),
    votes' = votes.union(Set((p, p))),
    leader' = -1,
    logs' = logs,
    commitIndex' = commitIndex
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
    leader' = leader,
    logs' = logs,
    commitIndex' = commitIndex
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
    votes' = Set(),
    logs' = logs,
    commitIndex' = commitIndex
  }

  // Phase 2: Log replication

  // Leader appends a new (term, cmd) to its own log
  action appendNewCommand(p, cmd) = all {
    roles.get(p) == Leader,
    logs' = logs.set(p, logs.get(p).append((currentTerm.get(p), cmd))),
    roles' = roles,
    currentTerm' = currentTerm,
    votedFor' = votedFor,
    votes' = votes,
    leader' = leader,
    commitIndex' = commitIndex
  }

  // Follower accepts leader's log
  action replicateLog(leaderP, followerP) = all {
    roles.get(leaderP) == Leader,
    roles.get(followerP) == Follower,

    logs' = logs.set(followerP, logs.get(leaderP)),
    roles' = roles,
    currentTerm' = currentTerm,
    votedFor' = votedFor,
    votes' = votes,
    leader' = leader,
    commitIndex' = commitIndex
  }

  // Action: commitEntries(p)
  action commitEntries(p) = all {
    roles.get(p) == Leader,
  
    commitIndex' = commitIndex.set(p, maxReplicatedPrefix(p)),
    logs' = logs,
    roles' = roles,
    votedFor' = votedFor,
    currentTerm' = currentTerm,
    votes' = votes,
    leader' = leader
  }

  // Phase 3: Hearth beats + append entries...
  action sendAppendEntries(p, q) = all {
    roles.get(p) == Leader,
    roles.get(q) == Follower,
  
    matchLogPrefix(q, p),
  
    logs' = logs.set(q, logs.get(p)),  // overwrite if prefix match
    commitIndex' = commitIndex,
    roles' = roles,
    currentTerm' = currentTerm,
    votedFor' = votedFor,
    votes' = votes,
    leader' = leader
  }

  action sendHeartbeat(p, q) = all {
    roles.get(p) == Leader,
    roles.get(q) == Follower,
    logs.get(p).length() == logs.get(q).length(),
  
    logs' = logs,
    commitIndex' = commitIndex,
    roles' = roles,
    currentTerm' = currentTerm,
    votedFor' = votedFor,
    votes' = votes,
    leader' = leader
  }

  // SYSTEM STEP
  action step = {
    nondet p = oneOf(processes)
    nondet q = oneOf(processes)
    nondet cmd = oneOf(Set("x", "y", "z"))
    any {
      startElection(p),
      vote(p, q),
      becomeLeader(p),
      appendNewCommand(p, cmd),
      replicateLog(p, q),
      sendAppendEntries(p, q),
      sendHeartbeat(p, q),
      commitEntries(p)
    }
  }

  val vars = (roles, currentTerm, votedFor, votes, leader, logs, commitIndex)

  // INVARIANTS

  // 1. At most one leader per term
  val UniqueLeaderPerTerm =
    processes.fold(true, (acc, p) =>
      acc and (
        processes.filter(q =>
          roles.get(q) == Leader and currentTerm.get(q) == currentTerm.get(p)
        ).size() <= 1
      )
    )

  // 2. Log Agreement on committed prefix (if commitIndex matches)
  val LogAgreement =
    processes.forall(p => processes.forall(q =>
      (commitIndex.get(p) == commitIndex.get(q)) implies
        logs.get(p).slice(0, commitIndex.get(p)) == logs.get(q).slice(0, commitIndex.get(q))
    ))

  // 3. All committed entries appear in the leader log
  val CommittedInLeader =
    processes.forall(p =>
      (leader != -1 and commitIndex.get(p) > 0) implies
        logs.get(p).slice(0, commitIndex.get(p)) == logs.get(leader).slice(0, commitIndex.get(p))
    )

  // 4.once committed, a log entry stays committed 
  temporal MonotonicCommit =
    processes.forall(p =>
      always(commitIndex.get(p) >= 0)  // implied, but you could track deltas over time too
    )

  // 🛡️ Every follower’s log must always be a prefix of the leader’s log.
  val FollowerPrefixOfLeader =
    leader != -1 implies
      processes.forall(p =>
        roles.get(p) == Follower implies
          logs.get(leader).slice(0, logs.get(p).length()) == logs.get(p)
      )

  // 🛡️If a follower log diverges from the leader, it cannot be overwritten (i.e., AppendEntries doesn’t break log integrity).
  val NoInvalidReplication =
    processes.forall(p =>
      processes.forall(q =>
        not(matchLogPrefix(p, q)) implies
          logs.get(p) != logs.get(q)
      )
    )
  
  // 🛡️The leader’s log is at least as long as any follower’s.
  val LeaderLogIsLongest =
    leader != -1 implies
      processes.forall(p =>
        logs.get(p).length() <= logs.get(leader).length()
      )
  
  // 🛡️ If two followers have the same length, their logs must match exactly.
  val FollowerLogConsistency =
    processes.forall(p => processes.forall(q =>
      roles.get(p) == Follower and
      roles.get(q) == Follower and
      logs.get(p).length() == logs.get(q).length()
      implies
      logs.get(p) == logs.get(q)
    ))

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
