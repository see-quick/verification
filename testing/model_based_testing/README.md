# Mutation Testing with Java: An Introduction Using a Calculator Example

## Table of Contents

- Introduction
- Why Use Mutation Testing?
- Prerequisites
- Example Code
- Calculator Class
- Unit Tests
- Setting Up Mutation Testing with PIT
- Adding PIT to Your Maven Project
- Running Mutation Tests
- Analyzing the Results
- Improving Tests Based on Mutation Testing
- Conclusion
- References

## Introduction

Mutation testing is a powerful technique to evaluate the effectiveness of your test suite. It works by introducing small changes (mutations) to your code and checking whether your tests can detect these changes. If a test fails due to a mutation, it has “killed” the mutant; if not, the mutant “survives,” indicating potential weaknesses in your test suite.

In this guide, we’ll explore mutation testing in Java using a simple Calculator class example. We’ll use PIT, a popular mutation testing tool for Java, to demonstrate how to set up and run mutation tests.

## Why Use Mutation Testing?

- Assess Test Quality: Mutation testing helps identify areas where your tests may not be adequately covering the code.
- Improve Code Reliability: By uncovering weaknesses in your test suite, you can write better tests, leading to more reliable and maintainable code.
- Complement Code Coverage: Unlike code coverage metrics that only indicate which lines of code were executed, mutation testing checks whether the tests can catch faults in the code.

### Prerequisites

- Java Development Kit (JDK): Ensure you have JDK 8 or higher installed.
- Maven: We’ll use Maven to manage project dependencies and build configurations.
- JUnit 5: Our unit tests will be written using JUnit 5.
- PIT Mutation Testing Tool: We’ll integrate PIT into our Maven project.

### Example Code

We’ll use a simple Calculator class that performs basic arithmetic operations and a corresponding set of unit tests.

Calculator Class
```java
// File: src/main/java/Calculator.java

public class Calculator {
public int add(int a, int b) {
return a + b;
}

    public int subtract(int a, int b) {
        return a - b;
    }
  
    public int multiply(int a, int b) {
        return a * b;
    }
  
    public int divide(int a, int b) {
        if (b == 0) {
            throw new IllegalArgumentException("Cannot divide by zero.");
        }
        return a / b;
    }
}
```

### Unit Tests

```java
// File: src/test/java/CalculatorTest.java

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertThrows;

import org.junit.Before;
import org.junit.Test;

public class CalculatorTest {
private Calculator calc;

    @Before
    public void setUp() {
        calc = new Calculator();
    }
  
    @Test
    public void testAdd() {
        assertEquals(5, calc.add(2, 3));
        assertEquals(-2, calc.add(-1, -1));
        assertEquals(0, calc.add(-1, 1));
    }
  
    @Test
    public void testSubtract() {
        assertEquals(5, calc.subtract(10, 5));
        assertEquals(0, calc.subtract(-1, -1));
        assertEquals(-2, calc.subtract(-1, 1));
    }
  
    @Test
    public void testMultiply() {
        assertEquals(20, calc.multiply(4, 5));
        assertEquals(4, calc.multiply(-2, -2));
        assertEquals(-4, calc.multiply(-2, 2));
    }
  
    @Test
    public void testDivide() {
        assertEquals(5, calc.divide(20, 4));
        assertEquals(3, calc.divide(-9, -3));
        assertEquals(-3, calc.divide(-9, 3));
    }
  
    @Test
    public void testDivideByZero() {
        Exception exception = assertThrows(IllegalArgumentException.class, () -> {
            calc.divide(10, 0);
        });
        assertEquals("Cannot divide by zero.", exception.getMessage());
    }
}
```

## Setting Up Mutation Testing with PIT

Adding PIT to Your Maven Project

Add the PIT Maven plugin to your pom.xml file:

```
<!-- File: pom.xml -->
<project>
    <!-- ... other configurations ... -->
    <build>
        <plugins>
            <!-- ... other plugins ... -->
            <plugin>
                <groupId>org.pitest</groupId>
                <artifactId>pitest-maven</artifactId>
                <version>1.9.11</version>
                <configuration>
                    <targetClasses>
                        <param>Calculator</param>
                    </targetClasses>
                    <targetTests>
                        <param>CalculatorTest</param>
                    </targetTests>
                    <!-- Additional configuration options -->
                </configuration>
            </plugin>
        </plugins>
    </build>
    <!-- ... other configurations ... -->
</project>
```

## Running Mutation Tests

Execute the following Maven command in your project’s root directory:

```bash
mvn org.pitest:pitest-maven:mutationCoverage
```

### What This Does:
- Compiles your code.
- Runs your unit tests to ensure they pass.
- Applies mutations to the target classes.
- Runs the tests against each mutant.
- Generates a mutation testing report.

### Analyzing the Results

After running the mutation tests, PIT generates an HTML report located in target/pit-reports/YYYYMMDDHHMI.

#### Report Contents

- Mutation Score: The percentage of mutants killed by your tests.
- List of Mutations: Details of each mutation, including:
- Mutant Status: Killed, Survived, No Coverage, etc.
- Mutated Class and Method: Where the mutation was applied.
- Type of Mutation: Description of the change made.

#### Interpreting the Results

- Killed Mutants: Your tests successfully detected the mutation.
- Survived Mutants: The mutation was not detected, indicating potential gaps in your test suite.
- No Coverage: The mutated code was not executed during testing.

## Improving Tests Based on Mutation Testing

**Identifying Weaknesses**

For any surviving mutants, review:
- Test Cases: Are there missing test scenarios?
- Assertions: Are the assertions specific enough?
- Exception Handling: Are exceptions properly tested?

**Example**: Enhancing the testDivideByZero Test

If a mutation in the divide method survives, consider enhancing your test:

```java
@Test
public void testDivideByZero() {
Exception exception = assertThrows(IllegalArgumentException.class, () -> {
calc.divide(10, 0);
});
assertEquals("Cannot divide by zero.", exception.getMessage());
}
```
- Check Exception Message: Ensures the specific exception and message are as expected. 
- Additional Scenarios: Test with different numerators to see if the denominator zero case is consistently handled.

**Adding Missing Tests**

If mutations in the multiply method survive, add tests:

```java
@Test
public void testMultiplyByZero() {
assertEquals(0, calc.multiply(0, 5));
assertEquals(0, calc.multiply(5, 0));
}
```

- Edge Cases: Multiplying by zero, negative numbers, etc.
- Boundary Conditions: Maximum and minimum integer values.

## Benefits:
- Enhanced Test Quality: Identify and fix weaknesses in your tests.
- Better Code Coverage: Go beyond line coverage to ensure your tests are meaningful.
- Increased Confidence: Assurance that your code behaves as expected under various conditions.
