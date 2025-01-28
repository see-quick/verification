// Generated from Unicorn.g4 by ANTLR 4.13.2
import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.misc.*;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast", "CheckReturnValue", "this-escape"})
public class UnicornLexer extends Lexer {
	static { RuntimeMetaData.checkVersion("4.13.2", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		T__0=1, T__1=2, T__2=3, T__3=4, T__4=5, T__5=6, T__6=7, T__7=8, WS=9, 
		VAR=10, IF=11, ELSE=12, WHILE=13, FUNCTION=14, RETURN=15, ASSIGN=16, PLUS=17, 
		MINUS=18, MULT=19, DIV=20, LPAREN=21, RPAREN=22, LBRACE=23, RBRACE=24, 
		UNISTOP=25, IDENTIFIER=26, NUMBER=27, STRING=28;
	public static String[] channelNames = {
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN"
	};

	public static String[] modeNames = {
		"DEFAULT_MODE"
	};

	private static String[] makeRuleNames() {
		return new String[] {
			"T__0", "T__1", "T__2", "T__3", "T__4", "T__5", "T__6", "T__7", "WS", 
			"VAR", "IF", "ELSE", "WHILE", "FUNCTION", "RETURN", "ASSIGN", "PLUS", 
			"MINUS", "MULT", "DIV", "LPAREN", "RPAREN", "LBRACE", "RBRACE", "UNISTOP", 
			"IDENTIFIER", "NUMBER", "STRING"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, "','", "'=='", "'!='", "'<'", "'<='", "'>'", "'>='", "'!'", null, 
			"'var'", "'if'", "'else'", "'while'", "'function'", "'return'", "'='", 
			"'+'", "'-'", "'*'", "'/'", "'('", "')'", "'{'", "'}'", "'\\uD83E\\uDDA4'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, null, null, null, null, null, null, null, null, "WS", "VAR", "IF", 
			"ELSE", "WHILE", "FUNCTION", "RETURN", "ASSIGN", "PLUS", "MINUS", "MULT", 
			"DIV", "LPAREN", "RPAREN", "LBRACE", "RBRACE", "UNISTOP", "IDENTIFIER", 
			"NUMBER", "STRING"
		};
	}
	private static final String[] _SYMBOLIC_NAMES = makeSymbolicNames();
	public static final Vocabulary VOCABULARY = new VocabularyImpl(_LITERAL_NAMES, _SYMBOLIC_NAMES);

	/**
	 * @deprecated Use {@link #VOCABULARY} instead.
	 */
	@Deprecated
	public static final String[] tokenNames;
	static {
		tokenNames = new String[_SYMBOLIC_NAMES.length];
		for (int i = 0; i < tokenNames.length; i++) {
			tokenNames[i] = VOCABULARY.getLiteralName(i);
			if (tokenNames[i] == null) {
				tokenNames[i] = VOCABULARY.getSymbolicName(i);
			}

			if (tokenNames[i] == null) {
				tokenNames[i] = "<INVALID>";
			}
		}
	}

	@Override
	@Deprecated
	public String[] getTokenNames() {
		return tokenNames;
	}

	@Override

	public Vocabulary getVocabulary() {
		return VOCABULARY;
	}


	public UnicornLexer(CharStream input) {
		super(input);
		_interp = new LexerATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	@Override
	public String getGrammarFileName() { return "Unicorn.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public String[] getChannelNames() { return channelNames; }

	@Override
	public String[] getModeNames() { return modeNames; }

	@Override
	public ATN getATN() { return _ATN; }

	public static final String _serializedATN =
		"\u0004\u0000\u001c\u009f\u0006\uffff\uffff\u0002\u0000\u0007\u0000\u0002"+
		"\u0001\u0007\u0001\u0002\u0002\u0007\u0002\u0002\u0003\u0007\u0003\u0002"+
		"\u0004\u0007\u0004\u0002\u0005\u0007\u0005\u0002\u0006\u0007\u0006\u0002"+
		"\u0007\u0007\u0007\u0002\b\u0007\b\u0002\t\u0007\t\u0002\n\u0007\n\u0002"+
		"\u000b\u0007\u000b\u0002\f\u0007\f\u0002\r\u0007\r\u0002\u000e\u0007\u000e"+
		"\u0002\u000f\u0007\u000f\u0002\u0010\u0007\u0010\u0002\u0011\u0007\u0011"+
		"\u0002\u0012\u0007\u0012\u0002\u0013\u0007\u0013\u0002\u0014\u0007\u0014"+
		"\u0002\u0015\u0007\u0015\u0002\u0016\u0007\u0016\u0002\u0017\u0007\u0017"+
		"\u0002\u0018\u0007\u0018\u0002\u0019\u0007\u0019\u0002\u001a\u0007\u001a"+
		"\u0002\u001b\u0007\u001b\u0001\u0000\u0001\u0000\u0001\u0001\u0001\u0001"+
		"\u0001\u0001\u0001\u0002\u0001\u0002\u0001\u0002\u0001\u0003\u0001\u0003"+
		"\u0001\u0004\u0001\u0004\u0001\u0004\u0001\u0005\u0001\u0005\u0001\u0006"+
		"\u0001\u0006\u0001\u0006\u0001\u0007\u0001\u0007\u0001\b\u0004\bO\b\b"+
		"\u000b\b\f\bP\u0001\b\u0001\b\u0001\t\u0001\t\u0001\t\u0001\t\u0001\n"+
		"\u0001\n\u0001\n\u0001\u000b\u0001\u000b\u0001\u000b\u0001\u000b\u0001"+
		"\u000b\u0001\f\u0001\f\u0001\f\u0001\f\u0001\f\u0001\f\u0001\r\u0001\r"+
		"\u0001\r\u0001\r\u0001\r\u0001\r\u0001\r\u0001\r\u0001\r\u0001\u000e\u0001"+
		"\u000e\u0001\u000e\u0001\u000e\u0001\u000e\u0001\u000e\u0001\u000e\u0001"+
		"\u000f\u0001\u000f\u0001\u0010\u0001\u0010\u0001\u0011\u0001\u0011\u0001"+
		"\u0012\u0001\u0012\u0001\u0013\u0001\u0013\u0001\u0014\u0001\u0014\u0001"+
		"\u0015\u0001\u0015\u0001\u0016\u0001\u0016\u0001\u0017\u0001\u0017\u0001"+
		"\u0018\u0001\u0018\u0001\u0019\u0001\u0019\u0005\u0019\u008d\b\u0019\n"+
		"\u0019\f\u0019\u0090\t\u0019\u0001\u001a\u0004\u001a\u0093\b\u001a\u000b"+
		"\u001a\f\u001a\u0094\u0001\u001b\u0001\u001b\u0005\u001b\u0099\b\u001b"+
		"\n\u001b\f\u001b\u009c\t\u001b\u0001\u001b\u0001\u001b\u0001\u009a\u0000"+
		"\u001c\u0001\u0001\u0003\u0002\u0005\u0003\u0007\u0004\t\u0005\u000b\u0006"+
		"\r\u0007\u000f\b\u0011\t\u0013\n\u0015\u000b\u0017\f\u0019\r\u001b\u000e"+
		"\u001d\u000f\u001f\u0010!\u0011#\u0012%\u0013\'\u0014)\u0015+\u0016-\u0017"+
		"/\u00181\u00193\u001a5\u001b7\u001c\u0001\u0000\u0004\u0003\u0000\t\n"+
		"\r\r  \u0003\u0000AZ__az\u0004\u000009AZ__az\u0001\u000009\u00a2\u0000"+
		"\u0001\u0001\u0000\u0000\u0000\u0000\u0003\u0001\u0000\u0000\u0000\u0000"+
		"\u0005\u0001\u0000\u0000\u0000\u0000\u0007\u0001\u0000\u0000\u0000\u0000"+
		"\t\u0001\u0000\u0000\u0000\u0000\u000b\u0001\u0000\u0000\u0000\u0000\r"+
		"\u0001\u0000\u0000\u0000\u0000\u000f\u0001\u0000\u0000\u0000\u0000\u0011"+
		"\u0001\u0000\u0000\u0000\u0000\u0013\u0001\u0000\u0000\u0000\u0000\u0015"+
		"\u0001\u0000\u0000\u0000\u0000\u0017\u0001\u0000\u0000\u0000\u0000\u0019"+
		"\u0001\u0000\u0000\u0000\u0000\u001b\u0001\u0000\u0000\u0000\u0000\u001d"+
		"\u0001\u0000\u0000\u0000\u0000\u001f\u0001\u0000\u0000\u0000\u0000!\u0001"+
		"\u0000\u0000\u0000\u0000#\u0001\u0000\u0000\u0000\u0000%\u0001\u0000\u0000"+
		"\u0000\u0000\'\u0001\u0000\u0000\u0000\u0000)\u0001\u0000\u0000\u0000"+
		"\u0000+\u0001\u0000\u0000\u0000\u0000-\u0001\u0000\u0000\u0000\u0000/"+
		"\u0001\u0000\u0000\u0000\u00001\u0001\u0000\u0000\u0000\u00003\u0001\u0000"+
		"\u0000\u0000\u00005\u0001\u0000\u0000\u0000\u00007\u0001\u0000\u0000\u0000"+
		"\u00019\u0001\u0000\u0000\u0000\u0003;\u0001\u0000\u0000\u0000\u0005>"+
		"\u0001\u0000\u0000\u0000\u0007A\u0001\u0000\u0000\u0000\tC\u0001\u0000"+
		"\u0000\u0000\u000bF\u0001\u0000\u0000\u0000\rH\u0001\u0000\u0000\u0000"+
		"\u000fK\u0001\u0000\u0000\u0000\u0011N\u0001\u0000\u0000\u0000\u0013T"+
		"\u0001\u0000\u0000\u0000\u0015X\u0001\u0000\u0000\u0000\u0017[\u0001\u0000"+
		"\u0000\u0000\u0019`\u0001\u0000\u0000\u0000\u001bf\u0001\u0000\u0000\u0000"+
		"\u001do\u0001\u0000\u0000\u0000\u001fv\u0001\u0000\u0000\u0000!x\u0001"+
		"\u0000\u0000\u0000#z\u0001\u0000\u0000\u0000%|\u0001\u0000\u0000\u0000"+
		"\'~\u0001\u0000\u0000\u0000)\u0080\u0001\u0000\u0000\u0000+\u0082\u0001"+
		"\u0000\u0000\u0000-\u0084\u0001\u0000\u0000\u0000/\u0086\u0001\u0000\u0000"+
		"\u00001\u0088\u0001\u0000\u0000\u00003\u008a\u0001\u0000\u0000\u00005"+
		"\u0092\u0001\u0000\u0000\u00007\u0096\u0001\u0000\u0000\u00009:\u0005"+
		",\u0000\u0000:\u0002\u0001\u0000\u0000\u0000;<\u0005=\u0000\u0000<=\u0005"+
		"=\u0000\u0000=\u0004\u0001\u0000\u0000\u0000>?\u0005!\u0000\u0000?@\u0005"+
		"=\u0000\u0000@\u0006\u0001\u0000\u0000\u0000AB\u0005<\u0000\u0000B\b\u0001"+
		"\u0000\u0000\u0000CD\u0005<\u0000\u0000DE\u0005=\u0000\u0000E\n\u0001"+
		"\u0000\u0000\u0000FG\u0005>\u0000\u0000G\f\u0001\u0000\u0000\u0000HI\u0005"+
		">\u0000\u0000IJ\u0005=\u0000\u0000J\u000e\u0001\u0000\u0000\u0000KL\u0005"+
		"!\u0000\u0000L\u0010\u0001\u0000\u0000\u0000MO\u0007\u0000\u0000\u0000"+
		"NM\u0001\u0000\u0000\u0000OP\u0001\u0000\u0000\u0000PN\u0001\u0000\u0000"+
		"\u0000PQ\u0001\u0000\u0000\u0000QR\u0001\u0000\u0000\u0000RS\u0006\b\u0000"+
		"\u0000S\u0012\u0001\u0000\u0000\u0000TU\u0005v\u0000\u0000UV\u0005a\u0000"+
		"\u0000VW\u0005r\u0000\u0000W\u0014\u0001\u0000\u0000\u0000XY\u0005i\u0000"+
		"\u0000YZ\u0005f\u0000\u0000Z\u0016\u0001\u0000\u0000\u0000[\\\u0005e\u0000"+
		"\u0000\\]\u0005l\u0000\u0000]^\u0005s\u0000\u0000^_\u0005e\u0000\u0000"+
		"_\u0018\u0001\u0000\u0000\u0000`a\u0005w\u0000\u0000ab\u0005h\u0000\u0000"+
		"bc\u0005i\u0000\u0000cd\u0005l\u0000\u0000de\u0005e\u0000\u0000e\u001a"+
		"\u0001\u0000\u0000\u0000fg\u0005f\u0000\u0000gh\u0005u\u0000\u0000hi\u0005"+
		"n\u0000\u0000ij\u0005c\u0000\u0000jk\u0005t\u0000\u0000kl\u0005i\u0000"+
		"\u0000lm\u0005o\u0000\u0000mn\u0005n\u0000\u0000n\u001c\u0001\u0000\u0000"+
		"\u0000op\u0005r\u0000\u0000pq\u0005e\u0000\u0000qr\u0005t\u0000\u0000"+
		"rs\u0005u\u0000\u0000st\u0005r\u0000\u0000tu\u0005n\u0000\u0000u\u001e"+
		"\u0001\u0000\u0000\u0000vw\u0005=\u0000\u0000w \u0001\u0000\u0000\u0000"+
		"xy\u0005+\u0000\u0000y\"\u0001\u0000\u0000\u0000z{\u0005-\u0000\u0000"+
		"{$\u0001\u0000\u0000\u0000|}\u0005*\u0000\u0000}&\u0001\u0000\u0000\u0000"+
		"~\u007f\u0005/\u0000\u0000\u007f(\u0001\u0000\u0000\u0000\u0080\u0081"+
		"\u0005(\u0000\u0000\u0081*\u0001\u0000\u0000\u0000\u0082\u0083\u0005)"+
		"\u0000\u0000\u0083,\u0001\u0000\u0000\u0000\u0084\u0085\u0005{\u0000\u0000"+
		"\u0085.\u0001\u0000\u0000\u0000\u0086\u0087\u0005}\u0000\u0000\u00870"+
		"\u0001\u0000\u0000\u0000\u0088\u0089\u0005\u8001\uf9a4\u0000\u0000\u0089"+
		"2\u0001\u0000\u0000\u0000\u008a\u008e\u0007\u0001\u0000\u0000\u008b\u008d"+
		"\u0007\u0002\u0000\u0000\u008c\u008b\u0001\u0000\u0000\u0000\u008d\u0090"+
		"\u0001\u0000\u0000\u0000\u008e\u008c\u0001\u0000\u0000\u0000\u008e\u008f"+
		"\u0001\u0000\u0000\u0000\u008f4\u0001\u0000\u0000\u0000\u0090\u008e\u0001"+
		"\u0000\u0000\u0000\u0091\u0093\u0007\u0003\u0000\u0000\u0092\u0091\u0001"+
		"\u0000\u0000\u0000\u0093\u0094\u0001\u0000\u0000\u0000\u0094\u0092\u0001"+
		"\u0000\u0000\u0000\u0094\u0095\u0001\u0000\u0000\u0000\u00956\u0001\u0000"+
		"\u0000\u0000\u0096\u009a\u0005\"\u0000\u0000\u0097\u0099\t\u0000\u0000"+
		"\u0000\u0098\u0097\u0001\u0000\u0000\u0000\u0099\u009c\u0001\u0000\u0000"+
		"\u0000\u009a\u009b\u0001\u0000\u0000\u0000\u009a\u0098\u0001\u0000\u0000"+
		"\u0000\u009b\u009d\u0001\u0000\u0000\u0000\u009c\u009a\u0001\u0000\u0000"+
		"\u0000\u009d\u009e\u0005\"\u0000\u0000\u009e8\u0001\u0000\u0000\u0000"+
		"\u0005\u0000P\u008e\u0094\u009a\u0001\u0006\u0000\u0000";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}