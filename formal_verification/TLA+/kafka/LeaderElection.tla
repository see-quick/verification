----------------- MODULE LeaderElection -----------------

EXTENDS Naturals, Sequences, FiniteSets

CONSTANTS Brokers,  \* Set of all brokers, e.g., {Broker1, Broker2, Broker3}
         UNAVAILABLE  \* A special value indicating a broker is unavailable

VARIABLES leader,  \* Current leader for the partition
         availableBrokers  \* Set of currently available brokers

Init ==
    \* Initially, any broker can be the leader
    /\ leader \in Brokers
    /\ availableBrokers = Brokers

FailLeader ==
    \* The current leader becomes unavailable
    /\ leader \in availableBrokers
    /\ availableBrokers' = availableBrokers \ {leader}
    /\ leader' = UNAVAILABLE

ElectLeader ==
    \* Elect a new leader from the available brokers
    /\ leader = UNAVAILABLE
    /\ leader' \in availableBrokers
    /\ UNCHANGED << availableBrokers >>

Next ==
    \* Either the leader fails or a new leader is elected
    FailLeader \/ ElectLeader

\* Safety Property: At any given time, there should be at most one leader.
AtMostOneLeader ==
    Cardinality({x \in Brokers: x = leader}) <= 1

\* Liveness Property: If the leader becomes unavailable, a new leader will be elected eventually.
LeaderElectionGuarantee ==
    [](leader = UNAVAILABLE /\ availableBrokers /= {} => <>(leader \in availableBrokers))


=============================================================================
