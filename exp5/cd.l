%{
#include "control.tab.h"
%}

%%

"if"        { return IF; }
"else"      { return ELSE; }
"for"       { return FOR; }
"while"     { return WHILE; }
"switch"    { return SWITCH; }
"case"      { return CASE; }
"default"   { return DEFAULT; }

[a-zA-Z_][a-zA-Z0-9_]*    { return ID; }
[0-9]+                    { return NUM; }

"{"         { return LBRACE; }
"}"         { return RBRACE; }
"("         { return LPAREN; }
")"         { return RPAREN; }
":"         { return COLON; }
";"         { return SEMICOLON; }

"=="        { return EQ; }
"<="        { return LE; }
">="        { return GE; }
"<"         { return LT; }
">"         { return GT; }
"="         { return ASSIGN; }

[ \t\r]+    ;

\n           { return 0; }
.           { return yytext[0]; }

%%

int yywrap(void)
{
    return 1;
}