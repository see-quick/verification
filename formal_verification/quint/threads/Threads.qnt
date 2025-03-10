module Threads {

  import ThreadsN(NUM_THREADS=10).*
}

module ThreadsN {
    
    const NUM_THREADS: int
    assume nonEmpty = NUM_THREADS >= 1

    var x: List[int]
    var y: List[int]
    
    var pendingThreads: Set[int]
  
    action init = all {
        x' = zeroes(NUM_THREADS),
        y' = zeroes(NUM_THREADS),
        pendingThreads' = 0.to(NUM_THREADS-1),
    }
    
    action step = {
        if (termination) {
            allStopped
        } else {    
            processUpdate
        }
    }

    action processUpdate = {
        nondet proc = pendingThreads.oneOf()

        val nextX = x.replaceAt(proc, 1)
        val index = circularIndex(proc, NUM_THREADS)
        val yValue = nextX[index]

        all {
            x' = nextX,
            y' = y.replaceAt(proc, yValue),
            pendingThreads' = pendingThreads.exclude(Set(proc)),
        }
    }

    action allStopped = all {
        x' = x,
        y' = y,
        pendingThreads' = pendingThreads,
    }

    pure def zeroes(len: int): List[int] = {
        0.to(len-1).fold(List(), (l, _) => l.append(0))
    }

    pure def circularIndex(i: int, N: int): int = {
        if (i == 0) {
            N-1
        } else {
            i-1
        }
    }

    val termination = {
        pendingThreads.size() == 0
    }
}

