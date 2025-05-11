# Usage statistics is OFF. We care about your privacy.
# If you want to help our project, consider enabling statistics with config --enable-stats=true.

Output directory: /Users/morsak/Documents/Work/verification/formal_verification/quint/strimzi/user-operator/_apalache-out/server/2025-05-11T19-36-05_11058953296711294181
# APALACHE version: 0.47.2 | build: def5e8e                       I@19:36:05.809
Starting server on port 8822...                                   I@19:36:05.813
The Apalache server is running on port 8822. Press Ctrl-C to stop.
PASS #0: SanyParser                                               I@19:36:09.753
--------------------------- MODULE UserOperatorModel ---------------------------

EXTENDS Integers, Sequences, FiniteSets, TLC, Apalache, Variants

VARIABLE
  (*
    @type: { aclsEnabled: Bool, authTypes: Set(Str), maxProcessedEvents: Int, potentialUsers: Set(Str), quotasEnabled: Set(Bool) };
  *)
  parameters

(*
  @type: (() => All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }));
*)
Describe == Variant("Describe", [tag |-> "UNIT"])

(*
  @type: (() => All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }));
*)
ClusterAction == Variant("ClusterAction", [tag |-> "UNIT"])

(*
  @type: (() => All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }));
*)
AlterConfigs == Variant("AlterConfigs", [tag |-> "UNIT"])

(*
  @type: (() => All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }));
*)
DescribeConfigs == Variant("DescribeConfigs", [tag |-> "UNIT"])

(*
  @type: (() => All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }));
*)
IdempotentWrite == Variant("IdempotentWrite", [tag |-> "UNIT"])

(*
  @type: (() => All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }));
*)
All == Variant("All", [tag |-> "UNIT"])

(*
  @type: (() => Conflict({ tag: Str }) | Gone({ tag: Str }) | None({ tag: Str }) | Pause({ tag: Str }) | ServerError({ tag: Str }));
*)
None == Variant("None", [tag |-> "UNIT"])

(*
  @type: (() => Conflict({ tag: Str }) | Gone({ tag: Str }) | None({ tag: Str }) | Pause({ tag: Str }) | ServerError({ tag: Str }));
*)
Pause == Variant("Pause", [tag |-> "UNIT"])

(*
  @type: (() => Conflict({ tag: Str }) | Gone({ tag: Str }) | None({ tag: Str }) | Pause({ tag: Str }) | ServerError({ tag: Str }));
*)
Conflict == Variant("Conflict", [tag |-> "UNIT"])

(*
  @type: ((a, b) => b);
*)
debug(s_1799, a_1799) == a_1799

(*
  @type: (() => Conflict({ tag: Str }) | Gone({ tag: Str }) | None({ tag: Str }) | Pause({ tag: Str }) | ServerError({ tag: Str }));
*)
Gone == Variant("Gone", [tag |-> "UNIT"])

(*
  @type: (() => Conflict({ tag: Str }) | Gone({ tag: Str }) | None({ tag: Str }) | Pause({ tag: Str }) | ServerError({ tag: Str }));
*)
ServerError == Variant("ServerError", [tag |-> "UNIT"])

(*
  @type: (({ optional: Bool, secretKey: Str, secretName: Str }) => NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }));
*)
ScramSha512Authentication(__ScramSha512AuthenticationParam_20) ==
  Variant("ScramSha512Authentication", __ScramSha512AuthenticationParam_20)

(*
  @type: (({ enabled: Bool }) => NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }));
*)
TlsAuthentication(__TlsAuthenticationParam_26) ==
  Variant("TlsAuthentication", __TlsAuthenticationParam_26)

(*
  @type: ((NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool })) => Bool);
*)
requiresSecret(auth_290) ==
  CASE VariantTag(auth_290) = "ScramSha512Authentication"
      -> LET (*
        @type: (({ optional: Bool, secretKey: Str, secretName: Str }) => Bool);
      *)
      __QUINT_LAMBDA0(id__282) == TRUE
      IN
      __QUINT_LAMBDA0(VariantGetUnsafe("ScramSha512Authentication", auth_290))
    [] VariantTag(auth_290) = "TlsAuthentication"
      -> LET (*
        @type: (({ enabled: Bool }) => Bool);
      *)
      __QUINT_LAMBDA1(id__285) == TRUE
      IN
      __QUINT_LAMBDA1(VariantGetUnsafe("TlsAuthentication", auth_290))
    [] VariantTag(auth_290) = "NoneAuthentication"
      -> LET (*
        @type: (({ tag: Str }) => Bool);
      *)
      __QUINT_LAMBDA2(id__288) == FALSE
      IN
      __QUINT_LAMBDA2(VariantGetUnsafe("NoneAuthentication", auth_290))

