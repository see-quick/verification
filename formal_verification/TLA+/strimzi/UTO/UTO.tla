------------------- MODULE UTO -------------------

(*
Focus mainly on:
    1. Creation of KafkaTopic in Kubernetes
    2. Synchronization of the KafkaTopic to the actual topic in Kafka
    3. Handling of conflicts (multiple KafkaTopics managing the same Kafka topic)
    4. Deletion of KafkaTopic and its impact on the actual topic in Kafka
*)

EXTENDS Naturals, Sequences

CONSTANTS NULL, TopicNames

VARIABLES KubeTopics, KafkaTopics, ConflictMap, Action

Topics == [topicName: TopicNames, partitions: Nat, replicas: Nat, config: STRING]

(* Define the data structure for a KafkaTopic in Kubernetes *)
KafkaTopic(name, partitions, replicas, config) ==
  [topicName |-> name, partitions |-> partitions, replicas |-> replicas, config |-> config]

(* Initialize the system with no topics in Kube and Kafka *)
Init ==
  /\ KubeTopics = {}
  /\ KafkaTopics = {}
  /\ ConflictMap = {}
  /\ Action = NULL

(* A new KafkaTopic is created in Kubernetes *)
CreateKubeTopic(topic) ==
  /\ topic \in Topics  (* This ensures the topic is valid *)
  /\ topic.topicName \notin DOMAIN KubeTopics
  /\ KubeTopics' = [KubeTopics EXCEPT ![topic.topicName] = topic]
  /\ UNCHANGED << KafkaTopics, ConflictMap, Action >>

(* Synchronize the KafkaTopic from Kubernetes to Kafka *)
SyncToKafka(topicName) ==
  /\ topicName \in DOMAIN KubeTopics
  /\ KafkaTopics' = [KafkaTopics EXCEPT ![topicName] = KubeTopics[topicName]]
  /\ UNCHANGED << KubeTopics, ConflictMap, Action >>

(* Handle conflicts when multiple KafkaTopics manage the same Kafka topic *)
HandleConflict(topicName) ==
  LET topic == KubeTopics[topicName]
  IN
  /\ topicName \in DOMAIN KafkaTopics
  /\ topic /= KafkaTopics[topicName]
  /\ ConflictMap' = [ConflictMap EXCEPT ![topicName] = topic]
  /\ UNCHANGED << KubeTopics, KafkaTopics, Action >>

(* Delete a KafkaTopic in Kubernetes and reflect the change in Kafka *)
DeleteKubeTopic(topicName) ==
  /\ topicName \in DOMAIN KubeTopics
  /\ KubeTopics' = KubeTopics \ {[topicName |-> KubeTopics[topicName]]}
  /\ KafkaTopics' = KafkaTopics \ {[topicName |-> KafkaTopics[topicName]]}
  /\ UNCHANGED << ConflictMap, Action >>

(* Possible actions the operator can take *)
Next ==
  \/ \E t \in TopicNames: CreateKubeTopic(t)
  \/ \E t \in TopicNames: SyncToKafka(t)
  \/ \E t \in TopicNames: HandleConflict(t)
  \/ \E t \in TopicNames: DeleteKubeTopic(t)
(*
Unidirectionality: Changes in Kafka topics should only originate from Kubernetes. In other words,
if a topic changes in Kafka, it should have a corresponding change in Kubernetes.
*)
Unidirectional == \A t \in DOMAIN KafkaTopics: KafkaTopics[t] = KubeTopics[t]

(*
No Conflicts: At any given time, there should not be multiple KafkaTopics in Kubernetes managing the same topic in Kafka.
*)
NoConflicts == \A t1, t2 \in DOMAIN KubeTopics: t1 /= t2 => KubeTopics[t1].topicName /= KubeTopics[t2].topicName

(*
Consistent Deletion: If a KafkaTopic is deleted in Kubernetes, the corresponding topic in Kafka should also be deleted.
*)
ConsistentDeletion == \A t \in DOMAIN KafkaTopics: t \in DOMAIN KubeTopics


Spec == Init /\ [][Next]_<<KubeTopics, KafkaTopics, ConflictMap, Action>>

============================== END MODULE ==============================
