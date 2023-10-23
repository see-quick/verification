--------------------- MODULE KafkaTopicDeletion ---------------------

(*
In this specification:

Init sets up the initial state. I've allowed all variables to take on any boolean value initially to explore all possible scenarios.
- DeleteKafkaTopic defines the action of deleting a KafkaTopic resource.
- Next defines all possible transitions. Besides the delete action, we consider the scenario where nothing changes (stuttering step) using UNCHANGED.
- DeleteSafety is a safety property ensuring that if a KafkaTopic resource with a finalizer that is managed is deleted, then the topic in Kafka is also deleted.
- UnchangedSafety ensures that if a KafkaTopic resource that is unmanaged is deleted, the topic in Kafka remains unchanged.

*)
EXTENDS Naturals

(* -- Define the state variables -- *)
VARIABLES
    kafkaTopicExists,
    kafkaTopicHasFinalizer,
    kafkaTopicManaged,
    kafkaTopicInKafka

(* -- Define the initial state -- *)
Init ==
    /\ kafkaTopicExists = TRUE
    /\ kafkaTopicHasFinalizer \in BOOLEAN
    /\ kafkaTopicManaged \in BOOLEAN
    /\ kafkaTopicInKafka \in BOOLEAN

(* -- Action to represent the deletion of a KafkaTopic resource -- *)
DeleteKafkaTopic ==
    /\ kafkaTopicExists = TRUE
    /\ kafkaTopicExists' = FALSE
    /\ IF kafkaTopicHasFinalizer = TRUE /\ kafkaTopicManaged = TRUE
       THEN kafkaTopicInKafka' = FALSE
       ELSE kafkaTopicInKafka' = kafkaTopicInKafka

(* -- The next state is either a deletion action or unchanged (stuttering step) -- *)
Next ==
    \/ DeleteKafkaTopic
    \/ (UNCHANGED << kafkaTopicExists, kafkaTopicHasFinalizer, kafkaTopicManaged, kafkaTopicInKafka >>)

(* -- Safety property to check -- *)
DeleteSafety ==
    []((kafkaTopicExists = TRUE /\ kafkaTopicHasFinalizer = TRUE /\ kafkaTopicManaged = TRUE)
       => (DeleteKafkaTopic => kafkaTopicInKafka' = FALSE))

UnchangedSafety ==
    []((kafkaTopicExists = TRUE /\ kafkaTopicManaged = FALSE)
       => (DeleteKafkaTopic => kafkaTopicInKafka' = kafkaTopicInKafka))

(* -- All properties to be checked -- *)
Properties ==
    DeleteSafety /\ UnchangedSafety

=============================================================================