(*
  @type: (() => NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }));
*)
NoneAuthentication == Variant("NoneAuthentication", [tag |-> "UNIT"])

(*
  @type: ((Bool) => { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int });
*)
makeQuotas(quotasEnabled_358) ==
  IF quotasEnabled_358 = TRUE
  THEN [producerByteRate |-> 100,
    consumerByteRate |-> 200,
    requestPercentage |-> 50,
    controllerMutationRate |-> 5]
  ELSE [producerByteRate |-> 0,
    consumerByteRate |-> 0,
    requestPercentage |-> 0,
    controllerMutationRate |-> 0]

(*
  @type: (() => Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }));
*)
Topic == Variant("Topic", [tag |-> "UNIT"])

(*
  @type: (() => Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }));
*)
Group == Variant("Group", [tag |-> "UNIT"])

(*
  @type: (() => Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }));
*)
Cluster == Variant("Cluster", [tag |-> "UNIT"])

(*
  @type: (() => Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }));
*)
TransactionalId == Variant("TransactionalId", [tag |-> "UNIT"])

(*
  @type: (() => Literal({ tag: Str }) | Prefix({ tag: Str }));
*)
Literal == Variant("Literal", [tag |-> "UNIT"])

(*
  @type: (() => Literal({ tag: Str }) | Prefix({ tag: Str }));
*)
Prefix == Variant("Prefix", [tag |-> "UNIT"])

(*
  @type: (((Str -> Str), Str, Str) => Str);
*)
getOrElse(m_698, k_698, default_698) ==
  IF k_698 \in DOMAIN m_698 THEN m_698[k_698] ELSE default_698

(*
  @type: (() => All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }));
*)
Read == Variant("Read", [tag |-> "UNIT"])

(*
  @type: (() => All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }));
*)
Write == Variant("Write", [tag |-> "UNIT"])

(*
  @type: (() => All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }));
*)
Create == Variant("Create", [tag |-> "UNIT"])

(*
  @type: (() => All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }));
*)
Delete == Variant("Delete", [tag |-> "UNIT"])

(*
  @type: (() => All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }));
*)
Alter == Variant("Alter", [tag |-> "UNIT"])

(*
  @type: (({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) => UserCreatedWithSecret({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }));
*)
UserCreatedWithSecret(__UserCreatedWithSecretParam_197) ==
  Variant("UserCreatedWithSecret", __UserCreatedWithSecretParam_197)

(*
  @type: (({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) => UserCreatedWithSecret({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }));
*)
UserUpdated(__UserUpdatedParam_203) ==
  Variant("UserUpdated", __UserUpdatedParam_203)

(*
  @type: ((Str) => UserCreatedWithSecret({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }));
*)
UserDeleted(__UserDeletedParam_209) ==
  Variant("UserDeleted", __UserDeletedParam_209)

VARIABLE
  (*
    @type: { eventQueue: Seq(UserCreatedWithSecret({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })), processedEvents: Int, secrets: Set(Str), users: (Str -> { metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) };
  *)
  globalState

(*
  @type: ((Str, Str) => NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }));
*)
makeAuth(u_331, authType_331) ==
  IF authType_331 = "scram-sha-512"
  THEN ScramSha512Authentication([secretName |-> u_331,
    secretKey |-> "my-password",
    optional |-> FALSE])
  ELSE IF authType_331 = "tls"
  THEN TlsAuthentication([enabled |-> TRUE])
  ELSE NoneAuthentication

(*
  @type: (() => Set(Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str })));
*)
RESOURCE_TYPES == { (Topic), (Group), (Cluster), (TransactionalId) }

(*
  @type: (() => Set(Literal({ tag: Str }) | Prefix({ tag: Str })));
*)
PATTERNS == { (Literal), (Prefix) }

(*
  @type: (() => Set(All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str })));
*)
OPS ==
  { (Read),
    (Write),
    (Create),
    (Delete),
    (Alter),
    (Describe),
    (ClusterAction),
    (AlterConfigs),
    (DescribeConfigs),
    (IdempotentWrite),
    (All) }

