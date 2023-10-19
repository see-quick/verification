public class Counter {
    private int value;

    public Counter() {
        value = 0;
    }

    public void increment() {
        value++;
    }

    public void decrement() {
        if (value > 0) {
            value--;
        }
    }

    public int getValue() {
        return value;
    }

    public static void main(String[] args) {
        Counter c = new Counter();
        c.increment();
        System.out.println(c.getValue());
        c.decrement();
        System.out.println(c.getValue());
    }
}