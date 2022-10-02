import net.jqwik.api.Arbitraries;
import net.jqwik.api.Arbitrary;
import net.jqwik.api.ForAll;
import net.jqwik.api.Property;
import net.jqwik.api.Provide;
import net.jqwik.api.state.Action;
import net.jqwik.api.state.ActionChain;
import net.jqwik.api.state.Transformer;
import org.hamcrest.CoreMatchers;
import org.hamcrest.MatcherAssert;
import org.hamcrest.Matchers;

public class MyStackActions {

    static class PushAction implements Action.Independent<MyStringStack> {
        @Override
        public Arbitrary<Transformer<MyStringStack>> transformer() {
            Arbitrary<String> pushElements = Arbitraries.strings().alpha().ofLength(5);
            return pushElements.map(element -> Transformer.mutate(
                String.format("push(%s)", element),
                stack -> {
                    int sizeBefore = stack.size();
                    stack.push(element);

                    MatcherAssert.assertThat(stack.isEmpty(), CoreMatchers.is(Boolean.FALSE));
                    MatcherAssert.assertThat(stack.size(), CoreMatchers.is(sizeBefore + 1));

                }
            ));
        }
    }

    private Action<MyStringStack> pop() {
        return Action.<MyStringStack>when(stack -> !stack.isEmpty())
            .describeAs("pop")
            .justMutate(stack -> {
                int sizeBefore = stack.size();
                String topBefore = stack.top();

                String popped = stack.pop();
                MatcherAssert.assertThat(popped, CoreMatchers.is(topBefore));
                MatcherAssert.assertThat(stack.size(), CoreMatchers.is(sizeBefore - 1));
            });
    }

    static class ClearAction extends Action.JustMutate<MyStringStack> {
        @Override
        public void mutate(MyStringStack stack) {
            stack.clear();
            MatcherAssert.assertThat(stack.isEmpty(), CoreMatchers.is(Boolean.TRUE));
        }

        @Override
        public String description() {
            return "clear";
        }
    }

    @Property
    void checkMyStack(@ForAll("myStackActions") ActionChain<MyStringStack> chain) {
        chain.run();
    }

    /**
     * From the STATE MACHINE perspective invariant is a rule that should never be violated in any case. Meaning if
     * we perform multiple actions in each sequence. Defined invariant must always hold! Here is the example of such
     * invariant for Stack.
     *
     * @param   chain   explicit defined invariant for our needs
     */
    @Property
    void checkMyStackWithInvariant(@ForAll("myStackActions") ActionChain<MyStringStack> chain) {
        chain
            .withInvariant("greater", stack -> MatcherAssert.assertThat(stack.size(), Matchers.greaterThanOrEqualTo(0)))
            .withInvariant("less", stack -> MatcherAssert.assertThat(stack.size(), Matchers.lessThan(5))) // Does not hold!
            .run();
    }

    @Provide
    Arbitrary<ActionChain<MyStringStack>> myStackActions() {
        return ActionChain.startWith(MyStringStack::new)
            .addAction(new PushAction())
            .addAction(pop())
            .addAction(new ClearAction());
    }
}
