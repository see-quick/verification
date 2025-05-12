package io.model.based.testing;

import static org.junit.jupiter.api.Assertions.*;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.MethodSource;

import java.io.File;
import java.io.InputStream;
import java.net.URISyntaxException;
import java.util.List;
import java.util.Map;
import java.util.stream.Stream;

public class LightSwitchTest {

    @JsonIgnoreProperties(ignoreUnknown = true)
    static class Trace {
        public List<Map<String, Object>> states;
    }

    @ParameterizedTest
    @MethodSource("traceProvider")
    public void testTrace(String tracePath) throws Exception {
        runTrace(tracePath);
    }

    // Dynamically provide all JSON trace files from the specified resource directory.
    static Stream<String> traceProvider() {
        try {
            File directory = new File(LightSwitchTest.class.getResource("/traces/lightswitch").toURI());
            return Stream.of(directory.listFiles())
                .filter(file -> file.getName().endsWith(".json"))
                .map(file -> "/traces/lightswitch/" + file.getName());
        } catch (URISyntaxException e) {
            e.printStackTrace();
            return Stream.empty();
        }
    }

    private void runTrace(String tracePath) throws Exception {
        ObjectMapper mapper = new ObjectMapper();
        InputStream input = getClass().getResourceAsStream(tracePath);
        if (input == null) {
            throw new IllegalArgumentException("Trace file not found on classpath: " + tracePath);
        }
        Trace trace = mapper.readValue(input, Trace.class);

        LightSwitch lightSwitch = new LightSwitch();

        for (int i = 0; i < trace.states.size(); i++) {
            Map<String, Object> state = trace.states.get(i);
            String action = (String) state.get("mbt::actionTaken");
            boolean expected = (Boolean) state.get("isOn");

            // Execute action
            if (i > 0) { // skip init (state 0)
                switch (action) {
                    case "TurnOn" -> lightSwitch.turnOn();
                    case "TurnOff" -> lightSwitch.turnOff();
                    case "init" -> {} // already in initial state
                    default -> throw new IllegalArgumentException("Unknown action: " + action);
                }
            }

            // Assert that the state matches
            assertEquals(expected, lightSwitch.isOn(), "Mismatch after step " + i + " (" + action + ")");
        }
    }
}