%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef enum {
    NUMBER, STRING, VARIABLE,
    PRINT, IF, THEN, LET, GOTO, GOSUB, RETURN,
    SYMBOL, EOL
} TokenType;

const char *name(TokenType t) {
    switch (t) {
        case NUMBER:  return "NUMBER";
        case STRING:  return "STRING";
        case VARIABLE:return "VARIABLE";
        case PRINT:   return "PRINT";
        case IF:      return "IF";
        case THEN:    return "THEN";
        case LET:     return "LET";
        case GOTO:    return "GOTO";
        case GOSUB:   return "GOSUB";
        case RETURN:  return "RETURN";
        case SYMBOL:  return "SYMBOL";
        case EOL:     return "EOL";
    }
    return "?";
}

void token(TokenType type, const char *text) {
    printf("%-8s %s\n", name(type), text);
}
%}

%option noyywrap
%option caseless

%%

[ \t]+              ;
"'"[^\n]*            ;

"REM"([ \t]|$)[^\n]* ;

"PRINT"              { token(PRINT, yytext); }
"IF"                 { token(IF, yytext); }
"THEN"               { token(THEN, yytext); }
"LET"                { token(LET, yytext); }
"GOTO"               { token(GOTO, yytext); }
"GOSUB"              { token(GOSUB, yytext); }
"RETURN"             { token(RETURN, yytext); }

[0-9]+               { token(NUMBER, yytext); }
\"[^\"]*\"           { token(STRING, yytext); }

[A-Za-z_]+           { token(VARIABLE, yytext); }

"<>"
|"<="
|">="
|"="
|"<"
|">"
|"+"
|"-"
|"*"
|"/"
|"("
|")"
|","                  { token(SYMBOL, yytext); }

\n                   { token(EOL, "\\n"); }

.                    {
    fprintf(stderr, "unexpected character: %s\n", yytext);
    exit(EXIT_FAILURE);
}

%%