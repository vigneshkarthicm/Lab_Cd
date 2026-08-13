%{
#include <stdio.h>
#include <stdlib.h>

    int yylex();
    int yyerror(char *);
%}

%token ID DIG
%left '+' '-'
%left '*' '/'
%right UMINUS

%%
stmt:
     expn;

    expn:
          expn '+' expn
        | expn '-' expn
        | expn '*' expn
        | expn '/' expn
        | '-' expn %prec UMINUS
        | '(' expn ')'
        | DIG
        | ID
        ;

    %%

    int main()
    {
        printf("Enter the Expression\n");
        if (yyparse()==0){
            printf("Valid Expression\n");
        }
        return 0;
    }

    int yyerror(char *msg)
    {
        printf("Invalid Expression\n");
        return 0;
    }