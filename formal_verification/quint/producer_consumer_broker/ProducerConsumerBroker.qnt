module ProducerConsumerBroker {
  // The queue (broker) that stores produced messages
  var queue: List[int]

  // Producer action: Adds a new message to the queue (bounded size)
  action produce = all {
    nondet msg = oneOf(1.to(100)), // Generate random message
    if (queue.length() < 10) {  // Queue size limit
      queue' = queue.append(msg)
    } else {
      queue' = queue  // No-op if full
    }
  }

  // Consumer action: Consumes (removes) a message from the queue
  action consume = all {
    if (queue.length() > 0) {
      queue' = queue.tail()  // Remove the first message
    } else {
      queue' = queue  // No-op if empty
    }
  }

  // Initial state: queue is empty
  action init = all {
    queue' = []
  }

  // Safety property: Queue size should never exceed 10
  val QueueBounded = always(queue.length() <= 10)

  // Liveness: If the queue is not empty, a consumer will eventually consume a message
  temporal EventuallyConsumed = always(queue.length() > 0).implies(eventually(queue.length() == 0))
}
