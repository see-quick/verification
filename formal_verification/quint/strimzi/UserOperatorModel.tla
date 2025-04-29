# Usage statistics is OFF. We care about your privacy.
# If you want to help our project, consider enabling statistics with config --enable-stats=true.

Output directory: /Users/morsak/Documents/Work/verification/formal_verification/quint/strimzi/_apalache-out/server/2025-04-29T15-28-38_2180580086208009508
# APALACHE version: 0.47.2 | build: def5e8e                       I@15:28:38.801
Starting server on port 8822...                                   I@15:28:38.805
The Apalache server is running on port 8822. Press Ctrl-C to stop.
PASS #0: SanyParser                                               I@15:28:39.830
--------------------------- MODULE UserOperatorModel ---------------------------

EXTENDS Integers, Sequences, FiniteSets, TLC, Apalache, Variants

VARIABLE
  (*
    @type: { aclsEnabled: Bool, maxProcessedEvents: Int, potentialUsers: Set(Str) };
  *)
  parameters

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
  @type: (({ optional: Bool, secretKey: Str, secretName: Str }) => NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }));
*)
ScramSha512Authentication(__ScramSha512AuthenticationParam_17) ==
  Variant("ScramSha512Authentication", __ScramSha512AuthenticationParam_17)

(*
  @type: (({ enabled: Bool }) => NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }));
*)
TlsAuthentication(__TlsAuthenticationParam_23) ==
  Variant("TlsAuthentication", __TlsAuthenticationParam_23)

(*
  @type: ((NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool })) => Bool);
*)
requiresSecret(auth_247) ==
  CASE VariantTag(auth_247) = "ScramSha512Authentication"
      -> LET (*
        @type: (({ optional: Bool, secretKey: Str, secretName: Str }) => Bool);
      *)
      __QUINT_LAMBDA0(id__239) == TRUE
      IN
      __QUINT_LAMBDA0(VariantGetUnsafe("ScramSha512Authentication", auth_247))
    [] VariantTag(auth_247) = "TlsAuthentication"
      -> LET (*
        @type: (({ enabled: Bool }) => Bool);
      *)
      __QUINT_LAMBDA1(id__242) == TRUE
      IN
      __QUINT_LAMBDA1(VariantGetUnsafe("TlsAuthentication", auth_247))
    [] VariantTag(auth_247) = "NoneAuthentication"
      -> LET (*
        @type: (({ tag: Str }) => Bool);
      *)
      __QUINT_LAMBDA2(id__245) == FALSE
      IN
      __QUINT_LAMBDA2(VariantGetUnsafe("NoneAuthentication", auth_247))

(*
  @type: (() => NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }));
*)
NoneAuthentication == Variant("NoneAuthentication", [tag |-> "UNIT"])

(*
  @type: ((Bool) => { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int });
*)
makeQuotas(quotasEnabled_315) ==
  IF quotasEnabled_315 = TRUE
  THEN [producerByteRate |-> 100,
    consumerByteRate |-> 200,
    requestPercentage |-> 50,
    controllerMutationRate |-> 5]
  ELSE [producerByteRate |-> 0,
    consumerByteRate |-> 0,
    requestPercentage |-> 0,
    controllerMutationRate |-> 0]

(*
  @type: (() => cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }));
*)
topic == Variant("topic", [tag |-> "UNIT"])

(*
  @type: (() => cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }));
*)
group == Variant("group", [tag |-> "UNIT"])

(*
  @type: (() => cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }));
*)
cluster == Variant("cluster", [tag |-> "UNIT"])

(*
  @type: (() => cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }));
*)
transactionalId == Variant("transactionalId", [tag |-> "UNIT"])

(*
  @type: (() => literal({ tag: Str }) | prefix({ tag: Str }));
*)
literal == Variant("literal", [tag |-> "UNIT"])

(*
  @type: (() => literal({ tag: Str }) | prefix({ tag: Str }));
*)
prefix == Variant("prefix", [tag |-> "UNIT"])

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
  @type: (() => All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }));
