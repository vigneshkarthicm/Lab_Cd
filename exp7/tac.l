%{
#include <string.h>
#include "tac.tab.h"
%}

%%

[a-zA-Z][a-zA-Z0-9]* {
    yylval.str = strdup(yytext);
    return ID;
}

[0-9]+ {
    yylval.str = strdup(yytext);
    return NUM;
}

[ \t\r]+ {
    /* Ignore spaces, tabs and carriage returns */
}

\n {
    return '\n';
}

. {
    return yytext[0];
}

%%

int yywrap(void)
{
    return 1;
}