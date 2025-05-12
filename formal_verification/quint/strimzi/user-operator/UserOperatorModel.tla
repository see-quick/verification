# Usage statistics is OFF. We care about your privacy.
# If you want to help our project, consider enabling statistics with config --enable-stats=true.

Output directory: /Users/morsak/Documents/Work/verification/formal_verification/quint/strimzi/user-operator/_apalache-out/server/2025-05-12T10-29-32_7690100746968503133
# APALACHE version: 0.47.2 | build: def5e8e                       I@10:29:32.574
Starting server on port 8822...                                   I@10:29:32.577
The Apalache server is running on port 8822. Press Ctrl-C to stop.
PASS #0: SanyParser                                               I@10:29:33.599
--------------------------- MODULE UserOperatorModel ---------------------------

EXTENDS Integers, Sequences, FiniteSets, TLC, Apalache, Variants

VARIABLE
  (*
    @type: { aclsEnabled: Bool, authTypes: Set(Str), maxProcessedEvents: Int, potentialUsers: Set(Str), quotasEnabled: Set(Bool), useDesiredPassword: Set(Bool) };
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
  @type: (() => Conflict({ tag: Str }) | Gone({ tag: Str }) | None({ tag: Str }) | Pause({ tag: Str }) | ServerError({ tag: Str }));
*)
Gone == Variant("Gone", [tag |-> "UNIT"])

(*
  @type: ((a, b) => b);
*)
debug(s_1811, a_1811) == a_1811

(*
  @type: (() => Conflict({ tag: Str }) | Gone({ tag: Str }) | None({ tag: Str }) | Pause({ tag: Str }) | ServerError({ tag: Str }));
*)
ServerError == Variant("ServerError", [tag |-> "UNIT"])

(*
  @type: (({ useDesiredPassword: Bool }) => NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }));
*)
ScramSha512Authentication(__ScramSha512AuthenticationParam_18) ==
  Variant("ScramSha512Authentication", __ScramSha512AuthenticationParam_18)

(*
  @type: (({ enabled: Bool }) => NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }));
*)
TlsAuthentication(__TlsAuthenticationParam_24) ==
  Variant("TlsAuthentication", __TlsAuthenticationParam_24)

(*
  @type: (() => NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }));
*)
NoneAuthentication == Variant("NoneAuthentication", [tag |-> "UNIT"])

(*
  @type: ((NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool })) => Bool);
*)
requiresSecret(auth_294) ==
  CASE VariantTag(auth_294) = "ScramSha512Authentication"
      -> LET (*
        @type: (({ useDesiredPassword: Bool }) => Bool);
      *)
      __QUINT_LAMBDA0(id__286) == TRUE
      IN
      __QUINT_LAMBDA0(VariantGetUnsafe("ScramSha512Authentication", auth_294))
    [] VariantTag(auth_294) = "TlsAuthentication"
      -> LET (*
        @type: (({ enabled: Bool }) => Bool);
      *)
      __QUINT_LAMBDA1(id__289) == TRUE
      IN
      __QUINT_LAMBDA1(VariantGetUnsafe("TlsAuthentication", auth_294))
    [] VariantTag(auth_294) = "NoneAuthentication"
      -> LET (*
        @type: (({ tag: Str }) => Bool);
      *)
      __QUINT_LAMBDA2(id__292) == FALSE
      IN
      __QUINT_LAMBDA2(VariantGetUnsafe("NoneAuthentication", auth_294))

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
getOrElse(m_710, k_710, default_710) ==
  IF k_710 \in DOMAIN m_710 THEN m_710[k_710] ELSE default_710

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
  @type: (({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) => UserCreatedWithSecret({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }));
*)
UserCreatedWithSecret(__UserCreatedWithSecretParam_195) ==
  Variant("UserCreatedWithSecret", __UserCreatedWithSecretParam_195)

(*
  @type: (({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) => UserCreatedWithSecret({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }));
*)
UserUpdated(__UserUpdatedParam_201) ==
  Variant("UserUpdated", __UserUpdatedParam_201)

(*
  @type: ((Str) => UserCreatedWithSecret({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }));
*)
UserDeleted(__UserDeletedParam_207) ==
  Variant("UserDeleted", __UserDeletedParam_207)

VARIABLE
  (*
    @type: { eventQueue: Seq(UserCreatedWithSecret({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })), processedEvents: Int, secrets: Set(Str), users: (Str -> { metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) };
  *)
  globalState

(*
  @type: ((Str, Bool) => NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }));
*)
makeAuth(authType_331, useDesiredPassword_331) ==
  IF authType_331 = "scram-sha-512"
  THEN ScramSha512Authentication([useDesiredPassword |-> useDesiredPassword_331])
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
shouldSkipReconcile(f_745) ==
  ((f_745 = Pause \/ f_745 = Conflict) \/ f_745 = Gone) \/ f_745 = ServerError

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
  @type: (({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) => Bool);
*)
reconciliationPaused(user_725) ==
  getOrElse(user_725["metadata"]["annotations"], "strimzi.io/pause-reconciliation",
  "")
    = "true"