(*
  @type: ((Conflict({ tag: Str }) | Gone({ tag: Str }) | None({ tag: Str }) | Pause({ tag: Str }) | ServerError({ tag: Str })) => Bool);
*)
shouldSkipReconcile(f_733) ==
  ((f_733 = Pause \/ f_733 = Conflict) \/ f_733 = Gone) \/ f_733 = ServerError

(*
  @type: ((<<Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }), Literal({ tag: Str }) | Prefix({ tag: Str }), All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str })>>) => Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }));
*)
makeAcl(t_396) ==
  {[resource |->
      [name |-> IF t_396[1] = Cluster THEN "my-cluster" ELSE "*",
        typeAcl |-> t_396[1],
        patternType |-> t_396[2]],
    operation |-> t_396[3],
    host |-> "*",
    kind |-> "allow"]}

(*
  @type: (({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) => Bool);
*)
reconciliationPaused(user_713) ==
  getOrElse(user_713["metadata"]["annotations"], "strimzi.io/pause-reconciliation",
  "")
    = "true"

(*
  @type: (({ eventQueue: Seq(UserCreatedWithSecret({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })), processedEvents: Int, secrets: Set(Str), users: (Str -> { metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) }) => Bool);
*)
isStable(state_1931) ==
  \A u_1929 \in parameters["potentialUsers"]:
    (~(u_1929 \in DOMAIN (state_1931["users"]))
        \/ state_1931["users"][u_1929]["status"]["conditions"]["status"]
          = "Ready")
      \/ state_1931["users"][u_1929]["status"]["conditions"]["status"]
        = "Deleted"

(*
  @type: (() => Bool);
*)
UserConsistency ==
  \A u_1199 \in DOMAIN (globalState["users"]):
    (globalState["users"][u_1199]["status"]["conditions"]["status"] = "Ready"
        => ~(requiresSecret(globalState["users"][u_1199]["spec"][
            "authentication"
          ]))
          \/ u_1199 \in globalState["secrets"])
      /\ (globalState["users"][u_1199]["status"]["conditions"]["status"]
        = "Deleted"
        => ~(u_1199 \in globalState["secrets"]))

(*
  @type: (() => Bool);
*)
SecretsConsistency ==
  \A u_1237 \in DOMAIN (globalState["users"]):
    requiresSecret(globalState["users"][u_1237]["spec"]["authentication"])
      /\ globalState["users"][u_1237]["status"]["conditions"]["status"]
        = "Ready"
      => u_1237 \in globalState["secrets"]

(*
  @type: (() => Bool);
*)
NoSecretsForDeletedUsers ==
  \A u_1265 \in DOMAIN (globalState["users"]):
    globalState["users"][u_1265]["status"]["conditions"]["status"] = "Deleted"
      => ~(u_1265 \in globalState["secrets"])

(*
  @type: (() => Bool);
*)
ReadyUsersMustHaveSecrets ==
  \A u_1304 \in DOMAIN (globalState["users"]):
    globalState["users"][u_1304]["status"]["conditions"]["status"] = "Ready"
      => ~(requiresSecret(globalState["users"][u_1304]["spec"]["authentication"]))
        \/ u_1304 \in globalState["secrets"]

(*
  @type: (() => Bool);
*)
EventQueueWellFormed ==
  Len(LET (*
    @type: ((Seq(UserCreatedWithSecret({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })), UserCreatedWithSecret({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })) => Seq(UserCreatedWithSecret({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })));
  *)
  __QUINT_LAMBDA8(__quint_var0, __QUINT_LAMBDA7) ==
    IF LET (*
      @type: ((UserCreatedWithSecret({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })) => Bool);
    *)
    __QUINT_LAMBDA6(ev_1345) ==
      CASE VariantTag(ev_1345) = "UserCreatedWithSecret"
          -> LET (*
            @type: (({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) => Bool);
          *)
          __QUINT_LAMBDA3(cr_1337) ==
            cr_1337["metadata"]["name"] \in parameters["potentialUsers"]
          IN
          __QUINT_LAMBDA3(VariantGetUnsafe("UserCreatedWithSecret", ev_1345))
        [] VariantTag(ev_1345) = "UserUpdated"
          -> LET (*
            @type: (({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) => Bool);
          *)
          __QUINT_LAMBDA4(cr_1340) ==
            cr_1340["metadata"]["name"] \in parameters["potentialUsers"]
          IN
          __QUINT_LAMBDA4(VariantGetUnsafe("UserUpdated", ev_1345))
        [] VariantTag(ev_1345) = "UserDeleted"
          -> LET (*
            @type: ((Str) => Bool);
          *)
          __QUINT_LAMBDA5(u_1343) == u_1343 \in parameters["potentialUsers"]
          IN
          __QUINT_LAMBDA5(VariantGetUnsafe("UserDeleted", ev_1345))
    IN
    __QUINT_LAMBDA6(__QUINT_LAMBDA7)
    THEN Append(__quint_var0, __QUINT_LAMBDA7)
    ELSE __quint_var0
  IN
  ApaFoldSeqLeft(__QUINT_LAMBDA8, <<>>, globalState["eventQueue"]))
    = Len(globalState["eventQueue"])

(*
  @type: (() => Bool);
*)
QuotasNonNegative ==
  \A u_1414 \in DOMAIN (globalState["users"]):
    ((globalState["users"][u_1414]["spec"]["quotas"]["producerByteRate"] >= 0
          /\ globalState["users"][u_1414]["spec"]["quotas"]["consumerByteRate"]
            >= 0)
        /\ globalState["users"][u_1414]["spec"]["quotas"]["requestPercentage"]
          >= 0)
      /\ globalState["users"][u_1414]["spec"]["quotas"][
        "controllerMutationRate"
      ]
        >= 0

(*
  @type: (() => Bool);
*)
QuotasRequestPercentageValid ==
  \A u_1449 \in DOMAIN (globalState["users"]):
    globalState["users"][u_1449]["spec"]["quotas"]["requestPercentage"] >= 0
      /\ globalState["users"][u_1449]["spec"]["quotas"]["requestPercentage"]
        <= 100

(*
  @type: (() => Bool);
*)
ReadyUsersQuotasValid ==
  \A u_1540 \in DOMAIN (globalState["users"]):
    globalState["users"][u_1540]["status"]["conditions"]["status"] = "Ready"
      => (((globalState["users"][u_1540]["spec"]["quotas"]["producerByteRate"]
                >= 0
              /\ globalState["users"][u_1540]["spec"]["quotas"][
                "consumerByteRate"
              ]
                >= 0)
            /\ globalState["users"][u_1540]["spec"]["quotas"][
              "requestPercentage"
            ]
              >= 0)
          /\ globalState["users"][u_1540]["spec"]["quotas"]["requestPercentage"]
            <= 100)
        /\ globalState["users"][u_1540]["spec"]["quotas"][
          "controllerMutationRate"
        ]
          >= 0

(*
  @type: (() => Bool);
*)
AuthenticationPresent ==
  \A u_1570 \in DOMAIN (globalState["users"]):
    CASE VariantTag(globalState["users"][u_1570]["spec"]["authentication"])
        = "ScramSha512Authentication"
        -> LET (*
          @type: (({ optional: Bool, secretKey: Str, secretName: Str }) => Bool);
        *)
        __QUINT_LAMBDA9(id__1562) == TRUE
        IN
        __QUINT_LAMBDA9(VariantGetUnsafe("ScramSha512Authentication", globalState[
          "users"
        ][
          u_1570
        ][
          "spec"
        ][
          "authentication"
        ]))
      [] VariantTag(globalState["users"][u_1570]["spec"]["authentication"])
        = "TlsAuthentication"
        -> LET (*
          @type: (({ enabled: Bool }) => Bool);
        *)
        __QUINT_LAMBDA10(id__1565) == TRUE
        IN
        __QUINT_LAMBDA10(VariantGetUnsafe("TlsAuthentication", globalState[
          "users"
        ][
          u_1570
        ][
          "spec"
        ][
          "authentication"
        ]))
      [] VariantTag(globalState["users"][u_1570]["spec"]["authentication"])
        = "NoneAuthentication"
        -> LET (*
          @type: (({ tag: Str }) => Bool);
        *)
        __QUINT_LAMBDA11(id__1568) == TRUE
        IN
        __QUINT_LAMBDA11(VariantGetUnsafe("NoneAuthentication", globalState[
          "users"
        ][
          u_1570
        ][
          "spec"
        ][
          "authentication"
        ]))

(*
  @type: (() => Bool);
*)
ACLsExistForAuthorizedUsers ==
  \A u_1625 \in DOMAIN (globalState["users"]):
    globalState["users"][u_1625]["spec"]["authorization"]["typeAuthz"]
      = "simple"
      => (\A rule_1622 \in globalState["users"][u_1625]["spec"]["authorization"][
        "acls"
      ]:
        (rule_1622["resource"]["name"] /= "" /\ rule_1622["host"] /= "")
          /\ rule_1622["kind"] = "allow")

(*
  @type: (() => Bool);
*)
NoACLsForDeletedUsers ==
  \A u_1660 \in DOMAIN (globalState["users"]):
    globalState["users"][u_1660]["status"]["conditions"]["status"] = "Deleted"
      => globalState["users"][u_1660]["spec"]["authorization"]["acls"] = {}

(*
  @type: (() => Bool);
*)
ReadyUsersMustHaveACLs ==
  \A u_1710 \in DOMAIN (globalState["users"]):
    globalState["users"][u_1710]["status"]["conditions"]["status"] = "Ready"
      /\ globalState["users"][u_1710]["spec"]["authorization"]["typeAuthz"]
        = "simple"
      => Cardinality(globalState["users"][u_1710]["spec"]["authorization"][
        "acls"
      ])
        > 0

(*
  @type: (() => Bool);
*)
init ==
  (\E acl \in { TRUE, FALSE }:
      parameters
        = [aclsEnabled |-> acl,
          potentialUsers |-> { "Alice", "Bob", "Carol" },
          maxProcessedEvents |-> 1000,
          authTypes |-> { "scram-sha-512", "tls", "none" },
          quotasEnabled |-> { TRUE, FALSE }])
    /\ globalState
      = [users |-> SetAsFun({}),
        secrets |-> {},
        eventQueue |-> <<>>,
        processedEvents |-> 0]

(*
  @type: ((UserCreatedWithSecret({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })) => { eventQueue: Seq(UserCreatedWithSecret({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })), processedEvents: Int, secrets: Set(Str), users: (Str -> { metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) });
*)
queueEvent(ev_303) ==
  [
    globalState EXCEPT
      !["eventQueue"] = Append(globalState["eventQueue"], ev_303)
  ]

(*
  @type: ((Bool, <<Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }), Literal({ tag: Str }) | Prefix({ tag: Str }), All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str })>>) => { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str });
*)
makeAuthz(enable_442, t_442) ==
  IF enable_442
  THEN [typeAuthz |-> "simple", acls |-> makeAcl(t_442)]
  ELSE [typeAuthz |-> "disabled", acls |-> {}]

(*
  @type: (() => Bool);
*)
NoStateChangeForPausedUsers ==
  \A u_1738 \in DOMAIN (globalState["users"]):
    reconciliationPaused(globalState["users"][u_1738])
      => globalState["users"][u_1738]["status"]["conditions"]["status"]
        /= "Ready"

(*
  @type: (({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }, UserCreatedWithSecret({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })) => { metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } });
*)
reconcileUser(user_865, ev_865) ==
  CASE VariantTag(ev_865) = "UserCreatedWithSecret"
      -> LET (*
        @type: (({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) => { metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } });
      *)
      __QUINT_LAMBDA12(cr_857) ==
        IF user_865["status"]["conditions"]["status"] = "Deleted"
        THEN [metadata |-> cr_857["metadata"],
          spec |-> cr_857["spec"],
          status |-> [conditions |-> [status |-> "Pending"]]]
        ELSE IF reconciliationPaused(cr_857)
        THEN user_865
        ELSE [metadata |-> cr_857["metadata"],
          spec |-> cr_857["spec"],
          status |-> [conditions |-> [status |-> "Ready"]]]
      IN
      __QUINT_LAMBDA12(VariantGetUnsafe("UserCreatedWithSecret", ev_865))
    [] VariantTag(ev_865) = "UserUpdated"
      -> LET (*
        @type: (({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) => { metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } });
      *)
      __QUINT_LAMBDA13(cr_860) ==
        IF user_865["status"]["conditions"]["status"] = "Deleted"
          \/ reconciliationPaused(cr_860)
        THEN user_865
        ELSE [metadata |-> cr_860["metadata"],
          spec |-> cr_860["spec"],
          status |->
            [conditions |->
                [status |->
                    IF requiresSecret(cr_860["spec"]["authentication"])
                    THEN IF cr_860["metadata"]["name"]
                      \in globalState["secrets"]
                    THEN "Ready"
                    ELSE "Pending"
                    ELSE "Ready"]]]
      IN
      __QUINT_LAMBDA13(VariantGetUnsafe("UserUpdated", ev_865))
    [] VariantTag(ev_865) = "UserDeleted"
      -> LET (*
        @type: ((Str) => { metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } });
      *)
      __QUINT_LAMBDA14(username_863) ==
        [metadata |-> user_865["metadata"],
          spec |->
            [
              user_865["spec"] EXCEPT
                !["authorization"] = [typeAuthz |-> "disabled", acls |-> {}]
            ],
          status |-> [conditions |-> [status |-> "Deleted"]]]
      IN
      __QUINT_LAMBDA14(VariantGetUnsafe("UserDeleted", ev_865))

