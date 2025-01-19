grammar OLang;

prog: expr EOF ;

expr
    : expr ('*' | '/') expr
    | expr ('+' | '-') expr
    | INT
    ;

// Lexer rules
NEWLINE : [\r\n]+ -> skip ;
INT     : [0-9]+ ;
WS      : [ \t]+ -> skip ; // Optional but recommended to handle spaces
