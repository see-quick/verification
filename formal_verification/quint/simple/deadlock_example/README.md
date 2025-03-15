# Deadlock example with two processes 

## Command to run simulation

```bash
quint run DeadlockExample.qnt --invariant=DeadlockCondition --mbt  --verbosity=5
```

An example execution:
```requirements
[Frame 0]
q::initAndInvariant => true
└─ init => true

[State 0] { heldBy: (-1, -1), mbt::actionTaken: "init", mbt::nondetPicks: { p: None } }

[Frame 1]
q::stepAndInvariant => true
└─ step => true
   ├─ acquireR1(1) => (1, -1)
   ├─ acquireR2(1) => (-1, 1)
   ├─ releaseR1(1) => (-1, -1)
   └─ releaseR2(1) => (-1, -1)

[State 1] { heldBy: (1, -1), mbt::actionTaken: "init", mbt::nondetPicks: { p: Some(1) } }

[Frame 2]
q::stepAndInvariant => true
└─ step => true
   ├─ acquireR1(2) => (1, -1)
   ├─ acquireR2(2) => (1, 2)
   ├─ releaseR1(2) => (1, -1)
   └─ releaseR2(2) => (1, -1)

[State 2] { heldBy: (1, -1), mbt::actionTaken: "init", mbt::nondetPicks: { p: Some(2) } }

[Frame 3]
q::stepAndInvariant => false
└─ step => true
   ├─ acquireR1(2) => (1, -1)
   ├─ acquireR2(2) => (1, 2)
   ├─ releaseR1(2) => (1, -1)
   └─ releaseR2(2) => (1, -1)

[State 3] { heldBy: (1, 2), mbt::actionTaken: "init", mbt::nondetPicks: { p: Some(2) } }

[violation] Found an issue (5ms).
error: Invariant violated
```

## **Explanation:**

### **State Transitions and Deadlock Analysis**

---

### **State 0** → `{ heldBy: (-1, -1) }`
- No resources are held (initial state). ✅
- The system is in a valid starting condition.
- `DeadlockCondition` holds because deadlock has not yet occurred.

---

### **State 1** → `{ heldBy: (1, -1) }`
- **Process `P1` acquires `R1`**, but `R2` remains free.
- **Process `P2` has not yet acted.**
- No deadlock yet; system remains functional. ✅

---

### **State 2** → `{ heldBy: (1, -1) }`
- **Process `P2` attempts an action.**
- It **could** acquire `R2`, but instead picks a release action.
- The system remains in the same state. ✅

---

### **State 3** → `{ heldBy: (1, 2) }`
- **Process `P2` acquires `R2` while `P1` is still holding `R1`.**
- **Now, a deadlock occurs:**
	- `P1` **needs `R2` but can’t get it**.
	- `P2` **needs `R1` but can’t get it**.
- **No further actions can be taken**—both processes are **stuck indefinitely**. ❌

---

## **Violation Detected**
- **The invariant `not(deadlock)` fails.**
- **`quint` correctly detects the deadlock.**
- **Execution stops because the system is now irreversibly blocked.**

---

## **Summary**
1. **`P1` acquires `R1`.** ✅
2. **`P2` acquires `R2`.** ✅
3. **Both now wait for each other’s resource.** ❌
4. **Deadlock occurs.** 💀
5. **`quint` correctly flags an invariant violation.** 🚨  
