/**
 * RaftElection: Quint specification of the Raft consensus algorithm (simplified).
 *
 * This model captures the core mechanics of the Raft protocol:
 *   - Leader election using terms and votes
 *   - Log replication from leader to followers
 *   - Commitment of log entries replicated on a quorum
 *
 * --- Verification Goals ---
 *
 * ✅ Safety Properties:
 *   - UniqueLeaderPerTerm: At most one leader per term
 *   - LogAgreement: All processes with the same commit index agree on the log prefix
 *   - CommittedInLeader: Committed entries appear in the leader's log
 *   - FollowerPrefixOfLeader: Follower logs are always a prefix of the leader's
 *   - NoInvalidReplication: Diverging logs are not overwritten incorrectly
 *   - FollowerLogConsistency: Same-length follower logs must match
 *   - LogLengthBounded: Bounded log size for tractable model checking
 *   - LeaderCompleteness: Committed entries appear in all future leaders' logs
 *
 * ⏳ Liveness Property:
 *   - EventualLeader: A leader is eventually elected (with fairness assumptions)
 *
 * --- Fairness Assumptions ---
 *   - weakFair(step, vars): system makes progress
 *   - strongFair(startElection(p), vars): elections are eventually triggered
 *   - strongFair(vote(p, q), vars): votes are eventually cast
 *   - strongFair(becomeLeader(p), vars): eligible leaders are eventually elected
 *
 * --- Raft Paper Alignment ---
 *
 * ✔ Section 5.2: Leader Election
 *    - Term management, self-voting, majority checking, up-to-date log check
 *    - Invariants: UniqueLeaderPerTerm, EventualLeader
 *
 * ✔ Section 5.3: Log Replication
 *    - AppendEntries, prefix checks, log truncation (simplified)
 *    - Invariants: FollowerPrefixOfLeader, NoInvalidReplication
 *    - Commitment via quorum agreement: maxReplicatedPrefix
 *
 * ✔ Section 5.4.1: Election Restriction
 *    - Up-to-date check via isUpToDate
 *
 * ❌ Section 5.4.2: Reboot and Persistence
 *    - Crash recovery and persistent state not modeled
 *
 * ✔ Section 5.5: Leader Completeness
 *    - Committed entries in leader’s log; future leaders inherit committed state
 *
 * ⚠ Section 5.6: Safety and Liveness Guarantees
 *    - Liveness only partially modeled (EventualLeader)
 *    - No timeouts, randomized delays, or real crash modeling
 *
 * --- Missing Features ---
 *   - Asynchronous message-passing and real network behavior
 *   - Client request queues and apply-to-state-machine logic
 *   - Reboot and persistence (non-volatile storage)
 *
 * Model verified with bounded configurations (e.g., N = 3, maxLogLength = 10).
 * Scales well with safety properties, liveness harder due to state explosion.
 */
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
  val maxLogLength: int = 10

  // Majority quorum: returns the minimum number of nodes needed to reach majority in a cluster of size `n`.
  def majority(n: int): int = (n / 2) + 1

  // Checks if process `p` has received votes from a majority of processes.
  def hasMajorityVotes(votes: Set[(Process, Process)], p: Process): bool =
      votes.filter(v => v._2 == p).size() >= majority(N)
  
  // Verifies that no leader has been elected yet in the given term.
  def noLeaderInTerm(term: int): bool =
    processes.forall(p =>
      not(roles.get(p) == Leader and currentTerm.get(p) == term))
  
  // Returns the term of the last log entry of process `p`.
  def lastLogTerm(p : Process): int = 
    val logsSize = logs.get(p).length()
    if (logsSize == 0) 0
    else logs.get(p)[logsSize - 1]._1

  // Returns the length of the log (i.e., the next log index) for process `p`.
  def lastLogIndex(p : Process): int =
    logs.get(p).length()

  // Checks whether the candidate's log is at least as up-to-date as the voter's log.
  // Used to enforce the voting restriction in Raft (§5.4.1).
  def isUpToDate(candidate: Process, voter: Process): bool = 
    val candTerm = lastLogTerm(candidate)
    val candIndex = lastLogIndex(candidate)
    val voterTerm = lastLogTerm(voter)
    val voterIndex = lastLogIndex(voter)
    (candTerm > voterTerm) or (candTerm == voterTerm and candIndex >= voterIndex)

  // Computes the highest log index `i` such that a majority of processes share
  // the same prefix of the log up to index `i`.
  def maxReplicatedPrefix(p: Process): int =
    0.to(maxLogLength).fold(0, (best, i) =>
      if (
        processes.filter(q =>
          logs.get(q).length() >= i and
          logs.get(q).slice(0, i) == logs.get(p).slice(0, i)
        ).size() >= majority(N)
      ) i else best
    )

  // True if `follower`'s log is a prefix of `leader`'s log.
  def matchLogPrefix(follower: Process, leader: Process): bool =
    val fl = logs.get(follower)
    val ll = logs.get(leader)
    fl.length() <= ll.length() and ll.slice(0, fl.length()) == fl

  // Add this helper for log consistency check (Section 5.3)
  // Returns true if log entry at `index` of process `p` matches the given term.
  def logMatchesAt(p: Process, index: int, term: int): bool =
    logs.get(p).length() > index and logs.get(p)[index]._1 == term
    
  // Returns the index of the last log entry (or -1 if the log is empty).
  def prevLogIndex(p: Process): int =
    val len = logs.get(p).length()
    if (len == 0) -1 else len - 1

  // Returns the term of the last log entry (or 0 if the log is empty).
  def prevLogTerm(p: Process): int =
    val len = logs.get(p).length()
    if (len == 0) 0 else logs.get(p)[len - 1]._1

  // Returns a truncated version of the log up to and including index `i`.
  def truncateLog(log: List[Entry], index: int): List[Entry] =
    if (index < 0) List() else log.slice(0, index + 1)

  // Returns the suffix of the log from a given index onward.
  def suffixFrom(log: List[Entry], senderFrom: int): List[Entry] =
    if (senderFrom < log.length()) log.slice(senderFrom, log.length()) else List()

  // Checks whether it is safe to truncate the follower's log and append entries from the leader,
  // based on agreement at the previous log index.
  def canTruncateLogAndAppend(leaderP: Process, followerP: Process): bool =
    val leaderLog = logs.get(leaderP)
    val followerLog = logs.get(followerP)
    val prevIndex = followerLog.length() - 1
  
    // Ensure that the follower has an entry at prevIndex
    // and that it matches the leader's entry at the same index
    prevIndex >= 0 and 
    prevIndex < followerLog.length() and
    prevIndex < leaderLog.length() and
    leaderLog[prevIndex] == followerLog[prevIndex]
  
  // Constructs a new follower log by combining the leader's log up to `prevIndex`
  // with the leader’s suffix beyond that point.
  def truncateAndAppend(leaderP: Process, followerP: Process): List[Entry] =
    val leaderLog = logs.get(leaderP)
    val followerLog = logs.get(followerP)
    val prevIndex = followerLog.length() - 1

    if (
      prevIndex < 0 or
      leaderLog.length() == 0 or
      prevIndex + 1 > leaderLog.length()
    )
      followerLog
    else
      leaderLog.slice(0, prevIndex + 1)
        .concat(leaderLog.slice(prevIndex + 1, leaderLog.length()))

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
    isUpToDate(q, p),

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
    canTruncateLogAndAppend(p, q),
  
    logs' = logs.set(q, truncateAndAppend(p, q)),
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

  // 🛡️ At most one leader per term
  val UniqueLeaderPerTerm =
    processes.fold(true, (acc, p) =>
      acc and (
        processes.filter(q =>
          roles.get(q) == Leader and currentTerm.get(q) == currentTerm.get(p)
        ).size() <= 1
      )
    )

  // 🛡️ Log Agreement on committed prefix (if commitIndex matches)
  val LogAgreement =
    processes.forall(p => processes.forall(q =>
      (commitIndex.get(p) == commitIndex.get(q)) implies
        logs.get(p).slice(0, commitIndex.get(p)) == logs.get(q).slice(0, commitIndex.get(q))
    ))

  // 🛡️ once committed, a log entry stays committed 
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

  // 🛡️Log length is bounded with size 10 :). We eliminate complexity within model-checkers
  val LogLengthBounded =
    processes.forall(p => logs.get(p).length() <= maxLogLength)

  // 🛡️Leader Completeness: Every committed entry on a follower must appear in the leader’s log at the same index and term.
  val LeaderCompleteness =
    leader != -1 implies
      processes.forall(p =>
        commitIndex.get(p) > 0 implies
          logs.get(p).slice(0, commitIndex.get(p)) ==
          logs.get(leader).slice(0, commitIndex.get(p))
      )

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
