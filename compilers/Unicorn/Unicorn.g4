// Unicorn-language Grammar
grammar Unicorn;

// Lexer rules
WS          : [ \t\r\n]+ -> skip ;

// Keywords
VAR         : 'var';
IF          : 'if';
ELSE        : 'else';
WHILE       : 'while';
FUNCTION    : 'function';
RETURN      : 'return';

// Operators and symbols
ASSIGN      : '=';
PLUS        : '+';
MINUS       : '-';
MULT        : '*';
DIV         : '/';
LPAREN      : '(';
RPAREN      : ')';
LBRACE      : '{';
RBRACE      : '}';
UNISTOP     : '\ud83e\udda4'; // 🦄

// Identifiers and literals
IDENTIFIER  : [a-zA-Z_] [a-zA-Z_0-9]*;
NUMBER      : [0-9]+;
STRING      : '"' .*? '"';

// Parser rules
program     : statement* ;

statement   : variableDeclaration
            | functionDeclaration
            | ifStatement
            | whileStatement
            | returnStatement
            | expressionStatement ;

variableDeclaration
            : VAR IDENTIFIER (ASSIGN expression)? UNISTOP ;

functionDeclaration
            : FUNCTION IDENTIFIER LPAREN (IDENTIFIER (',' IDENTIFIER)*)? RPAREN block ;

ifStatement : IF LPAREN expression RPAREN block (ELSE block)? ;

whileStatement
            : WHILE LPAREN expression RPAREN block ;

returnStatement
            : RETURN expression? UNISTOP ;

expressionStatement
            : expression UNISTOP ;

expression  : assignment ;

assignment  : IDENTIFIER ASSIGN expression
            | equality ;

equality    : comparison (('==' | '!=') comparison)* ;

comparison  : term (('<' | '<=' | '>' | '>=') term)* ;

term        : factor (('+' | '-') factor)* ;

factor      : unary (('*' | '/') unary)* ;

unary       : ('-' | '!') unary
            | primary ;

primary     : NUMBER
            | STRING
            | IDENTIFIER
            | LPAREN expression RPAREN ;

block       : LBRACE statement* RBRACE ;