(*
  @type: ((Str) => Bool);
*)
deleteUser(u_583) ==
  (IF u_583 \in DOMAIN (globalState["users"])
    THEN globalState' := (queueEvent((UserDeleted(u_583))))
    ELSE globalState' := globalState)

(*
  @type: (() => Bool);
*)
q_init == init

(*
  @type: (({ eventQueue: Seq(UserCreatedWithSecret({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })), processedEvents: Int, secrets: Set(Str), users: (Str -> { metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) }, UserCreatedWithSecret({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }), Conflict({ tag: Str }) | Gone({ tag: Str }) | None({ tag: Str }) | Pause({ tag: Str }) | ServerError({ tag: Str })) => { eventQueue: Seq(UserCreatedWithSecret({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })), processedEvents: Int, secrets: Set(Str), users: (Str -> { metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) });
*)
processEvent(state_1140, ev_1140, fault_1140) ==
  IF shouldSkipReconcile(fault_1140)
  THEN [
    state_1140 EXCEPT
      !["processedEvents"] = state_1140["processedEvents"] + 1
  ]
  ELSE CASE VariantTag(ev_1140) = "UserCreatedWithSecret"
      -> LET (*
        @type: (({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) => { eventQueue: Seq(UserCreatedWithSecret({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })), processedEvents: Int, secrets: Set(Str), users: (Str -> { metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) });
      *)
      __QUINT_LAMBDA15(cr_1131) ==
        IF cr_1131["metadata"]["name"] \in DOMAIN (state_1140["users"])
        THEN [users |->
            LET (*
              @type: (() => (Str -> { metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }));
            *)
            __quint_var1 == state_1140["users"]
            IN
            LET (*
              @type: (() => Set(Str));
            *)
            __quint_var2 == DOMAIN __quint_var1
            IN
            [
              __quint_var3 \in {cr_1131["metadata"]["name"]} \union __quint_var2 |->
                IF __quint_var3 = cr_1131["metadata"]["name"]
                THEN reconcileUser(state_1140["users"][
                  cr_1131["metadata"]["name"]
                ], ev_1140)
                ELSE (__quint_var1)[__quint_var3]
            ],
          secrets |->
            IF requiresSecret(cr_1131["spec"]["authentication"])
            THEN state_1140["secrets"] \union {cr_1131["metadata"]["name"]}
            ELSE state_1140["secrets"],
          eventQueue |-> state_1140["eventQueue"],
          processedEvents |-> state_1140["processedEvents"] + 1]
        ELSE [users |->
            LET (*
              @type: (() => (Str -> { metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }));
            *)
            __quint_var4 == state_1140["users"]
            IN
            LET (*
              @type: (() => Set(Str));
            *)
            __quint_var5 == DOMAIN __quint_var4
            IN
            [
              __quint_var6 \in {cr_1131["metadata"]["name"]} \union __quint_var5 |->
                IF __quint_var6 = cr_1131["metadata"]["name"]
                THEN reconcileUser(cr_1131, ev_1140)
                ELSE (__quint_var4)[__quint_var6]
            ],
          secrets |->
            IF requiresSecret(cr_1131["spec"]["authentication"])
            THEN state_1140["secrets"] \union {cr_1131["metadata"]["name"]}
            ELSE state_1140["secrets"],
          eventQueue |-> state_1140["eventQueue"],
          processedEvents |-> state_1140["processedEvents"] + 1]
      IN
      __QUINT_LAMBDA15(VariantGetUnsafe("UserCreatedWithSecret", ev_1140))
    [] VariantTag(ev_1140) = "UserUpdated"
      -> LET (*
        @type: (({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) => { eventQueue: Seq(UserCreatedWithSecret({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })), processedEvents: Int, secrets: Set(Str), users: (Str -> { metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) });
      *)
      __QUINT_LAMBDA16(cr_1134) ==
        IF cr_1134["metadata"]["name"] \in DOMAIN (state_1140["users"])
        THEN [users |->
            LET (*
              @type: (() => (Str -> { metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }));
            *)
            __quint_var7 == state_1140["users"]
            IN
            LET (*
              @type: (() => Set(Str));
            *)
            __quint_var8 == DOMAIN __quint_var7
            IN
            [
              __quint_var9 \in {cr_1134["metadata"]["name"]} \union __quint_var8 |->
                IF __quint_var9 = cr_1134["metadata"]["name"]
                THEN reconcileUser(state_1140["users"][
                  cr_1134["metadata"]["name"]
                ], ev_1140)
                ELSE (__quint_var7)[__quint_var9]
            ],
          secrets |->
            IF state_1140["users"][cr_1134["metadata"]["name"]]["status"][
                "conditions"
              ][
                "status"
              ]
                = "Deleted"
              \/ reconciliationPaused(cr_1134)
            THEN state_1140["secrets"]
            ELSE IF requiresSecret(cr_1134["spec"]["authentication"])
            THEN state_1140["secrets"] \union {cr_1134["metadata"]["name"]}
            ELSE state_1140["secrets"] \ {cr_1134["metadata"]["name"]},
          eventQueue |-> state_1140["eventQueue"],
          processedEvents |-> state_1140["processedEvents"] + 1]
        ELSE state_1140
      IN
      __QUINT_LAMBDA16(VariantGetUnsafe("UserUpdated", ev_1140))
    [] VariantTag(ev_1140) = "UserDeleted"
      -> LET (*
        @type: ((Str) => { eventQueue: Seq(UserCreatedWithSecret({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })), processedEvents: Int, secrets: Set(Str), users: (Str -> { metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) });
      *)
      __QUINT_LAMBDA17(username_1137) ==
        IF username_1137 \in DOMAIN (state_1140["users"])
        THEN [users |->
            LET (*
              @type: (() => (Str -> { metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }));
            *)
            __quint_var10 == state_1140["users"]
            IN
            LET (*
              @type: (() => Set(Str));
            *)
            __quint_var11 == DOMAIN __quint_var10
            IN
            [
              __quint_var12 \in {username_1137} \union __quint_var11 |->
                IF __quint_var12 = username_1137
                THEN reconcileUser(state_1140["users"][username_1137], ev_1140)
                ELSE (__quint_var10)[__quint_var12]
            ],
          secrets |-> state_1140["secrets"] \ {username_1137},
          eventQueue |-> state_1140["eventQueue"],
          processedEvents |-> state_1140["processedEvents"] + 1]
        ELSE state_1140
      IN
      __QUINT_LAMBDA17(VariantGetUnsafe("UserDeleted", ev_1140))

(*
  @type: ((Str, Str, Bool, Bool) => Bool);
*)
createUser(u_498, authType_498, quotasEnabled_498, aclsEnabled_498) ==
  (\E authzParams \in RESOURCE_TYPES \X PATTERNS \X OPS:
      \E reconciliationPaused_495 \in { TRUE, FALSE }:
        globalState'
          := (queueEvent((UserCreatedWithSecret([metadata |->
              [name |-> u_498,
                annotations |->
                  IF reconciliationPaused_495
                  THEN SetAsFun({<<"strimzi.io/pause-reconciliation", "true">>})
                  ELSE SetAsFun({})],
            spec |->
              [authentication |-> makeAuth(u_498, authType_498),
                authorization |-> makeAuthz(aclsEnabled_498, authzParams),
                quotas |-> makeQuotas(quotasEnabled_498)],
            status |-> [conditions |-> [status |-> "Pending"]]])))))

(*
  @type: ((Str, Str, Bool, Bool) => Bool);
*)
updateUser(u_564, authType_564, quotasEnabled_564, aclsEnabled_564) ==
  (\E authzParams \in RESOURCE_TYPES \X PATTERNS \X OPS:
      \E reconciliationPaused_561 \in { TRUE, FALSE }:
        IF u_564 \in DOMAIN (globalState["users"])
        THEN globalState'
          := (queueEvent((UserUpdated([metadata |->
              [name |-> u_564,
                annotations |->
                  IF reconciliationPaused_561
                  THEN SetAsFun({<<"strimzi.io/pause-reconciliation", "true">>})
                  ELSE SetAsFun({})],
            spec |->
              [authentication |-> makeAuth(u_564, authType_564),
                authorization |-> makeAuthz(aclsEnabled_564, authzParams),
                quotas |-> makeQuotas(quotasEnabled_564)],
            status |-> [conditions |-> [status |-> "Pending"]]]))))
        ELSE globalState' := globalState)

(*
  @type: (() => Bool);
*)
FaultsDoNotAffectState ==
  \A f_1793 \in { (Pause), (Conflict), (Gone), (ServerError) }:
    Len(globalState["eventQueue"]) > 0
      => (processEvent([
          globalState EXCEPT
            !["eventQueue"] = Tail(globalState["eventQueue"])
        ], (Head(globalState["eventQueue"])), f_1793))[
          "users"
        ]
          = globalState["users"]
        /\ (processEvent([
          globalState EXCEPT
            !["eventQueue"] = Tail(globalState["eventQueue"])
        ], (Head(globalState["eventQueue"])), f_1793))[
          "secrets"
        ]
          = globalState["secrets"]

(*
  @type: ((Conflict({ tag: Str }) | Gone({ tag: Str }) | None({ tag: Str }) | Pause({ tag: Str }) | ServerError({ tag: Str })) => Bool);
*)
processNextEvent(fault_612) ==
  (IF Len(globalState["eventQueue"]) > 0
    THEN globalState'
      := (processEvent([
        globalState EXCEPT
          !["eventQueue"] = Tail(globalState["eventQueue"])
      ], (Head(globalState["eventQueue"])), fault_612))
    ELSE globalState' := globalState)

(*
  @type: (() => Bool);
*)
AllInvariantsHold ==
  (IF UserConsistency THEN TRUE ELSE debug("UserConsistency", FALSE))
    /\ (IF SecretsConsistency THEN TRUE ELSE debug("SecretsConsistency", FALSE))
    /\ (IF NoSecretsForDeletedUsers
    THEN TRUE
    ELSE debug("NoSecretsForDeletedUsers", FALSE))
    /\ (IF ReadyUsersMustHaveSecrets
    THEN TRUE
    ELSE debug("ReadyUsersMustHaveSecrets", FALSE))
    /\ (IF EventQueueWellFormed
    THEN TRUE
    ELSE debug("EventQueueWellFormed", FALSE))
    /\ (IF QuotasNonNegative THEN TRUE ELSE debug("QuotasNonNegative", FALSE))
    /\ (IF QuotasRequestPercentageValid
    THEN TRUE
    ELSE debug("QuotasRequestPercentageValid", FALSE))
    /\ (IF ReadyUsersQuotasValid
    THEN TRUE
    ELSE debug("ReadyUsersQuotasValid", FALSE))
    /\ (IF AuthenticationPresent
    THEN TRUE
    ELSE debug("AuthenticationPresent", FALSE))
    /\ (IF ACLsExistForAuthorizedUsers
    THEN TRUE
    ELSE debug("ACLsExistForAuthorizedUsers", FALSE))
    /\ (IF NoACLsForDeletedUsers
    THEN TRUE
    ELSE debug("NoACLsForDeletedUsers", FALSE))
    /\ (IF ReadyUsersMustHaveACLs
    THEN TRUE
    ELSE debug("ReadyUsersMustHaveACLs", FALSE))
    /\ (IF NoStateChangeForPausedUsers
    THEN TRUE
    ELSE debug("NoStateChangeForPausedUsers", FALSE))
    /\ (IF FaultsDoNotAffectState
    THEN TRUE
    ELSE debug("FaultsDoNotAffectState", FALSE))

(*
  @type: (() => Bool);
*)
step ==
  (\E u \in parameters["potentialUsers"]:
      \E authType \in parameters["authTypes"]:
        \E quotasEnabled \in parameters["quotasEnabled"]:
          \E fault \in { (None), (Pause), (Conflict), (Gone), (ServerError) }:
            IF globalState["processedEvents"] + Len(globalState["eventQueue"])
              < parameters["maxProcessedEvents"]
            THEN createUser(u, authType, quotasEnabled, parameters[
                "aclsEnabled"
              ])
              \/ updateUser(u, authType, quotasEnabled, parameters[
                "aclsEnabled"
              ])
              \/ deleteUser(u)
              \/ processNextEvent(fault)
            ELSE processNextEvent(fault))
    /\ parameters' := parameters

(*
  @type: (() => Bool);
*)
EventuallyStableReconciliationProperty ==
  SF_globalState(step)
    => []<>((Len(globalState["eventQueue"]) = 0 /\ isStable(globalState))
      \/ globalState["processedEvents"] >= parameters["maxProcessedEvents"])

(*
  @type: (() => Bool);
*)
q_step == step

(*
  @type: (() => Bool);
*)
q_temporalProps == EventuallyStableReconciliationProperty

================================================================================
