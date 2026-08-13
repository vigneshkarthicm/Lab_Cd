%{
#include<stdio.h>
#include "ax.tab.h"
%}

%%

[a-zA-Z][0-9a-zA-Z]*    {return ID;}
[0-9]+                  {return DIG;}
[ \t]+                  ;
.                       {return yytext[0];}
\n                      {return 0;}

%%

int yywrap()
{
    return 1;
}