*)
Describe == Variant("Describe", [tag |-> "UNIT"])

(*
  @type: (({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) => UserCreatedWithSecret({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }));
*)
UserCreatedWithSecret(__UserCreatedWithSecretParam_167) ==
  Variant("UserCreatedWithSecret", __UserCreatedWithSecretParam_167)

(*
  @type: (({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) => UserCreatedWithSecret({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }));
*)
UserUpdated(__UserUpdatedParam_173) ==
  Variant("UserUpdated", __UserUpdatedParam_173)

(*
  @type: ((Str) => UserCreatedWithSecret({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }));
*)
UserDeleted(__UserDeletedParam_179) ==
  Variant("UserDeleted", __UserDeletedParam_179)

VARIABLE
  (*
    @type: { eventQueue: Seq(UserCreatedWithSecret({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })), processedEvents: Int, secrets: Set(Str), users: (Str -> { metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) };
  *)
  globalState

(*
  @type: ((Str, Str) => NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }));
*)
makeAuth(u_288, authType_288) ==
  IF authType_288 = "scram-sha-512"
  THEN ScramSha512Authentication([secretName |-> u_288,
    secretKey |-> "my-password",
    optional |-> FALSE])
  ELSE IF authType_288 = "tls"
  THEN TlsAuthentication([enabled |-> TRUE])
  ELSE NoneAuthentication

(*
  @type: (() => Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }));
*)
makeAcl ==
  {[resource |-> [name |-> "*", typeAcl |-> topic, patternType |-> literal],
    operation |-> Read,
    host |-> "*",
    kind |-> "allow"]}

