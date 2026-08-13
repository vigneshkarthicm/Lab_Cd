%{
#include <stdio.h>
#include <stdlib.h>

int yylex();
int yyerror(char *);
%}

%token LET DIG

%%

variable:
        var
        ;

var:
        var DIG
      | var LET
      | LET
      ;

%%

int main()
{
    printf("Enter the variable:\n");

    if (yyparse() == 0)
        printf("Valid variable\n");

    return 0;
}

int yyerror(char *msg)
{
    printf("Invalid variable\n");
    return 0;
}