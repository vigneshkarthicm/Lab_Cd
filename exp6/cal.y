%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
int yyerror(const char *s);
%}

%union {
    double dval;
}

%token <dval> NUM
%type <dval> expr

%left '+' '-'
%left '*' '/'
%right UMINUS

%%

input
    : /* empty */
    | input line
    ;

line
    : '\n'
    | expr '\n' { printf("Answer: %.2f\n", $1); }
    | expr      { printf("Answer: %.2f\n", $1); }
    ;

expr
    : expr '+' expr     { $$ = $1 + $3; }
    | expr '-' expr     { $$ = $1 - $3; }
    | expr '*' expr     { $$ = $1 * $3; }
    | expr '/' expr     { $$ = $1 / $3; }
    | '(' expr ')'       { $$ = $2; }
    | '-' expr %prec UMINUS { $$ = -$2; }
    | NUM                { $$ = $1; }
    ;

%%

int main(void)
{
    printf("Enter the expression:\n");
    yyparse();
    return 0;
}

int yyerror(const char *s)
{
    printf("%s\n", s);
    return 0;
}