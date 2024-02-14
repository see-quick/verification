# Test Strategy for Unidirectional Topic Operator (UTO) Performance and Scalability

[//]: # (Version: 2)
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
- **Objective**: To evaluate the UTO's efficiency in bulk handling of topic events.
- **Description**: Focuses on Alice managing a Kafka cluster to perform bulk topic events, emphasizing minimizing latency and ensuring system stability.
- **Preconditions**: A Kafka cluster with the UTO deployed and tools for bulk topic event handling.
- **Test Steps**:
    * Perform bulk operations for topic events.
    * Measure latency and throughput, focusing on minimizing processing time.
- **Expected Results**: Efficient bulk processing of topic events with minimal latency and maintained system stability.

### ii) Test Case: Bob’s Data Streaming Scenario for UTO
- **Objective**: To assess the UTO's performance in handling topic events in a high-volume environment.
- **Description**: Simulates a production environment with Bob overseeing a Kafka cluster, focusing on the UTO's ability to manage topic events efficiently.
- **Preconditions**: A Kafka cluster with the UTO deployed for a production-like environment.
- **Test Steps**:
    * Simulate a stable production load with periodic topic events.
    * Measure throughput and latency for topic event handling.
- **Expected Results**: UTO manages topic events without impacting Kafka cluster stability and performance.

### iii) Test Case: Carol’s Development Cluster Scenario for UTO
- **Objective**: To assess the UTO’s performance with frequent topic modifications.
- **Description**: Carol oversees a Kafka environment with frequent topic events, requiring minimal latency in processing.
- **Preconditions**: A Kafka cluster with the UTO, tools for dynamic topic event handling.
- **Test Steps**:
    * Simulate frequent topic events (create, modify, delete).
    * Measure latency and throughput for these events.
- **Expected Results**: The UTO efficiently handles frequent topic events with minimal latency, maintaining system stability.

**Operation Frequency Definitions:**
- **Medium Frequency**: Operations that occur at a rate of 200 to 400 events/sec.
- **High Frequency**: Operations that occur at a rate of 401 to 600 events/sec.
- **Very High Frequency**: Operations that exceed 600 events/sec.

| Experiment # | Operation Frequency | Batch Size | Linger Time (ms) | Topics Modified | Throughput (events/sec) | Latency (ms) | CPU Utilization (%) | Memory Utilization (%) | Experiment Notes                                         |
|--------------|---------------------|------------|------------------|-----------------|-------------------------|--------------|---------------------|------------------------|----------------------------------------------------------|
| 1            | High                | 50         | 100              | 50              | 450                     | TBD          | TBD                 | TBD                    | Reduced batch size, baseline linger time                 |
| 2            | High                | 150        | 100              | 50              | 550                     | TBD          | TBD                 | TBD                    | Increased batch size, baseline linger time               |
| 3            | Medium              | 100        | 50               | 50              | 350                     | TBD          | TBD                 | TBD                    | Baseline batch size, reduced linger time                 |
| 4            | Very High           | 50         | 50               | 50              | 650                     | TBD          | TBD                 | TBD                    | Reduced batch size, reduced linger time                  |
| 5            | Medium              | 150        | 150              | 50              | 300                     | TBD          | TBD                 | TBD                    | Increased batch size, increased linger time              |
| 6            | Very High           | 100        | 5                | 50              | 700                     | TBD          | TBD                 | TBD                    | Baseline batch size, significantly reduced linger time   |
| 7            | High                | 200        | 100              | 50              | 500                     | TBD          | TBD                 | TBD                    | Significantly increased batch size, baseline linger time |
| 8            | Medium              | 100        | 200              | 50              | 250                     | TBD          | TBD                 | TBD                    | Baseline batch size, increased linger time               |
| 9            | Very High           | 200        | 50               | 50              | 800                     | TBD          | TBD                 | TBD                    | Significantly increased batch size, reduced linger time  |
| 10           | High                | 100        | 150              | 50              | 480                     | TBD          | TBD                 | TBD                    | Baseline batch size, slightly increased linger time      |

**Note**: "TBD" in Latency, CPU Utilization, and Memory Utilization columns indicates that these values would be determined based on the actual test results, 
as they are dependent on the specific hardware, Kafka configuration, and UTO implementation details.

## 9. Test Execution Plan
- **Schedule:** Aim to execute each test case for at least one hour under continuous load to accurately measure performance over time.

## 10. Risks and Mitigation
- Specific to each test case, with general attention to avoiding system overload through careful monitoring and the implementation of safeguards.

## 11. Data Collection and Reporting
- Focus on automated and manual methods for collecting and analyzing data related to topic event handling performance.

## Appendix
- Could contain code snippets or references to the codebase and supporting documents or any additional information.
