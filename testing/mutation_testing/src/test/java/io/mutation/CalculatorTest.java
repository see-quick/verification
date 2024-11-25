package io.mutation;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

public class CalculatorTest {
    private static Calculator calc;

    @BeforeAll
    public static void setUp() {
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
        assertThrows(IllegalArgumentException.class, () -> {
            calc.divide(10, 0);
        });
    }
}