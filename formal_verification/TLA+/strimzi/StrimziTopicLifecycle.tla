---- MODULE StrimziTopicLifecycle ----

EXTENDS Naturals, Sequences

CONSTANTS NULL

VARIABLES TopicState, OperatorAction

(* Possible states of a Kafka topic *)
States == { "NotExists", "Creating", "Exists", "Deleting" }

Init ==
    /\ TopicState = "NotExists"
    /\ OperatorAction = NULL

(* Actions represent possible transitions between states *)

CreateTopic ==
    /\ TopicState = "NotExists"
    /\ OperatorAction' = "Create"
    /\ TopicState' = "Creating"

FinishCreate ==
    /\ TopicState = "Creating"
    /\ OperatorAction' = "FinishCreate"
    /\ TopicState' = "Exists"

DeleteTopic ==
    /\ TopicState = "Exists"
    /\ OperatorAction' = "Delete"
    /\ TopicState' = "Deleting"

FinishDelete ==
    /\ TopicState = "Deleting"
    /\ OperatorAction' = "FinishDelete"
    /\ TopicState' = "NotExists"

(* Next is a disjunction of all possible transitions *)
Next ==
    \/ CreateTopic
    \/ FinishCreate
    \/ DeleteTopic
    \/ FinishDelete

\* Safety Property: A topic cannot be deleted unless it exists.
TopicCannotBeDeletedUnlessItExists == \/ TopicState /= "Exists"
                    \/ (TopicState = "Exists" /\ (OperatorAction = "Delete" => TopicState' = "Deleting"))

\* Liveness Property: If a topic is in the process of being created (Creating state), it will eventually exist (Exists state).
\*                    it uses two temporal logic operations i.e., [] always, <> eventually
LivenessProperty == [](TopicState = "Creating" => <> TopicState = "Exists")

====

