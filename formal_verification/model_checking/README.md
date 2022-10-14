# What is Model checking?

Brief overview [here](https://www.cs.cmu.edu/~aldrich/courses/654-sp05/handouts/model-checking-3.pdf). 

TL;DR 
> Model checking is an influential method to verify complex interactions, concurrent and distributed systems.

```mermaid
flowchart LR
X[Design Model from program code]
X --> B(Formal property using temporal logic)
X --> L(Formal Model in e.g., TLA+)
B(Formal property using temporal logic) --> M
L --> M
M[Model checker e.g., TLC] --> N{exhaustive state exploration}
N --> Y[Pproperty is satisfied]
N --> Q[Property is not satisfied and we have specific error path i.e., counterexample]
N --> P[Out of memory or timeout]
```

# Formal specification language

One of the formal specification languages is **TLA+**. 
You could find additional information in these links ([lamport-tla](https://lamport.azurewebsites.net/tla/tla.html), [learn-tla](https://learntla.com/)).