(*
  @type: (({ eventQueue: Seq(UserCreatedWithSecret({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })), processedEvents: Int, secrets: Set(Str), users: (Str -> { metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) }) => Bool);
*)
isStable(state_1598) ==
  \A u_1596 \in parameters["potentialUsers"]:
    (~(u_1596 \in DOMAIN (state_1598["users"]))
        \/ state_1598["users"][u_1596]["status"]["conditions"]["status"]
          = "Ready")
      \/ state_1598["users"][u_1596]["status"]["conditions"]["status"]
        = "Deleted"

(*
  @type: (() => Bool);
*)
UserConsistency ==
  \A u_1016 \in DOMAIN (globalState["users"]):
    (globalState["users"][u_1016]["status"]["conditions"]["status"] = "Ready"
        => ~(requiresSecret(globalState["users"][u_1016]["spec"][
            "authentication"
          ]))
          \/ u_1016 \in globalState["secrets"])
      /\ (globalState["users"][u_1016]["status"]["conditions"]["status"]
        = "Deleted"
        => ~(u_1016 \in globalState["secrets"]))

(*
  @type: (() => Bool);
*)
SecretsConsistency ==
  \A u_1054 \in DOMAIN (globalState["users"]):
    requiresSecret(globalState["users"][u_1054]["spec"]["authentication"])
      /\ globalState["users"][u_1054]["status"]["conditions"]["status"]
        = "Ready"
      => u_1054 \in globalState["secrets"]

(*
  @type: (() => Bool);
*)
NoSecretsForDeletedUsers ==
  \A u_1082 \in DOMAIN (globalState["users"]):
    globalState["users"][u_1082]["status"]["conditions"]["status"] = "Deleted"
      => ~(u_1082 \in globalState["secrets"])

(*
  @type: (() => Bool);
*)
ReadyUsersMustHaveSecrets ==
  \A u_1121 \in DOMAIN (globalState["users"]):
    globalState["users"][u_1121]["status"]["conditions"]["status"] = "Ready"
      => ~(requiresSecret(globalState["users"][u_1121]["spec"]["authentication"]))
        \/ u_1121 \in globalState["secrets"]

(*
  @type: (() => Bool);
*)
EventQueueWellFormed ==
  Len(LET (*
    @type: ((Seq(UserCreatedWithSecret({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })), UserCreatedWithSecret({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })) => Seq(UserCreatedWithSecret({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })));
  *)
  __QUINT_LAMBDA8(__quint_var0, __QUINT_LAMBDA7) ==
    IF LET (*
      @type: ((UserCreatedWithSecret({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })) => Bool);
    *)
    __QUINT_LAMBDA6(ev_1162) ==
      CASE VariantTag(ev_1162) = "UserCreatedWithSecret"
          -> LET (*
            @type: (({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) => Bool);
          *)
          __QUINT_LAMBDA3(cr_1154) ==
            cr_1154["metadata"]["name"] \in parameters["potentialUsers"]
          IN
          __QUINT_LAMBDA3(VariantGetUnsafe("UserCreatedWithSecret", ev_1162))
        [] VariantTag(ev_1162) = "UserUpdated"
          -> LET (*
            @type: (({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) => Bool);
          *)
          __QUINT_LAMBDA4(cr_1157) ==
            cr_1157["metadata"]["name"] \in parameters["potentialUsers"]
          IN
          __QUINT_LAMBDA4(VariantGetUnsafe("UserUpdated", ev_1162))
        [] VariantTag(ev_1162) = "UserDeleted"
          -> LET (*
            @type: ((Str) => Bool);
          *)
          __QUINT_LAMBDA5(u_1160) == u_1160 \in parameters["potentialUsers"]
          IN
          __QUINT_LAMBDA5(VariantGetUnsafe("UserDeleted", ev_1162))
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
  \A u_1231 \in DOMAIN (globalState["users"]):
    ((globalState["users"][u_1231]["spec"]["quotas"]["producerByteRate"] >= 0
          /\ globalState["users"][u_1231]["spec"]["quotas"]["consumerByteRate"]
            >= 0)
        /\ globalState["users"][u_1231]["spec"]["quotas"]["requestPercentage"]
          >= 0)
      /\ globalState["users"][u_1231]["spec"]["quotas"][
        "controllerMutationRate"
      ]
        >= 0

(*
  @type: (() => Bool);
*)
QuotasRequestPercentageValid ==
  \A u_1266 \in DOMAIN (globalState["users"]):
    globalState["users"][u_1266]["spec"]["quotas"]["requestPercentage"] >= 0
      /\ globalState["users"][u_1266]["spec"]["quotas"]["requestPercentage"]
        <= 100

(*
  @type: (() => Bool);
*)
ReadyUsersQuotasValid ==
  \A u_1357 \in DOMAIN (globalState["users"]):
    globalState["users"][u_1357]["status"]["conditions"]["status"] = "Ready"
      => (((globalState["users"][u_1357]["spec"]["quotas"]["producerByteRate"]
                >= 0
              /\ globalState["users"][u_1357]["spec"]["quotas"][
                "consumerByteRate"
              ]
                >= 0)
            /\ globalState["users"][u_1357]["spec"]["quotas"][
              "requestPercentage"
            ]
              >= 0)
          /\ globalState["users"][u_1357]["spec"]["quotas"]["requestPercentage"]
            <= 100)
        /\ globalState["users"][u_1357]["spec"]["quotas"][
          "controllerMutationRate"
        ]
          >= 0

(*
  @type: (() => Bool);
*)
AuthenticationPresent ==
  \A u_1387 \in DOMAIN (globalState["users"]):
    CASE VariantTag(globalState["users"][u_1387]["spec"]["authentication"])
        = "ScramSha512Authentication"
        -> LET (*
          @type: (({ optional: Bool, secretKey: Str, secretName: Str }) => Bool);
        *)
        __QUINT_LAMBDA9(id__1379) == TRUE
        IN
        __QUINT_LAMBDA9(VariantGetUnsafe("ScramSha512Authentication", globalState[
          "users"
        ][
          u_1387
        ][
          "spec"
        ][
          "authentication"
        ]))
      [] VariantTag(globalState["users"][u_1387]["spec"]["authentication"])
        = "TlsAuthentication"
        -> LET (*
          @type: (({ enabled: Bool }) => Bool);
        *)
        __QUINT_LAMBDA10(id__1382) == TRUE
        IN
        __QUINT_LAMBDA10(VariantGetUnsafe("TlsAuthentication", globalState[
          "users"
        ][
          u_1387
        ][
          "spec"
        ][
          "authentication"
        ]))
      [] VariantTag(globalState["users"][u_1387]["spec"]["authentication"])
        = "NoneAuthentication"
        -> LET (*
          @type: (({ tag: Str }) => Bool);
        *)
        __QUINT_LAMBDA11(id__1385) == TRUE
        IN
        __QUINT_LAMBDA11(VariantGetUnsafe("NoneAuthentication", globalState[
          "users"
        ][
          u_1387
        ][
          "spec"
        ][
          "authentication"
        ]))

(*
  @type: (() => Bool);
*)
ACLsExistForAuthorizedUsers ==
  \A u_1442 \in DOMAIN (globalState["users"]):
    globalState["users"][u_1442]["spec"]["authorization"]["typeAuthz"]
      = "simple"
      => (\A rule_1439 \in globalState["users"][u_1442]["spec"]["authorization"][
        "acls"
      ]:
        (rule_1439["resource"]["name"] /= "" /\ rule_1439["host"] /= "")
          /\ rule_1439["kind"] = "allow")

(*
  @type: (() => Bool);
*)
NoACLsForDeletedUsers ==
  \A u_1477 \in DOMAIN (globalState["users"]):
    globalState["users"][u_1477]["status"]["conditions"]["status"] = "Deleted"
      => globalState["users"][u_1477]["spec"]["authorization"]["acls"] = {}

(*
  @type: (() => Bool);
*)
ReadyUsersMustHaveACLs ==
  \A u_1527 \in DOMAIN (globalState["users"]):
    globalState["users"][u_1527]["status"]["conditions"]["status"] = "Ready"
      /\ globalState["users"][u_1527]["spec"]["authorization"]["typeAuthz"]
        = "simple"
      => Cardinality(globalState["users"][u_1527]["spec"]["authorization"][
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
          maxProcessedEvents |-> 5])
    /\ globalState
      = [users |-> SetAsFun({}),
        secrets |-> {},
        eventQueue |-> <<>>,
        processedEvents |-> 0]

(*
  @type: ((UserCreatedWithSecret({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })) => { eventQueue: Seq(UserCreatedWithSecret({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })), processedEvents: Int, secrets: Set(Str), users: (Str -> { metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) });
*)
queueEvent(ev_260) ==
  [
    globalState EXCEPT
      !["eventQueue"] = Append(globalState["eventQueue"], ev_260)
  ]

(*
  @type: (({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }, UserCreatedWithSecret({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })) => { metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } });
*)
reconcileUser(user_630, ev_630) ==
  CASE VariantTag(ev_630) = "UserCreatedWithSecret"
      -> LET (*
        @type: (({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) => { metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } });
      *)
      __QUINT_LAMBDA12(cr_622) ==
        [metadata |-> cr_622["metadata"],
          spec |-> cr_622["spec"],
          status |-> [conditions |-> [status |-> "Ready"]]]
      IN
      __QUINT_LAMBDA12(VariantGetUnsafe("UserCreatedWithSecret", ev_630))
    [] VariantTag(ev_630) = "UserUpdated"
      -> LET (*
        @type: (({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) => { metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } });
      *)
      __QUINT_LAMBDA13(cr_625) ==
        IF user_630["status"]["conditions"]["status"] = "Deleted"
        THEN user_630
        ELSE [metadata |-> cr_625["metadata"],
          spec |-> cr_625["spec"],
          status |->
            [conditions |->
                [status |->
                    IF requiresSecret(cr_625["spec"]["authentication"])
                    THEN IF cr_625["metadata"]["name"]
                      \in globalState["secrets"]
                    THEN "Ready"
                    ELSE "Pending"
                    ELSE "Ready"]]]
      IN
      __QUINT_LAMBDA13(VariantGetUnsafe("UserUpdated", ev_630))
    [] VariantTag(ev_630) = "UserDeleted"
      -> LET (*
        @type: ((Str) => { metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } });
      *)
      __QUINT_LAMBDA14(username_628) ==
        [metadata |-> user_630["metadata"],
          spec |->
            [
              user_630["spec"] EXCEPT
                !["authorization"] = [typeAuthz |-> "disabled", acls |-> {}]
            ],
          status |-> [conditions |-> [status |-> "Deleted"]]]
      IN
      __QUINT_LAMBDA14(VariantGetUnsafe("UserDeleted", ev_630))

(*
  @type: ((Bool) => { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str });
*)
makeAuthz(enable_351) ==
  IF enable_351
  THEN [typeAuthz |-> "simple", acls |-> makeAcl]
  ELSE [typeAuthz |-> "disabled", acls |-> {}]

(*
  @type: (() => Bool);
*)
AllInvariantsHold ==
  ((((((((((UserConsistency /\ SecretsConsistency) /\ NoSecretsForDeletedUsers)
                    /\ ReadyUsersMustHaveSecrets)
                  /\ EventQueueWellFormed)
                /\ QuotasNonNegative)
              /\ QuotasRequestPercentageValid)
            /\ ReadyUsersQuotasValid)
          /\ AuthenticationPresent)
        /\ ACLsExistForAuthorizedUsers)
      /\ NoACLsForDeletedUsers)
    /\ ReadyUsersMustHaveACLs

(*
  @type: ((Str) => Bool);
*)
deleteUser(u_448) ==
  (IF u_448 \in DOMAIN (globalState["users"])
    THEN globalState' := (queueEvent((UserDeleted(u_448))))
    ELSE globalState' := globalState)

(*
  @type: (({ eventQueue: Seq(UserCreatedWithSecret({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })), processedEvents: Int, secrets: Set(Str), users: (Str -> { metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) }, UserCreatedWithSecret({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })) => { eventQueue: Seq(UserCreatedWithSecret({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })), processedEvents: Int, secrets: Set(Str), users: (Str -> { metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) });
*)
processEvent(state_957, ev_957) ==
  CASE VariantTag(ev_957) = "UserCreatedWithSecret"
      -> LET (*
        @type: (({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) => { eventQueue: Seq(UserCreatedWithSecret({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })), processedEvents: Int, secrets: Set(Str), users: (Str -> { metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) });
      *)
      __QUINT_LAMBDA15(cr_949) ==
        IF cr_949["metadata"]["name"] \in DOMAIN (state_957["users"])
        THEN [users |->
            LET (*
              @type: (() => (Str -> { metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }));
            *)
            __quint_var1 == state_957["users"]
            IN
            LET (*
              @type: (() => Set(Str));
            *)
            __quint_var2 == DOMAIN __quint_var1
            IN
            [
              __quint_var3 \in {cr_949["metadata"]["name"]} \union __quint_var2 |->
                IF __quint_var3 = cr_949["metadata"]["name"]
                THEN reconcileUser(state_957["users"][
                  cr_949["metadata"]["name"]
                ], ev_957)
                ELSE (__quint_var1)[__quint_var3]
            ],
          secrets |->
            IF requiresSecret(cr_949["spec"]["authentication"])
            THEN state_957["secrets"] \union {cr_949["metadata"]["name"]}
            ELSE state_957["secrets"],
          eventQueue |-> state_957["eventQueue"],
          processedEvents |-> state_957["processedEvents"] + 1]
        ELSE [users |->
            LET (*
              @type: (() => (Str -> { metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }));
            *)
            __quint_var4 == state_957["users"]
            IN
            LET (*
              @type: (() => Set(Str));
            *)
            __quint_var5 == DOMAIN __quint_var4
            IN
            [
              __quint_var6 \in {cr_949["metadata"]["name"]} \union __quint_var5 |->
                IF __quint_var6 = cr_949["metadata"]["name"]
                THEN [metadata |-> cr_949["metadata"],
                  spec |-> cr_949["spec"],
                  status |-> [conditions |-> [status |-> "Ready"]]]
                ELSE (__quint_var4)[__quint_var6]
            ],
          secrets |->
            IF requiresSecret(cr_949["spec"]["authentication"])
            THEN state_957["secrets"] \union {cr_949["metadata"]["name"]}
            ELSE state_957["secrets"],
          eventQueue |-> state_957["eventQueue"],
          processedEvents |-> state_957["processedEvents"] + 1]
      IN
      __QUINT_LAMBDA15(VariantGetUnsafe("UserCreatedWithSecret", ev_957))
    [] VariantTag(ev_957) = "UserUpdated"
      -> LET (*
        @type: (({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) => { eventQueue: Seq(UserCreatedWithSecret({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })), processedEvents: Int, secrets: Set(Str), users: (Str -> { metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) });
      *)
      __QUINT_LAMBDA16(cr_952) ==
        IF cr_952["metadata"]["name"] \in DOMAIN (state_957["users"])
        THEN [users |->
            LET (*
              @type: (() => (Str -> { metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }));
            *)
            __quint_var7 == state_957["users"]
            IN
            LET (*
              @type: (() => Set(Str));
            *)
            __quint_var8 == DOMAIN __quint_var7
            IN
            [
              __quint_var9 \in {cr_952["metadata"]["name"]} \union __quint_var8 |->
                IF __quint_var9 = cr_952["metadata"]["name"]
                THEN reconcileUser(state_957["users"][
                  cr_952["metadata"]["name"]
                ], ev_957)
                ELSE (__quint_var7)[__quint_var9]
            ],
          secrets |->
            IF state_957["users"][cr_952["metadata"]["name"]]["status"][
              "conditions"
            ][
              "status"
            ]
              = "Deleted"
            THEN state_957["secrets"]
            ELSE IF requiresSecret(cr_952["spec"]["authentication"])
            THEN state_957["secrets"] \union {cr_952["metadata"]["name"]}
            ELSE state_957["secrets"] \ {cr_952["metadata"]["name"]},
          eventQueue |-> state_957["eventQueue"],
          processedEvents |-> state_957["processedEvents"] + 1]
        ELSE [users |->
            LET (*
              @type: (() => (Str -> { metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }));
            *)
            __quint_var10 == state_957["users"]
            IN
            LET (*
              @type: (() => Set(Str));
            *)
            __quint_var11 == DOMAIN __quint_var10
            IN
            [
              __quint_var12 \in
                {cr_952["metadata"]["name"]} \union __quint_var11 |->
                IF __quint_var12 = cr_952["metadata"]["name"]
                THEN [metadata |-> cr_952["metadata"],
                  spec |-> cr_952["spec"],
                  status |-> [conditions |-> [status |-> "Ready"]]]
                ELSE (__quint_var10)[__quint_var12]
            ],
          secrets |->
            IF requiresSecret(cr_952["spec"]["authentication"])
            THEN state_957["secrets"] \union {cr_952["metadata"]["name"]}
            ELSE state_957["secrets"],
          eventQueue |-> state_957["eventQueue"],
          processedEvents |-> state_957["processedEvents"] + 1]
      IN
      __QUINT_LAMBDA16(VariantGetUnsafe("UserUpdated", ev_957))
    [] VariantTag(ev_957) = "UserDeleted"
      -> LET (*
        @type: ((Str) => { eventQueue: Seq(UserCreatedWithSecret({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) | UserDeleted(Str) | UserUpdated({ metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } })), processedEvents: Int, secrets: Set(Str), users: (Str -> { metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }) });
      *)
      __QUINT_LAMBDA17(username_955) ==
        IF username_955 \in DOMAIN (state_957["users"])
        THEN [users |->
            LET (*
              @type: (() => (Str -> { metadata: { name: Str }, spec: { authentication: NoneAuthentication({ tag: Str }) | ScramSha512Authentication({ optional: Bool, secretKey: Str, secretName: Str }) | TlsAuthentication({ enabled: Bool }), authorization: { acls: Set({ host: Str, kind: Str, operation: All({ tag: Str }) | Alter({ tag: Str }) | AlterConfigs({ tag: Str }) | ClusterAction({ tag: Str }) | Create({ tag: Str }) | Delete({ tag: Str }) | Describe({ tag: Str }) | DescribeConfigs({ tag: Str }) | IdempotentWrite({ tag: Str }) | Read({ tag: Str }) | Write({ tag: Str }), resource: { name: Str, patternType: literal({ tag: Str }) | prefix({ tag: Str }), typeAcl: cluster({ tag: Str }) | group({ tag: Str }) | topic({ tag: Str }) | transactionalId({ tag: Str }) } }), typeAuthz: Str }, quotas: { consumerByteRate: Int, controllerMutationRate: Int, producerByteRate: Int, requestPercentage: Int } }, status: { conditions: { status: Str } } }));
            *)
            __quint_var13 == state_957["users"]
            IN
            LET (*
              @type: (() => Set(Str));
            *)
            __quint_var14 == DOMAIN __quint_var13
            IN
            [
              __quint_var15 \in {username_955} \union __quint_var14 |->
                IF __quint_var15 = username_955
                THEN reconcileUser(state_957["users"][username_955], ev_957)
                ELSE (__quint_var13)[__quint_var15]
            ],
          secrets |-> state_957["secrets"] \ {username_955},
          eventQueue |-> state_957["eventQueue"],
          processedEvents |-> state_957["processedEvents"] + 1]
        ELSE state_957
      IN
      __QUINT_LAMBDA17(VariantGetUnsafe("UserDeleted", ev_957))

(*
  @type: (() => Bool);
*)
q_init == init

(*
  @type: ((Str, Str, Bool, Bool) => Bool);
*)
createUser(u_385, authType_385, quotasEnabled_385, aclsEnabled_385) ==
  globalState'
      := (queueEvent((UserCreatedWithSecret([metadata |-> [name |-> u_385],
        spec |->
          [authentication |-> makeAuth(u_385, authType_385),
            authorization |-> makeAuthz(aclsEnabled_385),
            quotas |-> makeQuotas(quotasEnabled_385)],
        status |-> [conditions |-> [status |-> "Pending"]]]))))

(*
  @type: ((Str, Str, Bool, Bool) => Bool);
*)
updateUser(u_429, authType_429, quotasEnabled_429, aclsEnabled_429) ==
  (IF u_429 \in DOMAIN (globalState["users"])
    THEN globalState'
      := (queueEvent((UserUpdated([metadata |-> [name |-> u_429],
        spec |->
          [authentication |-> makeAuth(u_429, authType_429),
            authorization |-> makeAuthz(aclsEnabled_429),
            quotas |-> makeQuotas(quotasEnabled_429)],
        status |-> [conditions |-> [status |-> "Pending"]]]))))
    ELSE globalState' := globalState)

(*
  @type: (() => Bool);
*)
processNextEvent ==
  (IF Len(globalState["eventQueue"]) > 0
    THEN globalState'
      := (processEvent([
        globalState EXCEPT
          !["eventQueue"] = Tail(globalState["eventQueue"])
      ], (Head(globalState["eventQueue"]))))
    ELSE globalState' := globalState)

(*
  @type: (() => Bool);
*)
step ==
  (\E u \in parameters["potentialUsers"]:
      \E authType \in { "scram-sha-512", "tls", "none" }:
        \E quotasEnabled \in { TRUE, FALSE }:
          IF globalState["processedEvents"] + Len(globalState["eventQueue"])
            < parameters["maxProcessedEvents"]
          THEN createUser(u, authType, quotasEnabled, parameters["aclsEnabled"])
            \/ updateUser(u, authType, quotasEnabled, parameters["aclsEnabled"])
            \/ deleteUser(u)
            \/ processNextEvent
          ELSE processNextEvent)
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
