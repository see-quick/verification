---- MODULE LeaderElection_TTrace_1696781767 ----
EXTENDS Sequences, TLCExt, LeaderElection, Toolbox, Naturals, TLC

_expression ==
    LET LeaderElection_TEExpression == INSTANCE LeaderElection_TEExpression
    IN LeaderElection_TEExpression!expression
----

_trace ==
    LET LeaderElection_TETrace == INSTANCE LeaderElection_TETrace
    IN LeaderElection_TETrace!trace
----

_inv ==
    ~(
        TLCGet("level") = Len(_TETrace)
        /\
        leader = ("UNAVAILABLE")
        /\
        availableBrokers = ({})
    )
----

_init ==
    /\ availableBrokers = _TETrace[1].availableBrokers
    /\ leader = _TETrace[1].leader
----

_next ==
    /\ \E i,j \in DOMAIN _TETrace:
        /\ \/ /\ j = i + 1
              /\ i = TLCGet("level")
        /\ availableBrokers  = _TETrace[i].availableBrokers
        /\ availableBrokers' = _TETrace[j].availableBrokers
        /\ leader  = _TETrace[i].leader
        /\ leader' = _TETrace[j].leader

\* Uncomment the ASSUME below to write the states of the error trace
\* to the given file in Json format. Note that you can pass any tuple
\* to `JsonSerialize`. For example, a sub-sequence of _TETrace.
    \* ASSUME
    \*     LET J == INSTANCE Json
    \*         IN J!JsonSerialize("LeaderElection_TTrace_1696781767.json", _TETrace)

=============================================================================

 Note that you can extract this module `LeaderElection_TEExpression`
  to a dedicated file to reuse `expression` (the module in the 
  dedicated `LeaderElection_TEExpression.tla` file takes precedence 
  over the module `LeaderElection_TEExpression` below).

---- MODULE LeaderElection_TEExpression ----
EXTENDS Sequences, TLCExt, LeaderElection, Toolbox, Naturals, TLC

expression == 
    [
        \* To hide variables of the `LeaderElection` spec from the error trace,
        \* remove the variables below.  The trace will be written in the order
        \* of the fields of this record.
        availableBrokers |-> availableBrokers
        ,leader |-> leader
        
        \* Put additional constant-, state-, and action-level expressions here:
        \* ,_stateNumber |-> _TEPosition
        \* ,_availableBrokersUnchanged |-> availableBrokers = availableBrokers'
        
        \* Format the `availableBrokers` variable as Json value.
        \* ,_availableBrokersJson |->
        \*     LET J == INSTANCE Json
        \*     IN J!ToJson(availableBrokers)
        
        \* Lastly, you may build expressions over arbitrary sets of states by
        \* leveraging the _TETrace operator.  For example, this is how to
        \* count the number of times a spec variable changed up to the current
        \* state in the trace.
        \* ,_availableBrokersModCount |->
        \*     LET F[s \in DOMAIN _TETrace] ==
        \*         IF s = 1 THEN 0
        \*         ELSE IF _TETrace[s].availableBrokers # _TETrace[s-1].availableBrokers
        \*             THEN 1 + F[s-1] ELSE F[s-1]
        \*     IN F[_TEPosition - 1]
    ]

=============================================================================



Parsing and semantic processing can take forever if the trace below is long.
 In this case, it is advised to uncomment the module below to deserialize the
 trace from a generated binary file.

\*
\*---- MODULE LeaderElection_TETrace ----
\*EXTENDS IOUtils, LeaderElection, TLC
\*
\*trace == IODeserialize("LeaderElection_TTrace_1696781767.bin", TRUE)
\*
\*=============================================================================
\*

---- MODULE LeaderElection_TETrace ----
EXTENDS LeaderElection, TLC

trace == 
    <<
    ([leader |-> "Broker1",availableBrokers |-> {"Broker1", "Broker2", "Broker3"}]),
    ([leader |-> "UNAVAILABLE",availableBrokers |-> {"Broker2", "Broker3"}]),
    ([leader |-> "Broker2",availableBrokers |-> {"Broker2", "Broker3"}]),
    ([leader |-> "UNAVAILABLE",availableBrokers |-> {"Broker3"}]),
    ([leader |-> "Broker3",availableBrokers |-> {"Broker3"}]),
    ([leader |-> "UNAVAILABLE",availableBrokers |-> {}])
    >>
----


=============================================================================

---- CONFIG LeaderElection_TTrace_1696781767 ----
CONSTANTS
    Brokers = { "Broker1" , "Broker2" , "Broker3" }
    UNAVAILABLE = "UNAVAILABLE"

INVARIANT
    _inv

CHECK_DEADLOCK
    \* CHECK_DEADLOCK off because of PROPERTY or INVARIANT above.
    FALSE

INIT
    _init

NEXT
    _next

CONSTANT
    _TETrace <- _trace

ALIAS
    _expression
=============================================================================
\* Generated on Sun Oct 08 18:16:08 CEST 2023