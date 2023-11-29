# Test Strategy for Unidirectional Topic Operator (UTO) Performance and Scalability

[//]: # (Version: 1)
[//]: # (Date: 29.11.2023)
[//]: # (Prepared by: Maroš Orsák)

## 1. Introduction

- **Purpose**: Outline the objectives and approach for testing the UTO in Kafka. 
- **Scope**: Define the boundaries of testing, including targeted use cases and metrics.

## 2. Test Objectives
- Evaluate the performance and scalability of UTO.
- Compare UTO performance with the BTO (if applicable).
- Identify optimal configuration settings for different use cases.
## 3. Test Items
- Unidirectional Topic Operator (UTO) in Kafka environments.
- Comparison with the Basic Topic Operator (BTO) (optional).
## 4. Test Criteria
- Success Criteria: Define what constitutes a successful test (e.g., meeting targeted throughput and latency metrics).
- Exit Criteria: Specify conditions for concluding the testing phase (e.g., all scenarios tested, no critical bugs remaining).
## 5. Test Approach
- Use Case Scenarios:
    * Alice’s Bulk Ingestion/Batch Use Case
    * Bob’s Data Streaming Use Case
    * Carol’s Development Cluster Use Case
- **Performance Metrics (important):**
    * **Throughput**: Number of KafkaTopic events processed per unit of time.
    * **Latency**: Time from KafkaTopic event receipt to processing completion.
    * **Resource** Utilization: CPU, Memory, and I/O monitoring.
    * **Error** Rates: Tracking errors and resource conflicts.
    * TODO: add some one? (e.g., time to reconcile)
## 6. Test Environment
- Hardware/Software Requirements:
    - Here I would like you to hear your input about infrastructures which correlates with each use case (i.e., Alice’s, Bob’s and Carol’s). 
         What do we need here? Is it enough to have 6-node cluster where each node has 16GB RAM and 8 CPU?
- Configuration Details: Describe the setup of the Kafka cluster and UTO configurations.
    - Also here It would be great to see some examples…
## 7. Test Tools
- List tools used for load testing, monitoring, and analysis (e.g., JMeter or Peper Box for load testing, Prometheus and Grafana for monitoring).
- I would firstly start with manual testing and then we could see if that’ s okay and start automating them and create some kind of reporting and gathering logs?
## 8. Test Cases

### i) Test Case: Alice’s Bulk Ingestion/Batch Scenario for UTO
- **Objective**: To assess the UTO’s efficiency and performance in handling bulk topic creation, parallel ingestion, and deletion in a Kafka environment.
- **Description**: This test case simulates a scenario where Alice needs to create hundreds of topics, perform parallel data ingestion, consume data from these topics simultaneously, and then delete all the topics. The primary focus is on minimizing latency during bulk create and delete operations and ensuring system stability under heavy load.
- **Preconditions**:
  * A Kafka cluster with the UTO deployed is available.
  * Necessary tools and scripts for creating topics, producing and consuming messages are set up.
  * Monitoring tools for tracking performance metrics are in place.
- **Test Steps**:
  1. Topic Creation:
      * Create a script to generate and execute requests for creating hundreds of topics in Kafka.
      * Ensure that these topic creation requests are made in a bulk operation.
  2. Data Ingestion:
      * Simulate data production to all created topics simultaneously. Use a script to send a large volume of messages to these topics.
  3. Data Consumption:
      * Simultaneously with the ingestion, start consuming messages from all the topics.
      * Ensure the consumption process is parallelized to mimic real-world batch processing.
  4. Topic Deletion:
      * After a specified period or once a certain amount of data is ingested and consumed, initiate the deletion of all topics.
      * Monitor the time taken and system behavior during this bulk deletion process.
  5. Monitoring and Data Collection:
      * Throughout the test, monitor and record relevant metrics such as throughput, latency, resource utilization (CPU, memory, I/O), and error rates.
      * Pay special attention to the latency during the bulk creation and deletion of topics.
        Expected Results:
     * Topics are created, and data is ingested and consumed as expected without significant delays.
     * The system maintains stability and performance throughout the test.
     * Latency for bulk operations (creation and deletion) is within acceptable limits.
     * Resource utilization stays within expected thresholds, indicating no bottlenecks.
       Post-Conditions:
     * All test topics are successfully deleted.
     * System returns to normal operational status.
- **Variations**:
  * Vary the number of topics and the volume of data to test system limits.
  * Adjust batch size and linger time to evaluate their impact on performance.
- **Risks and Mitigation Strategies**:
  * System overload: Monitor resource utilization closely and have fallbacks or thresholds to prevent system crashes.

**Note:** that this table is just filled with random values. We could definitely extract or add some metrics, which we think would be great for our findings.

| Experiment # | Batch Size | Linger Time (s) | Topics Created | Throughput (msgs/sec) | Latency (ms) | CPU Utilization (%) | Memory Utilization (%) | Experiment Notes           |
|--------------|------------|-----------------|----------------|-----------------------|--------------|---------------------|------------------------|---------------------------|
| 1            | 50         | 30              | 500            | 10,000                | 120          | 70                  | 60                     | Initial setup             |
| 2            | 100        | 30              | 500            | 15,000                | 100          | 75                  | 65                     | Increased batch size      |
| 3            | 50         | 10              | 500            | 9,500                 | 90           | 72                  | 62                     | Reduced linger time       |
| 4            | 100        | 10              | 500            | 15,500                | 80           | 80                  | 68                     | Optimized for bulk ops    |
| 5            | 200        | 10              | 500            | 14,000                | 110          | 85                  | 70                     | Stressed system limits    |


### ii) Test Case: Bob’s Data Streaming Scenario for UTO

- **Objective:** To evaluate the UTO’s capability to manage a large number of topics in a stable production environment, focusing on performance during infrequent topic creation and deletion.
- **Description:** This test case simulates a production-like environment where Bob has a Kafka cluster with thousands of topics. The test will assess UTO's performance and scalability when handling small, infrequent changes in such a high-volume topic environment.
- **Preconditions:**
  * A Kafka cluster with the UTO deployed, configured for a production-like environment.
  * Tools and scripts for creating, deleting topics, and producing/consuming messages are ready.
  * Monitoring tools for performance metrics are set up.
- **Test Steps:**
  * Initial Topic Setup:
      * Create thousands of topics in the Kafka cluster to simulate a production environment. Use a script for bulk creation.
  * Simulate Production Load:
      * Continuously produce and consume messages on these topics to mimic ongoing data streaming.
  * Infrequent Topic Management:
      * Periodically, create or delete a small number of topics to simulate infrequent changes in the production environment.
      * Monitor the impact of these operations on overall cluster performance.
  * Monitoring and Data Collection:
      * Track and record key metrics like throughput (for existing topics), latency (particularly for the new topic creation/deletion), resource utilization, and error rates.
      * Observe the behavior of the UTO during the infrequent topic management operations.
  * Stability Assessment:
      * Evaluate the stability of the Kafka cluster and UTO during the entire testing period, especially during topic creation/deletion.
        Expected Results:
  * The UTO handles thousands of topics without significant performance degradation.
  * Infrequent topic creation/deletion operations do not significantly impact the overall performance and stability of the system.
  * Throughput and latency metrics meet predetermined benchmarks.
  * Resource utilization remains within expected ranges, indicating efficient handling of the workload.
- **Post-Conditions:**
  * The Kafka cluster remains stable and returns to normal operation after the test.
    Variations:
  * Vary the frequency and volume of topic creation/deletion to test different scenarios.
  * Test with different UTO configuration settings to find optimal parameters for such environments.
- **Risks and Mitigation Strategies**:
  * Potential impact on production traffic: Ensure fallback mechanisms and monitor closely to avoid disruptions.

| Experiment # | Topic Changes | Linger Time (s) | Total Topics | Throughput (msgs/sec) | Latency (ms) | CPU Utilization (%) | Memory Utilization (%) | Experiment Notes          |
|--------------|---------------|-----------------|--------------|-----------------------|--------------|---------------------|------------------------|---------------------------|
| 1            | 5             | 1               | 10,000       | 12,000                | 50           | 65                  | 55                     | Baseline setup            |
| 2            | 10            | 1               | 10,000       | 11,900                | 55           | 67                  | 56                     | More topic changes        |
| 3            | 5             | 5               | 10,000       | 12,100                | 45           | 64                  | 54                     | Increased linger time     |
| 4            | 20            | 1               | 10,000       | 11,800                | 60           | 70                  | 58                     | Testing limits of changes |
| 5            | 10            | 5               | 10,000       | 12,000                | 48           | 66                  | 55                     | Balanced approach         |

### iii) Test Case: Carol’s Development Cluster Scenario for UTO
- **Objective:** To assess the UTO’s performance in a development environment with frequent topic modifications, focusing on minimizing latency and ensuring quick responsiveness to changes.
- **Description:** This test case simulates a development cluster scenario where Carol oversees a Kafka environment used by dozens of application developers. The developers frequently create, modify, and delete topics as part of their development work, requiring the UTO to quickly process these changes with minimal latency.
- **Preconditions:**
  * A Kafka cluster with the UTO deployed, configured to mimic a development environment.
  * Tools and scripts for dynamic topic creation, modification, and deletion.
  * Monitoring tools for tracking performance metrics.
- **Test Steps:**
  * Dynamic Topic Management:
      * Simulate the behavior of application developers by frequently creating, modifying, and deleting topics in the Kafka cluster.
  * High-Frequency Operations:
      * Ensure that topic operations (create, modify, delete) are performed at a high frequency to replicate a real development environment.
  * Latency Measurement:
      * Measure the time taken from the initiation of a topic operation (create, modify, delete) to its completion by the UTO and Kafka.
      * Focus on keeping this latency as low as possible, ideally within tens of milliseconds.
  * Monitoring and Data Collection:
      * Continuously monitor and record key metrics such as throughput (for topic operations), latency, resource utilization, and error rates.
      * Pay particular attention to how quickly the UTO responds to frequent changes.
  * Load Testing:
      * Gradually increase the frequency and complexity of topic operations to assess the UTO’s behavior under increasing load.
        Expected Results:
  * The UTO efficiently handles frequent topic operations with minimal latency.
  * The system remains stable and responsive even under high-frequency changes.
  * Latency for processing each operation is within the targeted threshold.
  * Resource utilization does not spike unexpectedly, indicating efficient handling of dynamic changes.
- **Post-Conditions:**
  * The Kafka cluster and UTO return to a stable state with all temporary test topics cleaned up.
    Variations:
  * Vary the rate of topic operations to test the UTO's responsiveness under different load conditions.
  * Experiment with different UTO configurations to find the optimal setup for a development environment.
- **Risks and Mitigation Strategies:**
  * Risk of overloading the system: Implement safeguards and closely monitor system health to prevent crashes or significant slowdowns.

| Experiment # | Operation Frequency | Linger Time (ms) | Topics Modified | Throughput (ops/sec) | Latency (ms) | CPU Utilization (%) | Memory Utilization (%) | Experiment Notes            |
|--------------|---------------------|------------------|-----------------|----------------------|--------------|---------------------|------------------------|----------------------------|
| 1            | High                | 10               | 50              | 500                  | 30           | 60                  | 50                     | Baseline setup             |
| 2            | Very High           | 10               | 50              | 550                  | 25           | 65                  | 55                     | Increased frequency        |
| 3            | High                | 5                | 50              | 480                  | 20           | 62                  | 52                     | Reduced linger time        |
| 4            | Medium              | 10               | 50              | 450                  | 35           | 58                  | 48                     | Lowered frequency          |
| 5            | Very High           | 5                | 50              | 560                  | 18           | 68                  | 57                     | Optimized for rapid changes |

Notes on Interpreting and Using the Tables:
* **Variations:** Each experiment varies certain parameters (like batch size, linger time, frequency of operations) to test their impact on performance.
* **Measured Metrics:** The metrics provide insights into throughput, latency, system resource utilization, etc., under different conditions.
* **Optimal Configuration Selection:** After conducting these experiments, we can compare the results to identify the most effective configuration for each use case. The optimal setup would typically balance high throughput, low latency, and efficient resource utilization.

## 9. Test Execution Plan
- **Schedule:** For these test cases it would be great to see them working at least one hour of endless load
## 10. Risks and Mitigation
- None
## 11. Data Collection and Reporting
- As mentioned in 7 point (i.e., Test Tools), we could start with manual checking using Grafana dashboards and evaluate experiments on fly. Afterwards we could proceed with more automated way.

## Appendix
- could contain code snippets or references to that codebase
- supporting documents or any additional information


