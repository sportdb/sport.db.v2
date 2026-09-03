%{
#include <stdio.h>
#include <string.h>

void keyword_or_variable(const char *s) {
    if      (!strcasecmp(s, "PRINT"))  puts("PRINT");
    else if (!strcasecmp(s, "IF"))     puts("IF");
    else if (!strcasecmp(s, "THEN"))   puts("THEN");
    else if (!strcasecmp(s, "LET"))    puts("LET");
    else if (!strcasecmp(s, "GOTO"))   puts("GOTO");
    else if (!strcasecmp(s, "GOSUB"))  puts("GOSUB");
    else if (!strcasecmp(s, "RETURN")) puts("RETURN");
    else                               puts("VARIABLE");
}
%}

%option noyywrap

%%

[ \t]+                  ;
"'"[^\n]*               ;
[Rr][Ee][Mm]([ \t]|$)[^\n]* ;

[0-9]+                  { puts("NUMBER"); }
\"[^\"]*\"              { puts("STRING"); }

[A-Za-z_]+              { keyword_or_variable(yytext); }

"<>"
|"<="
|">="
|"="
|"<"
|">"
|"+"|"-"|"*"|"/"
|"("|")"|","             { puts("SYMBOL"); }

\n                      { puts("EOL"); }

.                       { fprintf(stderr, "bad character: %s\n", yytext); }

%%