(*
  @type: (({ eventQueue: Seq(UserCreatedWithSecret({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })), processedEvents: Int, secrets: Set(Str), users: (Str -> { metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) }) => Bool);
*)
isStable(state_1943) ==
  \A u_1941 \in parameters["potentialUsers"]:
    (~(u_1941 \in DOMAIN (state_1943["users"]))
        \/ state_1943["users"][u_1941]["status"]["conditions"]["status"]
          = "Ready")
      \/ state_1943["users"][u_1941]["status"]["conditions"]["status"]
        = "Deleted"

(*
  @type: (() => Bool);
*)
UserConsistency ==
  \A u_1211 \in DOMAIN (globalState["users"]):
    (globalState["users"][u_1211]["status"]["conditions"]["status"] = "Ready"
        => ~(requiresSecret(globalState["users"][u_1211]["spec"][
            "authentication"
          ]))
          \/ u_1211 \in globalState["secrets"])
      /\ (globalState["users"][u_1211]["status"]["conditions"]["status"]
        = "Deleted"
        => ~(u_1211 \in globalState["secrets"]))

(*
  @type: (() => Bool);
*)
SecretsConsistency ==
  \A u_1249 \in DOMAIN (globalState["users"]):
    requiresSecret(globalState["users"][u_1249]["spec"]["authentication"])
      /\ globalState["users"][u_1249]["status"]["conditions"]["status"]
        = "Ready"
      => u_1249 \in globalState["secrets"]

(*
  @type: (() => Bool);
*)
NoSecretsForDeletedUsers ==
  \A u_1277 \in DOMAIN (globalState["users"]):
    globalState["users"][u_1277]["status"]["conditions"]["status"] = "Deleted"
      => ~(u_1277 \in globalState["secrets"])

(*
  @type: (() => Bool);
*)
ReadyUsersMustHaveSecrets ==
  \A u_1316 \in DOMAIN (globalState["users"]):
    globalState["users"][u_1316]["status"]["conditions"]["status"] = "Ready"
      => ~(requiresSecret(globalState["users"][u_1316]["spec"]["authentication"]))
        \/ u_1316 \in globalState["secrets"]

(*
  @type: (() => Bool);
*)
EventQueueWellFormed ==
  Len(LET (*
    @type: ((Seq(UserCreatedWithSecret({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })), UserCreatedWithSecret({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })) => Seq(UserCreatedWithSecret({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })));
  *)
  __QUINT_LAMBDA8(__quint_var0, __QUINT_LAMBDA7) ==
    IF LET (*
      @type: ((UserCreatedWithSecret({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })) => Bool);
    *)
    __QUINT_LAMBDA6(ev_1357) ==
      CASE VariantTag(ev_1357) = "UserCreatedWithSecret"
          -> LET (*
            @type: (({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) => Bool);
          *)
          __QUINT_LAMBDA3(cr_1349) ==
            cr_1349["metadata"]["name"] \in parameters["potentialUsers"]
          IN
          __QUINT_LAMBDA3(VariantGetUnsafe("UserCreatedWithSecret", ev_1357))
        [] VariantTag(ev_1357) = "UserUpdated"
          -> LET (*
            @type: (({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) => Bool);
          *)
          __QUINT_LAMBDA4(cr_1352) ==
            cr_1352["metadata"]["name"] \in parameters["potentialUsers"]
          IN
          __QUINT_LAMBDA4(VariantGetUnsafe("UserUpdated", ev_1357))
        [] VariantTag(ev_1357) = "UserDeleted"
          -> LET (*
            @type: ((Str) => Bool);
          *)
          __QUINT_LAMBDA5(u_1355) == u_1355 \in parameters["potentialUsers"]
          IN
          __QUINT_LAMBDA5(VariantGetUnsafe("UserDeleted", ev_1357))
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
  \A u_1426 \in DOMAIN (globalState["users"]):
    ((globalState["users"][u_1426]["spec"]["quotas"]["producerByteRate"] >= 0
          /\ globalState["users"][u_1426]["spec"]["quotas"]["consumerByteRate"]
            >= 0)
        /\ globalState["users"][u_1426]["spec"]["quotas"]["requestPercentage"]
          >= 0)
      /\ globalState["users"][u_1426]["spec"]["quotas"][
        "controllerMutationRate"
      ]
        >= 0

(*
  @type: (() => Bool);
*)
QuotasRequestPercentageValid ==
  \A u_1461 \in DOMAIN (globalState["users"]):
    globalState["users"][u_1461]["spec"]["quotas"]["requestPercentage"] >= 0
      /\ globalState["users"][u_1461]["spec"]["quotas"]["requestPercentage"]
        <= 100

(*
  @type: (() => Bool);
*)
ReadyUsersQuotasValid ==
  \A u_1552 \in DOMAIN (globalState["users"]):
    globalState["users"][u_1552]["status"]["conditions"]["status"] = "Ready"
      => (((globalState["users"][u_1552]["spec"]["quotas"]["producerByteRate"]
                >= 0
              /\ globalState["users"][u_1552]["spec"]["quotas"][
                "consumerByteRate"
              ]
                >= 0)
            /\ globalState["users"][u_1552]["spec"]["quotas"][
              "requestPercentage"
            ]
              >= 0)
          /\ globalState["users"][u_1552]["spec"]["quotas"]["requestPercentage"]
            <= 100)
        /\ globalState["users"][u_1552]["spec"]["quotas"][
          "controllerMutationRate"
        ]
          >= 0

(*
  @type: (() => Bool);
*)
AuthenticationPresent ==
  \A u_1582 \in DOMAIN (globalState["users"]):
    CASE VariantTag(globalState["users"][u_1582]["spec"]["authentication"])
        = "ScramSha512Authentication"
        -> LET (*
          @type: (({ useDesiredPassword: Bool }) => Bool);
        *)
        __QUINT_LAMBDA9(id__1574) == TRUE
        IN
        __QUINT_LAMBDA9(VariantGetUnsafe("ScramSha512Authentication", globalState[
          "users"
        ][
          u_1582
        ][
          "spec"
        ][
          "authentication"
        ]))
      [] VariantTag(globalState["users"][u_1582]["spec"]["authentication"])
        = "TlsAuthentication"
        -> LET (*
          @type: (({ enabled: Bool }) => Bool);
        *)
        __QUINT_LAMBDA10(id__1577) == TRUE
        IN
        __QUINT_LAMBDA10(VariantGetUnsafe("TlsAuthentication", globalState[
          "users"
        ][
          u_1582
        ][
          "spec"
        ][
          "authentication"
        ]))
      [] VariantTag(globalState["users"][u_1582]["spec"]["authentication"])
        = "NoneAuthentication"
        -> LET (*
          @type: (({ tag: Str }) => Bool);
        *)
        __QUINT_LAMBDA11(id__1580) == TRUE
        IN
        __QUINT_LAMBDA11(VariantGetUnsafe("NoneAuthentication", globalState[
          "users"
        ][
          u_1582
        ][
          "spec"
        ][
          "authentication"
        ]))

(*
  @type: (() => Bool);
*)
ACLsExistForAuthorizedUsers ==
  \A u_1637 \in DOMAIN (globalState["users"]):
    globalState["users"][u_1637]["spec"]["authorization"]["typeAuthz"]
      = "simple"
      => (\A rule_1634 \in globalState["users"][u_1637]["spec"]["authorization"][
        "acls"
      ]:
        (rule_1634["resource"]["name"] /= "" /\ rule_1634["host"] /= "")
          /\ rule_1634["kind"] = "allow")

(*
  @type: (() => Bool);
*)
NoACLsForDeletedUsers ==
  \A u_1672 \in DOMAIN (globalState["users"]):
    globalState["users"][u_1672]["status"]["conditions"]["status"] = "Deleted"
      => globalState["users"][u_1672]["spec"]["authorization"]["acls"] = {}

(*
  @type: (() => Bool);
*)
ReadyUsersMustHaveACLs ==
  \A u_1722 \in DOMAIN (globalState["users"]):
    globalState["users"][u_1722]["status"]["conditions"]["status"] = "Ready"
      /\ globalState["users"][u_1722]["spec"]["authorization"]["typeAuthz"]
        = "simple"
      => Cardinality(globalState["users"][u_1722]["spec"]["authorization"][
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
          quotasEnabled |-> { TRUE, FALSE },
          useDesiredPassword |-> { TRUE, FALSE }])
    /\ globalState
      = [users |-> SetAsFun({}),
        secrets |-> {},
        eventQueue |-> <<>>,
        processedEvents |-> 0]

(*
  @type: ((UserCreatedWithSecret({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })) => { eventQueue: Seq(UserCreatedWithSecret({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })), processedEvents: Int, secrets: Set(Str), users: (Str -> { metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) });
*)
queueEvent(ev_307) ==
  [
    globalState EXCEPT
      !["eventQueue"] = Append(globalState["eventQueue"], ev_307)
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
  \A u_1750 \in DOMAIN (globalState["users"]):
    reconciliationPaused(globalState["users"][u_1750])
      => globalState["users"][u_1750]["status"]["conditions"]["status"]
        /= "Ready"

(*
  @type: (({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }, UserCreatedWithSecret({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })) => { metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } });
*)
reconcileUser(user_877, ev_877) ==
  CASE VariantTag(ev_877) = "UserCreatedWithSecret"
      -> LET (*
        @type: (({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) => { metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } });
      *)
      __QUINT_LAMBDA12(cr_869) ==
        IF user_877["status"]["conditions"]["status"] = "Deleted"
        THEN [metadata |-> cr_869["metadata"],
          spec |-> cr_869["spec"],
          status |-> [conditions |-> [status |-> "Pending"]]]
        ELSE IF reconciliationPaused(cr_869)
        THEN user_877
        ELSE [metadata |-> cr_869["metadata"],
          spec |-> cr_869["spec"],
          status |-> [conditions |-> [status |-> "Ready"]]]
      IN
      __QUINT_LAMBDA12(VariantGetUnsafe("UserCreatedWithSecret", ev_877))
    [] VariantTag(ev_877) = "UserUpdated"
      -> LET (*
        @type: (({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) => { metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } });
      *)
      __QUINT_LAMBDA13(cr_872) ==
        IF user_877["status"]["conditions"]["status"] = "Deleted"
          \/ reconciliationPaused(cr_872)
        THEN user_877
        ELSE [metadata |-> cr_872["metadata"],
          spec |-> cr_872["spec"],
          status |->
            [conditions |->
                [status |->
                    IF requiresSecret(cr_872["spec"]["authentication"])
                    THEN IF cr_872["metadata"]["name"]
                      \in globalState["secrets"]
                    THEN "Ready"
                    ELSE "Pending"
                    ELSE "Ready"]]]
      IN
      __QUINT_LAMBDA13(VariantGetUnsafe("UserUpdated", ev_877))
    [] VariantTag(ev_877) = "UserDeleted"
      -> LET (*
        @type: ((Str) => { metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } });
      *)
      __QUINT_LAMBDA14(username_875) ==
        [metadata |-> user_877["metadata"],
          spec |->
            [
              user_877["spec"] EXCEPT
                !["authorization"] = [typeAuthz |-> "disabled", acls |-> {}]
            ],
          status |-> [conditions |-> [status |-> "Deleted"]]]
      IN
      __QUINT_LAMBDA14(VariantGetUnsafe("UserDeleted", ev_877))

(*
  @type: ((Str) => Bool);
*)
deleteUser(u_595) ==
  (IF u_595 \in DOMAIN (globalState["users"])
    THEN globalState' := (queueEvent((UserDeleted(u_595))))
    ELSE globalState' := globalState)

(*
  @type: (() => Bool);
*)
q_init == init

(*
  @type: (({ eventQueue: Seq(UserCreatedWithSecret({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })), processedEvents: Int, secrets: Set(Str), users: (Str -> { metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) }, UserCreatedWithSecret({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }), Conflict({ tag: Str }) | Gone({ tag: Str }) | None({ tag: Str }) | Pause({ tag: Str }) | ServerError({ tag: Str })) => { eventQueue: Seq(UserCreatedWithSecret({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })), processedEvents: Int, secrets: Set(Str), users: (Str -> { metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) });
*)
processEvent(state_1152, ev_1152, fault_1152) ==
  IF shouldSkipReconcile(fault_1152)
  THEN [
    state_1152 EXCEPT
      !["processedEvents"] = state_1152["processedEvents"] + 1
  ]
  ELSE CASE VariantTag(ev_1152) = "UserCreatedWithSecret"
      -> LET (*
        @type: (({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) => { eventQueue: Seq(UserCreatedWithSecret({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })), processedEvents: Int, secrets: Set(Str), users: (Str -> { metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) });
      *)
      __QUINT_LAMBDA15(cr_1143) ==
        IF cr_1143["metadata"]["name"] \in DOMAIN (state_1152["users"])
        THEN [users |->
            LET (*
              @type: (() => (Str -> { metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }));
            *)
            __quint_var1 == state_1152["users"]
            IN
            LET (*
              @type: (() => Set(Str));
            *)
            __quint_var2 == DOMAIN __quint_var1
            IN
            [
              __quint_var3 \in {cr_1143["metadata"]["name"]} \union __quint_var2 |->
                IF __quint_var3 = cr_1143["metadata"]["name"]
                THEN reconcileUser(state_1152["users"][
                  cr_1143["metadata"]["name"]
                ], ev_1152)
                ELSE (__quint_var1)[__quint_var3]
            ],
          secrets |->
            IF requiresSecret(cr_1143["spec"]["authentication"])
            THEN state_1152["secrets"] \union {cr_1143["metadata"]["name"]}
            ELSE state_1152["secrets"],
          eventQueue |-> state_1152["eventQueue"],
          processedEvents |-> state_1152["processedEvents"] + 1]
        ELSE [users |->
            LET (*
              @type: (() => (Str -> { metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }));
            *)
            __quint_var4 == state_1152["users"]
            IN
            LET (*
              @type: (() => Set(Str));
            *)
            __quint_var5 == DOMAIN __quint_var4
            IN
            [
              __quint_var6 \in {cr_1143["metadata"]["name"]} \union __quint_var5 |->
                IF __quint_var6 = cr_1143["metadata"]["name"]
                THEN reconcileUser(cr_1143, ev_1152)
                ELSE (__quint_var4)[__quint_var6]
            ],
          secrets |->
            IF requiresSecret(cr_1143["spec"]["authentication"])
            THEN state_1152["secrets"] \union {cr_1143["metadata"]["name"]}
            ELSE state_1152["secrets"],
          eventQueue |-> state_1152["eventQueue"],
          processedEvents |-> state_1152["processedEvents"] + 1]
      IN
      __QUINT_LAMBDA15(VariantGetUnsafe("UserCreatedWithSecret", ev_1152))
    [] VariantTag(ev_1152) = "UserUpdated"
      -> LET (*
        @type: (({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) => { eventQueue: Seq(UserCreatedWithSecret({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })), processedEvents: Int, secrets: Set(Str), users: (Str -> { metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) });
      *)
      __QUINT_LAMBDA16(cr_1146) ==
        IF cr_1146["metadata"]["name"] \in DOMAIN (state_1152["users"])
        THEN [users |->
            LET (*
              @type: (() => (Str -> { metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }));
            *)
            __quint_var7 == state_1152["users"]
            IN
            LET (*
              @type: (() => Set(Str));
            *)
            __quint_var8 == DOMAIN __quint_var7
            IN
            [
              __quint_var9 \in {cr_1146["metadata"]["name"]} \union __quint_var8 |->
                IF __quint_var9 = cr_1146["metadata"]["name"]
                THEN reconcileUser(state_1152["users"][
                  cr_1146["metadata"]["name"]
                ], ev_1152)
                ELSE (__quint_var7)[__quint_var9]
            ],
          secrets |->
            IF state_1152["users"][cr_1146["metadata"]["name"]]["status"][
                "conditions"
              ][
                "status"
              ]
                = "Deleted"
              \/ reconciliationPaused(cr_1146)
            THEN state_1152["secrets"]
            ELSE IF requiresSecret(cr_1146["spec"]["authentication"])
            THEN state_1152["secrets"] \union {cr_1146["metadata"]["name"]}
            ELSE state_1152["secrets"] \ {cr_1146["metadata"]["name"]},
          eventQueue |-> state_1152["eventQueue"],
          processedEvents |-> state_1152["processedEvents"] + 1]
        ELSE state_1152
      IN
      __QUINT_LAMBDA16(VariantGetUnsafe("UserUpdated", ev_1152))
    [] VariantTag(ev_1152) = "UserDeleted"
      -> LET (*
        @type: ((Str) => { eventQueue: Seq(UserCreatedWithSecret({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })), processedEvents: Int, secrets: Set(Str), users: (Str -> { metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) });
      *)
      __QUINT_LAMBDA17(username_1149) ==
        IF username_1149 \in DOMAIN (state_1152["users"])
        THEN [users |->
            LET (*
              @type: (() => (Str -> { metadata: { annotations: (Str -> Str), name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ useDesiredPassword: Bool }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: Literal({ tag: Str }) | Prefix({ tag: Str }), typeAcl: Cluster({ tag: Str }) | Group({ tag: Str }) | Topic({ tag: Str }) | TransactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }));
            *)
            __quint_var10 == state_1152["users"]
            IN
            LET (*
              @type: (() => Set(Str));
            *)
            __quint_var11 == DOMAIN __quint_var10
            IN
            [
              __quint_var12 \in {username_1149} \union __quint_var11 |->
                IF __quint_var12 = username_1149
                THEN reconcileUser(state_1152["users"][username_1149], ev_1152)
                ELSE (__quint_var10)[__quint_var12]
            ],
          secrets |-> state_1152["secrets"] \ {username_1149},
          eventQueue |-> state_1152["eventQueue"],
          processedEvents |-> state_1152["processedEvents"] + 1]
        ELSE state_1152
      IN
      __QUINT_LAMBDA17(VariantGetUnsafe("UserDeleted", ev_1152))

(*
  @type: ((Str, Str, Bool, Bool) => Bool);
*)
createUser(u_504, authType_504, quotasEnabled_504, aclsEnabled_504) ==
  (\E authzParams \in RESOURCE_TYPES \X PATTERNS \X OPS:
      \E reconciliationPaused_501 \in { TRUE, FALSE }:
        \E useDesiredPassword \in parameters["useDesiredPassword"]:
          globalState'
            := (queueEvent((UserCreatedWithSecret([metadata |->
                [name |-> u_504,
                  annotations |->
                    IF reconciliationPaused_501
                    THEN SetAsFun({<<"strimzi.io/pause-reconciliation", "true">>})
                    ELSE SetAsFun({})],
              spec |->
                [authentication |-> makeAuth(authType_504, useDesiredPassword),
                  authorization |-> makeAuthz(aclsEnabled_504, authzParams),
                  quotas |-> makeQuotas(quotasEnabled_504)],
              status |-> [conditions |-> [status |-> "Pending"]]])))))

(*
  @type: ((Str, Str, Bool, Bool) => Bool);
*)
updateUser(u_576, authType_576, quotasEnabled_576, aclsEnabled_576) ==
  (\E authzParams \in RESOURCE_TYPES \X PATTERNS \X OPS:
      \E reconciliationPaused_573 \in { TRUE, FALSE }:
        \E useDesiredPassword \in parameters["useDesiredPassword"]:
          IF u_576 \in DOMAIN (globalState["users"])
          THEN globalState'
            := (queueEvent((UserUpdated([metadata |->
                [name |-> u_576,
                  annotations |->
                    IF reconciliationPaused_573
                    THEN SetAsFun({<<"strimzi.io/pause-reconciliation", "true">>})
                    ELSE SetAsFun({})],
              spec |->
                [authentication |-> makeAuth(authType_576, useDesiredPassword),
                  authorization |-> makeAuthz(aclsEnabled_576, authzParams),
                  quotas |-> makeQuotas(quotasEnabled_576)],
              status |-> [conditions |-> [status |-> "Pending"]]]))))
          ELSE globalState' := globalState)

(*
  @type: (() => Bool);
*)
FaultsDoNotAffectState ==
  \A f_1805 \in { (Pause), (Conflict), (Gone), (ServerError) }:
    Len(globalState["eventQueue"]) > 0
      => (processEvent([
          globalState EXCEPT
            !["eventQueue"] = Tail(globalState["eventQueue"])
        ], (Head(globalState["eventQueue"])), f_1805))[
          "users"
        ]
          = globalState["users"]
        /\ (processEvent([
          globalState EXCEPT
            !["eventQueue"] = Tail(globalState["eventQueue"])
        ], (Head(globalState["eventQueue"])), f_1805))[
          "secrets"
        ]
          = globalState["secrets"]

(*
  @type: ((Conflict({ tag: Str }) | Gone({ tag: Str }) | None({ tag: Str }) | Pause({ tag: Str }) | ServerError({ tag: Str })) => Bool);
*)
processNextEvent(fault_624) ==
  (IF Len(globalState["eventQueue"]) > 0
    THEN globalState'
      := (processEvent([
        globalState EXCEPT
          !["eventQueue"] = Tail(globalState["eventQueue"])
      ], (Head(globalState["eventQueue"])), fault_624))
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
