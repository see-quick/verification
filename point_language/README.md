# Point language

Point language is beneficial for newcomers to static analysis. 
It expresses a lot in a very easy way on 2D coordinates. One can
imagine a state of computer as:
1. description of memory contents (i.e., heap, stack)
2. registers
3. program counter

But in point language we want to make sure that this state is as simple as 
possible. 
Therefore, we define our very first language based on sub-set of 2D geometrics. 
State in such language represents point in 2D region (e.g., (1, 2) is instance of point where x equals to 1 and y equals to 02).
Graphically:
```aidl
         y ^
          2|    (p)
           |
           |
           |
     ------|-----|---> x
           0     1  
```

We define following language by context-free grammar:

```shell
::= 
    init(R) |               (initialization with a state in R)
    translation(u, v) |     (translation of vector (u, v))
    rotation(u, v, 𝛿) |     (rotation defined by center (u ,v) and angle 𝛿)
    p;p |                   (sequence of operations)
    {p}or{p} |              (choice - non-deterministic)
    iter{p}                 (iteration - number of iteration is non-deterministic)
```

Example of program could be for instance:

1. Example
```aidl
init([0, 2] x [0, 2])
rotation(0, 0, 180°)
iter {
    translation(0, 1)
}
```
2. Example
```aidl
init([0, 2] x [0, 2])
iter {
    {
        translation(1, 0)
    }or{
        translation(0, 1)
    }
}
```

In such language, we could analyze safety property (e.g., point never enters the negative x axis). 
In other words this can be defined as `P = {(x, y) | x < 0}`. 
If we find such execution of program, then that's an incorrect execution and we find bug.
We would also want that such analysis has to be SOUND. 
Meaning also produce correct results (i.e., if it returns TRUE, when applied to an input program p, we except to have the guarantee
that no execution of program will ever reach P). 
Straightforward way how to perform such check is to enumerate all paths (i.e., executions of the programs).
Unfortunately this is not feasible even for small programs because:
1. **the initial states** are infinite
2. **the length of execution** is infinite (because of non-deterministic iter command)
3. **the set of possible series of non-deterministic choices** (i.e., or command) is infinite

and that is why we need to introduce some form of **abstraction**.
