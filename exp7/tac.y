%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int tempCount = 1;
char temp[20];

void printTAC(char *result, char *op1, char *op, char *op2)
{
    printf("%s = %s %s %s\n", result, op1, op, op2);
}

int yylex(void);
int yyerror(const char *s);
%}

%union {
    char *str;
}

%token <str> ID NUM
%type <str> expr

%left '+' '-'
%left '*' '/'

%%

stmt:
      ID '=' expr '\n'
      {
          printf("%s = %s\n", $1, $3);
          free($1);
          free($3);
      }
    ;

expr:
      expr '+' expr
      {
          snprintf(temp, sizeof(temp), "t%d", tempCount++);
          printTAC(temp, $1, "+", $3);
          $$ = strdup(temp);

          free($1);
          free($3);
      }

    | expr '-' expr
      {
          snprintf(temp, sizeof(temp), "t%d", tempCount++);
          printTAC(temp, $1, "-", $3);
          $$ = strdup(temp);

          free($1);
          free($3);
      }

    | expr '*' expr
      {
          snprintf(temp, sizeof(temp), "t%d", tempCount++);
          printTAC(temp, $1, "*", $3);
          $$ = strdup(temp);

          free($1);
          free($3);
      }

    | expr '/' expr
      {
          snprintf(temp, sizeof(temp), "t%d", tempCount++);
          printTAC(temp, $1, "/", $3);
          $$ = strdup(temp);

          free($1);
          free($3);
      }

    | '(' expr ')'
      {
          $$ = $2;
      }

    | ID
      {
          $$ = $1;
      }

    | NUM
      {
          $$ = $1;
      }
    ;

%%

int main(void)
{
    printf("Enter expression (e.g., a = b + c * d):\n");
    yyparse();
    return 0;
}

int yyerror(const char *s)
{
    printf("Error: %s\n", s);
    return 0;
}