import java.util.ArrayList;
import java.util.List;

public class MyStringStack {

    private final List<String> elements = new ArrayList<>();

    public void push(String element) {
        this.elements.add(0, element);
    }

    public String pop() {
        // we inject conscious bug
//        return this.size() >= 5 ? this.elements.remove(this.size() - 2) : this.elements.remove(0);
        return this.elements.remove(0);
    }

    public void clear() {
        // Wrong implementation to provoke falsification for stacks with more than 2 elements
        if (elements.size() > 2) {
            elements.remove(0);
        } else {
            elements.clear();
        }
//        this.elements.clear();
    }

    public int size() {
        return this.elements.size();
    }

    public boolean isEmpty() {
        return this.size() == 0;
    }

    public String top() {
        return this.size() > 0 ? this.elements.get(0) : "ERR_...";
    }
}
