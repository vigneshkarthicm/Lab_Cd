%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

/* Function prototypes */
int yylex(void);
int yyerror(char *s);
%}

%union {
    char *str;
}

%token <str> ID

%type <str> expr

/* Operator precedence */
%left '+' '-'
%left '*' '/'

%%

stmt_list:
    stmt_list stmt
    | stmt
    ;

stmt:
    ID '=' expr ';'
    {
        printf("MOV %s, AX\n\n", $1);
    }
    ;

expr:
    ID
    {
        printf("MOV AX, %s\n", $1);
        $$ = $1;
    }

    | expr '+' ID
    {
        printf("ADD AX, %s\n", $3);
        $$ = $3;
    }

    | expr '-' ID
    {
        printf("SUB AX, %s\n", $3);
        $$ = $3;
    }

    | expr '*' ID
    {
        printf("MUL %s\n", $3);
        $$ = $3;
    }

    | expr '/' ID
    {
        printf("MOV DX, 0\n");
        printf("MOV BX, %s\n", $3);
        printf("DIV BX\n");

        $$ = $3;
    }
    ;

%%

int main()
{
    printf("Enter TAC statements (end with Ctrl+D):\n");

    yyparse();

    return 0;
}

int yyerror(char *s)
{
    printf("Syntax Error: %s\n", s);

    return 0;
}