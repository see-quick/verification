import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;
import java.nio.file.*;

public class Main {
    public static void main(String[] args) throws Exception {
        // Check if a file path is provided
        if (args.length != 1) {
            System.err.println("Usage: java UnicornMain <source_file>");
            return;
        }

        // Read the Unicorn-language source file
        String sourceFilePath = args[0];
        String unicornCode = Files.readString(Path.of(sourceFilePath));

        // Create a lexer and parser
        UnicornLexer lexer = new UnicornLexer(CharStreams.fromString(unicornCode));
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        UnicornParser parser = new UnicornParser(tokens);

        // Parse the input and generate the parse tree
        ParseTree tree = parser.program();

        // Create and apply the visitor
        UnicornToJavaVisitor visitor = new UnicornToJavaVisitor();
        String javaCode = visitor.visit(tree);

        // Output the translated Java code
        System.out.println("Generated Java Code:");
        System.out.println(javaCode);
    }
}

